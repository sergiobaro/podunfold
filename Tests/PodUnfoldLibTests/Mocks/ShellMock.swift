import Foundation
@testable import PodUnfoldLib

class ShellMock: Shell {
  
  var echoMessages = [String]()
  func echo(_ message: String) {
    echoMessages.append(message)
  }
  
  var askMessages = [String]()
  var askReturn: String?
  func ask(_ message: String) -> String? {
    askMessages.append(message)
    return askReturn
  }
  
  var commands = [String]()
  func run(_ command: String) -> Int32 {
    commands.append(command)
    return 0
  }
}
