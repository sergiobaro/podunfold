import Foundation

enum ArgsCommand: Equatable {
  case unfold(args: UnfoldCommandArgs)
  case clone(args: CloneCommandArgs)
}

enum ArgsParserError: LocalizedError {
  case podNameMissing

  var errorDescription: String? {
    switch self {
    case .podNameMissing:
      return "PodName is missing\nUsage: podunfold clone <PodName>"
    }
  }
}

class ArgsParser {

  static let defaultConfigFile = "unfold.yml"

  func parse(args: [String]) throws -> ArgsCommand {
    if args.count == 0 {
      return ArgsCommand.unfold(args: .default)
    }

    if args[0] == "clone" {
      guard let podName = args[at: 1] else {
        throw ArgsParserError.podNameMissing
      }
      let cloneArgs = CloneCommandArgs(configFilePath: Self.defaultConfigFile,
                                       podName: podName,
                                       destinationFolder: args[at: 2])
      return ArgsCommand.clone(args: cloneArgs)
    }

    let unfoldArgs = UnfoldCommandArgs(configFilePath: args[0], configName: args[at: 1])
    return ArgsCommand.unfold(args: unfoldArgs)
  }
}

private extension Array {

  subscript(at index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
