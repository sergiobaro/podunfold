import XCTest
import Nimble
import Yams
@testable import PodUnfoldLib

class ConfigFileTests: XCTestCase {
  
  func test_configFile() throws {
    let configFile = """
    pods:
      - name: App
        type: app
        git: https://git.com/app
      - name: Pod
        git: https://git.com/pod
      - name: ExampleApp
        type: example
        git: https://git.com/example

    configs:
      - name: AppConfig
        pods:
          App: develop
          Pod: feature/branch
      - name: ExampleConfig
        pods:
          Example: develop
          Pod: feature/branch
    """
    
    let result = try YAMLDecoder().decode(ConfigFile.self, from: configFile)
    expect(result.pods.count) == 3
    expect(result.pods[0].name) == "App"
    expect(result.pods[0].type) == .app
    
    expect(result.pods[1].name) == "Pod"
    expect(result.pods[1].type) == .pod
    
    expect(result.pods[2].name) == "ExampleApp"
    expect(result.pods[2].type) == .example
    
    expect(result.configs.count) == 2
    
    expect(result.configs[0].name) == "AppConfig"
    expect(result.configs[0].pods.count) == 2
    
    expect(result.configs[1].name) == "ExampleConfig"
    expect(result.configs[1].pods.count) == 2
  }
}
