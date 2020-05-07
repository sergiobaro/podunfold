import Foundation

enum PodUnfoldError: Error {
    case configNotFound(String)
    case podNotFound(String)
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
            print("Select config:")
            for (index, config) in configFile.configs.enumerated() {
                if config.name.isEmpty { continue }
                print("\(index + 1): \(config.name)")
            }
            
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
            throw PodUnfoldError.configNotFound(configName)
        }
        
        try createAndMoveToFolder(config.name)
        try clonePods(config: config, pods: configFile.pods)
        
        try PodfilePatcher().patch(config: config, pods: configFile.pods)
    }
    
    private func createAndMoveToFolder(_ folder: String) throws {
        let fm = FileManager.default
        let currentFolder = fm.currentDirectoryPath
        let destinationFolder = currentFolder + "/" + folder
        
        print("Moving to: \(destinationFolder)")
        if fm.fileExists(atPath: destinationFolder) {
            try fm.removeItem(atPath: destinationFolder)
        }
        try fm.createDirectory(atPath: destinationFolder, withIntermediateDirectories: false, attributes: nil)
        fm.changeCurrentDirectoryPath(destinationFolder)
    }
    
    private func clonePods(config: Config, pods: [String: PodConfig]) throws {
        for (podAlias, branch) in config.pods {
            guard let podConfig = pods[podAlias] else {
                throw PodUnfoldError.podNotFound(podAlias)
            }
            
            print("Working on pod: \(podAlias)")
            Shell.run("git clone --depth 1 -b \(branch) \(podConfig.gitUrl) \(podAlias)")
        }
    }
}
