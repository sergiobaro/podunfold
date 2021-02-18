import Foundation
import PodPatchLib

enum PodfilePatcherError: LocalizedError {
  case appNotFound(podName: String)
  case podNotFound(configName: String)
  case configNotFound(podName: String, configName: String)
  
  var errorDescription: String? {
    switch self {
    case .podNotFound(let podName):
      return "Pod with name '\(podName)' not found in Podfile"
    case .appNotFound(let configName):
      return "App not found for config with name '\(configName)'"
    case .configNotFound(let podName, let configName):
      return "Config not found for pod with name '\(podName)' in config '\(configName)'"
    }
  }
}

class PodfilePatcher {
  
  private let files: Files
  private let shell: Shell
  
  init(files: Files, shell: Shell) {
    self.files = files
    self.shell = shell
  }
  
  func patch(config: Config, pods: [PodConfig]) throws {
    guard let hostConfig = PodHostFinder.findHost(config: config, podConfigs: pods) else {
      throw PodfilePatcherError.appNotFound(podName: config.name)
    }
    
    shell.echo("Patching Podfile: \(hostConfig.name)")
    let appPath = PodHostFinder.buildHostPath(files: files, hostConfig: hostConfig)
    
    shell.echo("Moving to: \(appPath)")
    let originDirectoryPath = files.currentFolder
    files.changeCurrentFolder(appPath)
    
    for podName in config.pods.keys {
      if podName == hostConfig.name { continue }
      
      let podLocalPath = hostConfig.type == .example ? "../../\(podName)" : "../\(podName)"
      try PodPatch().run([podName, "path:\(podLocalPath)"])
    }
    
    shell.run("pod install")
    
    files.changeCurrentFolder(originDirectoryPath)
  }
}
