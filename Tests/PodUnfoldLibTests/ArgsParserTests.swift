import XCTest
import Nimble
@testable import PodUnfoldLib

class ArgsParserTests: XCTestCase {

  let parser = ArgsParser()

  func test_parse_noOptions() throws {
    let args = try parser.parse(args: [])

    guard case let ArgsCommand.unfold(configFilePath: configFilePath, configName: configName) = args else {
      fail("args is not an unfold")
      return
    }

    expect(configFilePath) == ArgsParser.defaultConfigFile
    expect(configName).to(beNil())
  }

  func test_parse_onlyConfigFile() throws {
    let args = try parser.parse(args: ["configFile"])

    guard case let ArgsCommand.unfold(configFilePath: configFilePath, configName: configName) = args else {
      fail("args is not an unfold")
      return
    }

    expect(configFilePath) == "configFile"
    expect(configName).to(beNil())
  }

  func test_parse_configFileAndConfigName() throws {
    let args = try parser.parse(args: ["configFile", "configName"])

    guard case let ArgsCommand.unfold(configFilePath: configFilePath, configName: configName) = args else {
      fail("args is not an unfold")
      return
    }

    expect(configFilePath) == "configFile"
    expect(configName) == "configName"
  }

  func test_parse_clone() throws {
    let args = try parser.parse(args: ["clone", "PodName"])

    guard case let ArgsCommand.clone(configFilePath: configFilePath, podName: podName) = args else {
      fail("args is not a clone")
      return
    }

    expect(configFilePath) == ArgsParser.defaultConfigFile
    expect(podName) == "PodName"
  }

  func test_parse_clone_withoutPodName() throws {
    expect(try self.parser.parse(args: ["clone"])).to(throwError(ArgsParserError.podNameMissing))
  }
}
