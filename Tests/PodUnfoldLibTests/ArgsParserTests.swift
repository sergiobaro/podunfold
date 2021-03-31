import XCTest
import Nimble
@testable import PodUnfoldLib

class ArgsParserTests: XCTestCase {
  
  let parser = ArgsParser()
  
  // MARK: - Unfold
  
  // $ podunfold
  func test_parse_noOptions() throws {
    let args = try parser.parse(args: [])
    
    expect(args) == ArgsCommand.unfold(configFilePath: Constants.defaultConfigFile, configName: nil)
  }
  
  // $ podunfold configFile.yml
  func test_parse_onlyConfigFile() throws {
    let args = try parser.parse(args: ["configFile.yml"])
    
    expect(args) == ArgsCommand.unfold(configFilePath: "configFile.yml", configName: nil)
  }
  
  // $ podunfold configFile.yml configName
  func test_parse_configFileAndConfigName() throws {
    let args = try parser.parse(args: ["configFile.yml", "configName"])
    
    expect(args) == ArgsCommand.unfold(configFilePath: "configFile.yml", configName: "configName")
  }
  
  // MARK: - Clone
  
  // $ podunfold clone
  func test_parse_clone_withoutPodName() throws {
    expect(try self.parser.parse(args: ["clone"])).to(throwError(ArgsParserError.podNameMissing))
  }
  
  // $ podunfold clone podName
  func test_parse_clone() throws {
    let args = try parser.parse(args: ["clone", "podName"])
    
    expect(args) == ArgsCommand.clone(
      configFilePath: Constants.defaultConfigFile,
      podName: "podName",
      destinationFolder: nil
    )
  }
  
  // $ podunfold clone podName folder
  func test_parse_clone_withFolder() throws {
    let args = try parser.parse(args: ["clone", "podName", "folder"])
    
    expect(args) == ArgsCommand.clone(
      configFilePath: Constants.defaultConfigFile,
      podName: "podName",
      destinationFolder: "folder"
    )
  }
  
  // MARK: - Pull
  
  // $ podunfold pull
  func test_parse_pull() throws {
    let args = try parser.parse(args: ["pull"])
    
    expect(args).to(equal(ArgsCommand.pull(folder: nil)))
  }
  
  // $ podunfold pull folder
  func test_parse_pull_withFolder() throws {
    let args = try parser.parse(args: ["pull", "folder"])
    
    expect(args) == ArgsCommand.pull(folder: "folder")
  }
}
