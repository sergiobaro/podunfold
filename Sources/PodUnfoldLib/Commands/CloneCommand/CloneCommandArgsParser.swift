import Foundation

struct CloneCommandArgsParser: CommandArgsParser {
  
  let name = "clone"
  
  func parse(args: [String]) throws -> ArgsCommand {
    guard let podName = args[at: 1] else {
      throw ArgsParserError.podNameMissing
    }
    return .clone(configFilePath: Constants.defaultConfigFile, podName: podName, destinationFolder: args[at: 2])
  }
}
