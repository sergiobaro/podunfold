import Foundation

enum CloneCommandError: LocalizedError {
  case podNotFound(String)

  var errorDescription: String? {
    switch self {
    case let .podNotFound(podName):
      return "Pod with name \(podName) not found in configuration file"
    }
  }
}

class CloneCommand: Command {

  private let configFile: ConfigFile
  private let podName: String
  private let destinationFolder: String?
  private let shell: Shell

  init(configFile: ConfigFile, podName: String, destinationFolder: String?, shell: Shell) {
    self.configFile = configFile
    self.podName = podName
    self.destinationFolder = destinationFolder
    self.shell = shell
  }

  func execute() throws {
    guard let podConfig = findPodConfig(podName, in: configFile.pods) else {
      throw CloneCommandError.podNotFound(podName)
    }

    let command = GitBuilder().clone(url: podConfig.gitUrl)
      .folder(destinationFolder ?? podName)
      .build()
    shell.run(command)
  }

  private func findPodConfig(_ podName: String, in pods: [PodConfig]) -> PodConfig? {
    pods.first { $0.name == podName }
  }
}
