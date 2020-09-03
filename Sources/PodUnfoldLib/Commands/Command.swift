import Foundation

protocol Command {
  func execute() throws
}

class CommandFactory {

  func command(for args: ArgsCommand) -> Command {
    switch args {
    case let .unfold(args: unfoldArgs):
      return UnfoldCommand(args: unfoldArgs)
    case let .clone(args: cloneArgs):
      return CloneCommand(args: cloneArgs)
    }
  }
}
