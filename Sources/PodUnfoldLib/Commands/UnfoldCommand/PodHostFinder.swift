import Foundation

class PodHostFinder {
  
  static func findHost(config: Config, podConfigs: [PodConfig]) -> PodConfig? {
    if let config = findPod(ofType: .app, for: config, within: podConfigs) {
      return config
    }
    
    return findPod(ofType: .example, for: config, within: podConfigs)
  }
  
  static func buildHostPath(hostConfig: PodConfig) -> String {
    let fm = FileManager.default
    var appPath = fm.currentDirectoryPath + "/" + hostConfig.name
    if hostConfig.type == .example {
      appPath += "/Example"
    }
    
    return appPath
  }
  
  static private func findPod(ofType type: PodType, for config: Config, within podConfigs: [PodConfig]) -> PodConfig? {
    let allPodNamesOfType = podConfigs
      .filter { $0.type == type }
      .map { $0.name }
    
    let podNames = config.pods.keys
    guard let podNameOfType = podNames.first(where: { allPodNamesOfType.contains($0) }) else {
      return nil
    }
    
    return podConfigs.first(where: { $0.name == podNameOfType })
  }
}
