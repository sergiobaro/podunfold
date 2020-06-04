import Foundation

enum PodUnfoldError: LocalizedError {
    case configNotFound(configName: String)
    case podNotFound(podName: String, configName: String)
    
    var errorDescription: String? {
        switch self {
        case .configNotFound(let configName):
            return "Config with name '\(configName)' not found."
        case .podNotFound(let podName, let configName):
            return "Pod with name '\(podName)' not found in config '\(configName)'."
        }
    }
}

public class PodUnfold {
    
    public init() { }
    
    public func run(args: [String]) throws {
        let args = try ArgsParser().parse(args: args)
        let configFile = try ConfigParser().parse(configPathFile: args.configFilePath)
        
        if let configName = args.configName {
            try execute(configName: configName, configFile: configFile)
        } else {
            let configName = presentConfigOptions(configFile)
            try execute(configName: configName, configFile: configFile)
        }
    }
    
    private func presentConfigOptions(_ configFile: ConfigFile) -> String {
        var selectedConfigName: String?
        
        while selectedConfigName == nil {
            for (index, config) in configFile.configs.enumerated() {
                if config.name.isEmpty { continue }
                print("\(index + 1): \(config.name)")
            }
            
            print("Select a configuration: ", terminator: "")
            if let input = readLine(),
                let configOption = Int(input),
                configFile.configs.indices.contains(configOption - 1) {
                selectedConfigName = configFile.configs[configOption - 1].name
            } else {
                print("")
            }
        }
        
        return selectedConfigName!
    }
    
    private func execute(configName: String, configFile: ConfigFile) throws {
        guard let config = configFile.configs.first(where: { $0.name == configName }) else {
            throw PodUnfoldError.configNotFound(configName: configName)
        }
        
        try createAndMoveToFolder(config.name)
        try clonePods(config: config, pods: configFile.pods)
        try PodfilePatcher().patch(config: config, pods: configFile.pods)
    }
    
    private func createAndMoveToFolder(_ folder: String) throws {
        let fm = FileManager.default
        let currentFolder = fm.currentDirectoryPath
        let destinationFolder = currentFolder + "/" + folder
        
        if fm.fileExists(atPath: destinationFolder) {
            try fm.removeItem(atPath: destinationFolder)
            print("Deleted: \(destinationFolder)")
        }
        print("Moving to: \(destinationFolder)")
        try fm.createDirectory(atPath: destinationFolder, withIntermediateDirectories: false, attributes: nil)
        fm.changeCurrentDirectoryPath(destinationFolder)
    }
    
    private func clonePods(config: Config, pods: [PodConfig]) throws {
        for (podName, branch) in config.pods {
            guard let podConfig = pods.first(where: { $0.name == podName }) else {
                throw PodUnfoldError.podNotFound(podName: podName, configName: config.name)
            }
            
            print("Working on pod: \(podName)")
            Shell.run("git clone --depth 1 -b \(branch) \(podConfig.gitUrl) \(podName)")
        }
    }
}
