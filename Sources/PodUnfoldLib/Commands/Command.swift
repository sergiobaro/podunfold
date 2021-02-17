import Foundation

protocol Command {
  func execute() throws
}

class CommandFactory {

  func command(for args: ArgsCommand) throws -> Command {
    switch args {
    
    // unfold
    case let .unfold(configFilePath: configFilePath, configName: configName):
      let configFile = try ConfigParser().parse(configPathFile: configFilePath)
      return UnfoldCommand(
        configFile: configFile,
        configName: configName,
        files: FilesDefault(),
        shell: ShellDefault(),
        logger: TerminalLogger()
      )
      
    // clone
    case let .clone(configFilePath: configFilePath, podName: podName, destinationFolder: destinationFolder):
      let configFile = try ConfigParser().parse(configPathFile: configFilePath)
      return CloneCommand(
        configFile: configFile,
        podName: podName,
        destinationFolder: destinationFolder,
        shell: ShellDefault()
      )
    }
  }
}
