import Foundation

enum PodfilePatcherError: LocalizedError {
    case podNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .podNotFound(let podName):
            return "Pod with name '\(podName)' not found in Podfile"
        }
    }
}

class PodfilePatcher {
    
    func patch(config: Config, pods: [String: PodConfig]) throws {
        guard let app = findApp(config: config, pods: pods) else {
            print("App not found")
            return
        }

        print("Patching Podfile of app: \(app.appConfig.name)")
        let appPath = buildAppPath(app: app.appConfig, alias: app.appAlias, config: config)

        print("Moving to: \(appPath)")
        let fm = FileManager.default
        fm.changeCurrentDirectoryPath(appPath)

        let podfilePath = appPath + "/Podfile"
        var podfileContents = try String(contentsOfFile: podfilePath)

        for podAlias in config.pods.keys {
            guard podAlias != app.appAlias else {
                continue
            }
            guard let podConfig = pods[podAlias] else {
                print("Config not found for: \(podAlias)")
                return
            }

            let targetLine = "pod \'\(podConfig.name)\',"
            guard podfileContents.contains(targetLine) else {
                throw PodfilePatcherError.podNotFound(podConfig.name)
            }
            let podLocalPath = app.appConfig.type == .example ? "../../\(podAlias)" : "../\(podAlias)"
            let replaceLine = "pod \'\(podConfig.name)\', :path => '\(podLocalPath)' #"

            podfileContents = podfileContents.replacingOccurrences(of: targetLine, with: replaceLine)
        }

        try podfileContents.write(toFile: podfilePath, atomically: true, encoding: .utf8)
        
        Shell.run("pod install")
    }
    
    private func findApp(config: Config, pods: [String: PodConfig]) -> (appAlias: String, appConfig: PodConfig)? {
        let appAliases = pods
            .filter { $0.1.type == .app || $0.1.type == .example }
            .map { $0.0 }
        
        let podAliases = config.pods.keys
        guard let appAlias = podAliases.first(where: { appAliases.contains($0) }) else {
            return nil
        }
        guard let appConfig = pods[appAlias] else {
            return nil
        }
        
        return (appAlias, appConfig)
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
