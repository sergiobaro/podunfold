import Foundation

public class PodUnfold {

  public init() { }

  public func run(args: [String]) throws {
    let args = try ArgsParser().parse(args: args)
    let command = try CommandFactory().command(for: args)
    try command.execute()
  }
}
