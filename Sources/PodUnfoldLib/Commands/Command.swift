import Foundation

protocol Command {
  func execute() throws
}

class CommandFactory {

  func command(for args: ArgsCommand) -> Command {
    switch args {
    case let .unfold(configFilePath: configFilePath, configName: configName):
      return UnfoldCommand(configFilePath: configFilePath, configName: configName)
    case let .clone(configFilePath: configFilePath, podName: podName, destinationFolder: destinationFolder):
      return CloneCommand(configFilePath: configFilePath, podName: podName, destinationFolder: destinationFolder)
    }
  }
}
