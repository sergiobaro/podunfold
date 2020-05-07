import Foundation

class Shell {
    
    @discardableResult
    static func run(_ command: String) -> Int32 {
        print("Running: \(command)")
        
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]
        process.launch()
        process.waitUntilExit()
        
        return process.terminationStatus
    }
}
