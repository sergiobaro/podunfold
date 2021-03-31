import Foundation
@testable import PodUnfoldLib

class FilesMock: Files {
  
  var paths: [String: [String]]
  
  convenience init() {
    self.init(paths: [:])
  }
  
  init(paths: [String: [String]]) {
    self.paths = paths
  }

  var currentFolderReturn = ""
  var currentFolder: String { currentFolderReturn }
  
  func exists(_ path: String) -> Bool {
    paths.keys.contains(path)
  }
  
  func contents(_ path: String) throws -> [String] {
    []
  }
  
  func isGit(_ path: String) throws -> Bool {
    let cleanedPath = path.replacingOccurrences(of: "/", with: "")
    return paths[cleanedPath]?.contains(".git") ?? false
  }
  
  func isDirectory(_ path: String) -> Bool {
    false
  }
  
  func subfolders(_ path: String) throws -> [String] {
    Array(paths.keys)
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
