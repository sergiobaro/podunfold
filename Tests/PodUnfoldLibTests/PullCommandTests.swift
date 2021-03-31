import XCTest
import Nimble
@testable import PodUnfoldLib

class PullCommandTests: XCTestCase {
  
  let filesMock = FilesMock()
  let shellMock = ShellMock()
  
  func test_pull() {
    filesMock.paths = [
      "Pod1": [".git"]
    ]
    let pull = PullCommand(folder: nil, files: filesMock, shell: shellMock)
    
    expect(try pull.execute()).toNot(throwError())
    expect(self.shellMock.commands.first).to(equal("git pull"))
  }
}
