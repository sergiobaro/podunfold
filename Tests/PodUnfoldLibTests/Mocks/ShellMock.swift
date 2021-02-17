import Foundation
@testable import PodUnfoldLib

class ShellMock: Shell {
  
  var lastCommand = ""
  
  func run(_ command: String) -> Int32 {
    lastCommand = command
    return 0
  }
}
