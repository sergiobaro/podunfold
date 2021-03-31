import Foundation

enum ArgsCommand: Equatable {
  case unfold(configFilePath: String, configName: String?)
  case clone(configFilePath: String, podName: String, destinationFolder: String?)
  case pull(folder: String?)
}

enum ArgsParserError: LocalizedError {
  case commandNotFound(String)
  case podNameMissing

  var errorDescription: String? {
    switch self {
    case .commandNotFound(let name):
      return "Command '\(name)' not found"
    case .podNameMissing:
      return "PodName is missing\nUsage: podunfold clone <PodName>"
    }
  }
}

protocol CommandArgsParser {
  var name: String { get }
  func parse(args: [String]) throws -> ArgsCommand
}

class ArgsParser {
  
  private let commandParsers: [CommandArgsParser] = [
    CloneCommandArgsParser(),
    PullCommandArgsParser(),
    UnfoldCommandArgsParser()
  ]

  func parse(args: [String]) throws -> ArgsCommand {
    if args.isEmpty {
      return Constants.defaultArgs
    }
    
    guard let parser = findParser(for: args) else {
      throw ArgsParserError.commandNotFound(args[0])
    }
    return try parser.parse(args: args)
  }
  
  private func findParser(for args: [String]) -> CommandArgsParser? {
    commandParsers.first(where: { $0.name == args[0] }) ?? commandParsers.last
  }
}
