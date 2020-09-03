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

struct CloneCommandArgs: Equatable {
  let configFilePath: String
  let podName: String
  let destinationFolder: String?
}

class CloneCommand: Command {

  private let args: CloneCommandArgs

  init(args: CloneCommandArgs) {
    self.args = args
  }

  func execute() throws {
    let configFile = try ConfigParser().parse(configPathFile: args.configFilePath)

    guard let podConfig = findPodConfig(args.podName, in: configFile.pods) else {
      throw CloneCommandError.podNotFound(args.podName, args.configFilePath)
    }

    let command = GitBuilder().clone(url: podConfig.gitUrl)
      .folder(args.destinationFolder ?? args.podName)
      .build()
    Shell.run(command)
  }

  private func findPodConfig(_ podName: String, in pods: [PodConfig]) -> PodConfig? {
    pods.first { $0.name == podName }
  }
}
