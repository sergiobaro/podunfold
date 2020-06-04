import Foundation

struct Args {
    let configFilePath: String
    let configName: String?
}

class ArgsParser {
    
    static let defaultConfigFile = "unfold.yml"
    
    func parse(args: [String]) throws -> Args {
        var configFilePath = Self.defaultConfigFile
        if args.count > 0 {
            configFilePath = args[0]
        }
        
        var configName: String?
        if args.count > 1 {
            configName = args[1]
        }
        
        return Args(configFilePath: configFilePath, configName: configName)
    }
}
