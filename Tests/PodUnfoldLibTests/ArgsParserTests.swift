import XCTest
import Nimble
@testable import PodUnfoldLib

class ArgsParserTests: XCTestCase {
    
    let parser = ArgsParser()
    
    func test_parse_noOptions() throws {
        let args = try parser.parse(args: [])
        expect(args.configFilePath) == ArgsParser.defaultConfigFile
        expect(args.configName).to(beNil())
    }
    
    func test_parse_onlyConfigFile() throws {
        let args = try parser.parse(args: ["configFile"])
        expect(args.configFilePath) == "configFile"
        expect(args.configName).to(beNil())
    }
    
    func test_parse_configFileAndConfigName() throws {
        let args = try parser.parse(args: ["configFile", "configName"])
        expect(args.configFilePath) == "configFile"
        expect(args.configName) == "configName"
    }
}
