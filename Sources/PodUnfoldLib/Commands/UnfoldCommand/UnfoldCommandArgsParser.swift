import Foundation

struct UnfoldCommandArgsParser: CommandArgsParser {
  
  let name = "unfold"
  
  func parse(args: [String]) throws -> ArgsCommand {
    .unfold(configFilePath: args[0], configName: args[at: 1])
  }
}
