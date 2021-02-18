import Foundation

enum UnfoldCommandError: LocalizedError {
  case configNotFound(configName: String)
  case podNotFound(podName: String, configName: String)

  var errorDescription: String? {
    switch self {
    case .configNotFound(let configName):
      return "Config with name '\(configName)' not found."
    case .podNotFound(let podName, let configName):
      return "Pod with name '\(podName)' not found in config '\(configName)'."
    }
  }
}

class UnfoldCommand: Command {

  private let configFile: ConfigFile
  private let configName: String?
  private let files: Files
  private let shell: Shell

  init(configFile: ConfigFile, configName: String?, files: Files, shell: Shell) {
    self.configFile = configFile
    self.configName = configName
    self.files = files
    self.shell = shell
  }
  
  func execute() throws {
    if let configName = configName {
      try execute(configName: configName, configFile: configFile)
    } else {
      let configName = presentConfigOptions(configFile)
      try execute(configName: configName, configFile: configFile)
    }
  }
  
  private func presentConfigOptions(_ configFile: ConfigFile) -> String {
    var selectedConfigName: String?
    
    while selectedConfigName == nil {
      for (index, config) in configFile.configs.enumerated() {
        if config.name.isEmpty { continue }
        shell.echo("\(index + 1): \(config.name)")
      }
      
      if let input = shell.ask("Select a configuration: "),
        let configOption = Int(input),
        configFile.configs.indices.contains(configOption - 1) {
        selectedConfigName = configFile.configs[configOption - 1].name
      } else {
        shell.echo("")
      }
    }
    
    return selectedConfigName!
  }
  
  private func execute(configName: String, configFile: ConfigFile) throws {
    guard let config = configFile.configs.first(where: { $0.name == configName }) else {
      throw UnfoldCommandError.configNotFound(configName: configName)
    }
    
    try createAndMoveToFolder(config.name)
    try clonePods(config: config, pods: configFile.pods)
    try PodfilePatcher(files: files, shell: shell)
      .patch(config: config, pods: configFile.pods)
  }
  
  private func createAndMoveToFolder(_ folder: String) throws {
    let currentFolder = files.currentFolder
    let destinationFolder = currentFolder + "/" + folder
    
    if files.exists(destinationFolder) {
      try files.delete(destinationFolder)
      shell.echo("Deleted: \(destinationFolder)")
    }
    shell.echo("Moving to: \(destinationFolder)")
    try files.createFolder(destinationFolder)
    files.changeCurrentFolder(destinationFolder)
  }
  
  private func clonePods(config: Config, pods: [PodConfig]) throws {
    for (podName, branch) in config.pods {
      guard let podConfig = pods.first(where: { $0.name == podName }) else {
        throw UnfoldCommandError.podNotFound(podName: podName, configName: config.name)
      }
      
      shell.echo("Working on pod: \(podName)")
      let command = gitCommand(config: config, podConfig: podConfig, branch: branch)
      shell.run(command)
    }
  }

  private func gitCommand(config: Config, podConfig: PodConfig, branch: String) -> String {
    let builder = GitBuilder()
      .clone(url: podConfig.gitUrl)
      .folder(podConfig.name)
      .branch(branch)

    if config.shallow ?? Constants.defaultShallow {
      builder.depth(1)
    }

    return builder.build()
  }
}
