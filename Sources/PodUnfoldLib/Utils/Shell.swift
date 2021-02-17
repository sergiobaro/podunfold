import Foundation

protocol Shell {
  
  @discardableResult
  func run(_ command: String) -> Int32
}

class ShellDefault: Shell {
  
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
