import Foundation

class PullCommandArgsParser: CommandArgsParser {
  
  let name = "pull"
  
  func parse(args: [String]) throws -> ArgsCommand {
    .pull(folder: args[at: 1])
  }
}
