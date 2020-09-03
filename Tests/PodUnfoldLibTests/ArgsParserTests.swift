import XCTest
import Nimble
@testable import PodUnfoldLib

class ArgsParserTests: XCTestCase {

  let parser = ArgsParser()

  // MARK: - Unfold

  // $ podunfold
  func test_parse_noOptions() throws {
    let args = try parser.parse(args: [])

    guard case let ArgsCommand.unfold(args: unfoldArgs) = args else {
      fail("args is not unfold")
      return
    }

    expect(unfoldArgs.configFilePath) == ArgsParser.defaultConfigFile
    expect(unfoldArgs.configName).to(beNil())
  }

  // $ podunfold configFile.yml
  func test_parse_onlyConfigFile() throws {
    let args = try parser.parse(args: ["configFile.yml"])

    guard case let ArgsCommand.unfold(args: unfoldArgs) = args else {
      fail("args is not unfold")
      return
    }

    expect(unfoldArgs.configFilePath) == "configFile.yml"
    expect(unfoldArgs.configName).to(beNil())
  }

  // $ podunfold configFile.yml configName
  func test_parse_configFileAndConfigName() throws {
    let args = try parser.parse(args: ["configFile.yml", "configName"])

    guard case let ArgsCommand.unfold(args: unfoldArgs) = args else {
      fail("args is not unfold")
      return
    }

    expect(unfoldArgs.configFilePath) == "configFile.yml"
    expect(unfoldArgs.configName) == "configName"
  }

  // MARK: - Clone

  // $ podunfold clone
  func test_parse_clone_withoutPodName() throws {
    expect(try self.parser.parse(args: ["clone"])).to(throwError(ArgsParserError.podNameMissing))
  }

  // $ podunfold clone podName
  func test_parse_clone() throws {
    let args = try parser.parse(args: ["clone", "podName"])

    guard case let ArgsCommand.clone(args: cloneArgs) = args else {
      fail("args is not clone")
      return
    }

    expect(cloneArgs.configFilePath) == ArgsParser.defaultConfigFile
    expect(cloneArgs.podName) == "podName"
    expect(cloneArgs.destinationFolder).to(beNil())
  }

  // $ podunfold clone podName folder
  func test_parse_clone_withFolder() throws {
    let args = try parser.parse(args: ["clone", "podName", "folder"])

    guard case let ArgsCommand.clone(args: cloneArgs) = args else {
      fail("args is not clone")
      return
    }

    expect(cloneArgs.configFilePath) == ArgsParser.defaultConfigFile
    expect(cloneArgs.podName) == "podName"
    expect(cloneArgs.destinationFolder) == "folder"
  }
}
