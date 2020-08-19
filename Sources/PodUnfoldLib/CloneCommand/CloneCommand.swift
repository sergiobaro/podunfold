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

  init(configFilePath: String, podName: String) {
    self.configFilePath = configFilePath
    self.podName = podName
  }

  func execute() throws {
    let configFile = try ConfigParser().parse(configPathFile: configFilePath)

    guard let podConfig = findPodConfig(podName, in: configFile.pods) else {
      throw CloneCommandError.podNotFound(podName, configFilePath)
    }

    Shell.run("git clone \(podConfig.gitUrl) \(podName)")
  }

  private func findPodConfig(_ podName: String, in pods: [PodConfig]) -> PodConfig? {
    pods.first { $0.name == podName }
  }
}
