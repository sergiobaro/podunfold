import Foundation

enum PodfilePatcherError: LocalizedError {
    case appNotFound(podName: String)
    case podNotFound(configName: String)
    case configNotFound(podName: String, configName: String)
    
    var errorDescription: String? {
        switch self {
        case .podNotFound(let podName):
            return "Pod with name '\(podName)' not found in Podfile"
        case .appNotFound(let configName):
            return "App not found for config with name '\(configName)'"
        case .configNotFound(let podName, let configName):
            return "Config not found for pod with name '\(podName)' in config '\(configName)'"
        }
    }
}

class PodfilePatcher {
    
    func patch(config: Config, pods: [PodConfig]) throws {
        guard let appConfig = findHost(config: config, podConfigs: pods) else {
            throw PodfilePatcherError.appNotFound(podName: config.name)
        }

        print("Patching Podfile of app: \(appConfig.name)")
        let appPath = buildAppPath(app: appConfig, alias: appConfig.name, config: config)

        print("Moving to: \(appPath)")
        let fm = FileManager.default
        fm.changeCurrentDirectoryPath(appPath)

        var podfileContents = try String(contentsOfFile: "Podfile")

        for podName in config.pods.keys {
            if podName == appConfig.name { continue }
            guard let podConfig = pods.first(where: { $0.name == podName }) else {
                throw PodfilePatcherError.configNotFound(podName: podName, configName: config.name)
            }

            let targetLine = "pod \'\(podConfig.name)\',"
            guard podfileContents.contains(targetLine) else {
                throw PodfilePatcherError.podNotFound(configName: podConfig.name)
            }
            let podLocalPath = appConfig.type == .example ? "../../\(podName)" : "../\(podName)"
            let replaceLine = "pod \'\(podConfig.name)\', :path => '\(podLocalPath)' #"

            podfileContents = podfileContents.replacingOccurrences(of: targetLine, with: replaceLine)
        }

        try podfileContents.write(toFile: "Podfile", atomically: true, encoding: .utf8)
        
        Shell.run("pod install")
    }
    
    private func findHost(config: Config, podConfigs: [PodConfig]) -> PodConfig? {
        if let config = findPod(ofType: .app, for: config, within: podConfigs) {
            return config
        }
        
        return findPod(ofType: .example, for: config, within: podConfigs)
    }
    
    private func findPod(ofType type: PodType, for config: Config, within podConfigs: [PodConfig]) -> PodConfig? {
        let allPodNamesOfType = podConfigs
            .filter { $0.type == type }
            .map { $0.name }
        
        let podNames = config.pods.keys
        guard let podNameOfType = podNames.first(where: { allPodNamesOfType.contains($0) }) else {
            return nil
        }

        return podConfigs.first(where: { $0.name == podNameOfType })
    }
    
    private func buildAppPath(app: PodConfig, alias: String, config: Config) -> String {
        let fm = FileManager.default
        var appPath = fm.currentDirectoryPath + "/" + alias
        if app.type == .example {
            appPath += "/Example"
        }
        
        return appPath
    }
}
