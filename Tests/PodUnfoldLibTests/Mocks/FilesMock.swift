import Foundation
@testable import PodUnfoldLib

class FilesMock: Files {
  
  private let files: [String: String]
  
  init(files: [String: String]) {
    self.files = files
  }
  
  var currentFolder: String { "" }
  
  func exists(_ path: String) -> Bool {
    false
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
  
  func delete(_ path: String) throws {
    // empty
  }
  
  func createFolder(_ path: String) throws {
    // empty
  }
}
