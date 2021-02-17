import Foundation

protocol Logger {
  
  func log(_ message: String)
  func ask(_ message: String)
}

class TerminalLogger: Logger {
  
  func log(_ message: String) {
    print(message)
  }
  
  func ask(_ message: String) {
    print(message, terminator: "")
  }
}
