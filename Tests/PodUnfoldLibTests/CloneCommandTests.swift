import XCTest
import Nimble
@testable import PodUnfoldLib

class CloneCommandTests: XCTestCase {
  
  func test_podNotFoundInConfigFile() {
    let configFile = ConfigFile(
      pods: [.init(name: "PodName", gitUrl: "https://podurl.com", type: .pod)],
      configs: []
    )
    let shellMock = ShellMock()
    
    let clone = CloneCommand(
      configFile: configFile,
      podName: "OtherPodName",
      destinationFolder: "folder",
      shell: shellMock
    )
    
    expect(try clone.execute()).to(throwError(CloneCommandError.podNotFound("OtherPodName")))
  }
  
  func test_success_withDestinationFolder() {
    let configFile = ConfigFile(
      pods: [.init(name: "PodName", gitUrl: "https://podurl.com", type: .pod)],
      configs: []
    )
    let shellMock = ShellMock()
    
    let clone = CloneCommand(
      configFile: configFile,
      podName: "PodName",
      destinationFolder: "folder",
      shell: shellMock
    )
    
    expect(try clone.execute()).toNot(throwError())
    
    expect(shellMock.commands.first).to(equal("git clone https://podurl.com folder"))
  }
  
  func test_success() {
    let configFile = ConfigFile(
      pods: [.init(name: "PodName", gitUrl: "https://podurl.com", type: .pod)],
      configs: []
    )
    let shellMock = ShellMock()
    
    let clone = CloneCommand(
      configFile: configFile,
      podName: "PodName",
      destinationFolder: nil,
      shell: shellMock
    )
    
    expect(try clone.execute()).toNot(throwError())
    
    expect(shellMock.commands.first).to(equal("git clone https://podurl.com PodName"))
  }
}
