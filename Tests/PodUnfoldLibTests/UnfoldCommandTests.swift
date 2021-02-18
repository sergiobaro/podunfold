import XCTest
import Nimble
@testable import PodUnfoldLib

class UnfoldCommandTests: XCTestCase {
  
  func test_configNotFound() {
    let configFile = ConfigFile(
      pods: [
        .init(name: "Pod", gitUrl: "http://pod.com", type: .app)
      ],
      configs: [
        .init(name: "Config", shallow: true, pods: ["Pod": "develop"])
      ]
    )
    let filesMock = FilesMock(paths: [])
    let shellMock = ShellMock()

    let unfold = UnfoldCommand(
      configFile: configFile,
      configName: "NoConfig",
      files: filesMock,
      shell: shellMock
    )

    expect(try unfold.execute()).to(throwError(UnfoldCommandError.configNotFound(configName: "NoConfig")))
  }
  
  func test_config_oneConfig_noFolder() {
    let configFile = ConfigFile(
      pods: [
        .init(name: "Pod", gitUrl: "http://pod.com", type: .app)
      ],
      configs: [
        .init(name: "Config", shallow: false, pods: ["Pod": "develop"])
      ]
    )
    let filesMock = FilesMock(paths: ["Folder/Config"])
    filesMock.currentFolderReturn = "Folder"
    
    let shellMock = ShellMock()
    shellMock.askReturn = "1"

    let unfold = UnfoldCommand(
      configFile: configFile,
      configName: nil,
      files: filesMock,
      shell: shellMock
    )

    expect(try unfold.execute()).toNot(throwError())

    // create folder
    expect(filesMock.deleteCalled).to(equal(true))

    // clone pods
    expect(shellMock.commands[0]).to(equal("git clone http://pod.com Pod -b develop"))

    // patch Podfile
    expect(shellMock.commands[1]).to(equal("pod install"))
  }
  
}
