import Foundation

struct Args {
    let configFilePath: String
    let configName: String?
}

class ArgsParser {
    
    func parse(args: [String]) throws -> Args {
        var configFilePath = "unfold.yml"
        if args.count > 1 {
            configFilePath = args[1]
        }
        
        var configName: String?
        if args.count > 2 {
            configName = args[2]
        }
        
        return Args(configFilePath: configFilePath, configName: configName)
    }
}
