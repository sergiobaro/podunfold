import XCTest
import Nimble
@testable import PodUnfoldLib

class GitBuilderTests: XCTestCase {

  func test_clone() throws {
    let command = GitBuilder().clone(url: "url").build()
    expect(command) == "git clone url"
  }

  func test_clone_withFolder() throws {
    let command = GitBuilder().clone(url: "url").folder("folder").build()
    expect(command) == "git clone url folder"
  }

  func test_clone_withBranch() throws {
    let command = GitBuilder().clone(url: "url").branch("branch").build()
    expect(command) == "git clone url -b branch"
  }

  func test_clone_withDepth() throws {
    let command = GitBuilder().clone(url: "url").depth(1).build()
    expect(command) == "git clone url --depth 1"
  }
}
