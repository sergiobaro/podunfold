import Foundation

enum ArgsCommand: Equatable {
  case unfold(configFilePath: String, configName: String?)
  case clone(configFilePath: String, podName: String)
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
      return ArgsCommand.unfold(configFilePath: Self.defaultConfigFile, configName: nil)
    }

    if args[0] == "clone" {
      guard let podName = args.second else {
        throw ArgsParserError.podNameMissing
      }
      return ArgsCommand.clone(configFilePath: Self.defaultConfigFile, podName: podName)
    }

    return ArgsCommand.unfold(configFilePath: args[0], configName: args.second)
  }
}

private extension Array {

  var second: Element? {
    indices.contains(1) ? self[1] : nil
  }
}

/*
 podunfold unfold config.yml config
 podunfold unfold config.yml
 podunfold unfold config
 podunfold config.yml config
 podunfold config.yml
 podunfold config

 podunfold clone config.yml pod
 podunfold clone config.yml
 podunfold clone pod
 podunfold clone
 */
