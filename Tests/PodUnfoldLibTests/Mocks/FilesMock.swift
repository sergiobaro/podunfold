import Foundation
@testable import PodUnfoldLib

class FilesMock: Files {
  
  private let paths: [String]
  
  init(paths: [String]) {
    self.paths = paths
  }

  var currentFolderReturn = ""
  var currentFolder: String { currentFolderReturn }
  
  func exists(_ path: String) -> Bool {
    paths.contains(path)
  }
  
  func contents(_ path: String) throws -> [String] {
    []
  }
  
  func isDirectory(_ path: String) -> Bool {
    false
  }
  
  func subfolders(_ path: String) throws -> [String] {
    []
  }
  
  func changeCurrentFolder(_ path: String) {
    // empty
  }

  var deleteCalled = false
  func delete(_ path: String) throws {
    deleteCalled = true
  }
  
  func createFolder(_ path: String) throws {
    // empty
  }
}
