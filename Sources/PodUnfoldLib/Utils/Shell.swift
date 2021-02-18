import Foundation

protocol Shell {
  
  func echo(_ message: String)
  func ask(_ message: String) -> String?
  @discardableResult
  func run(_ command: String) -> Int32
}

class ShellDefault: Shell {
  
  func echo(_ message: String) {
    print(message)
  }
  
  func ask(_ message: String) -> String? {
    print(message, terminator: "")
    return readLine()
  }
  
  @discardableResult
  func run(_ command: String) -> Int32 {
    print("Running: \(command)")
    
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]
    process.launch()
    process.waitUntilExit()
    
    return process.terminationStatus
  }
}
