import Foundation

enum CloneCommandError: LocalizedError {
  case podNotFound(String, String)

  var errorDescription: String? {
    switch self {
    case let .podNotFound(podName, configFilePath):
      return "Pod with name \(podName) not found in config file \(configFilePath)"
    }
  }
}

class CloneCommand: Command {

  private let configFilePath: String
  private let podName: String
  private let destinationFolder: String?

  init(configFilePath: String, podName: String, destinationFolder: String?) {
    self.configFilePath = configFilePath
    self.podName = podName
    self.destinationFolder = destinationFolder
  }

  func execute() throws {
    let configFile = try ConfigParser().parse(configPathFile: configFilePath)

    guard let podConfig = findPodConfig(podName, in: configFile.pods) else {
      throw CloneCommandError.podNotFound(podName, configFilePath)
    }

    let command = GitBuilder().clone(url: podConfig.gitUrl)
      .folder(destinationFolder ?? podName)
      .build()
    Shell.run(command)
  }

  private func findPodConfig(_ podName: String, in pods: [PodConfig]) -> PodConfig? {
    pods.first { $0.name == podName }
  }
}
