import Foundation

struct UnfoldCommandArgsParser: CommandArgsParser {
  
  let name = "unfold"
  
  func parse(args: [String]) throws -> ArgsCommand {
    guard let firstArg = args[at: 0] else {
      return .unfold(configFilePath: Constants.defaultConfigFile, configName: nil)
    }
    
    if firstArg.hasSuffix(".yml") {
      return .unfold(configFilePath: firstArg, configName: args[at: 1])
    }
    
    return .unfold(configFilePath: Constants.defaultConfigFile, configName: firstArg)
  }
}
