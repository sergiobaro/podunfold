import XCTest
@testable import PodUnfoldLib

class ArgsParserTests: XCTestCase {
    
    let parser = ArgsParser()
    
    func test_parse() throws {
        XCTAssertThrowsError(try parser.parse(args: []))
        XCTAssertThrowsError(try parser.parse(args: ["name"]))
        
        let result = try parser.parse(args: ["name", "config"])
        XCTAssertEqual(result.configFilePath, "config")
    }
}
