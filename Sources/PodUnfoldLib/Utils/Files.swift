import Foundation

protocol Files {
  
  var currentFolder: String { get }
  
  func exists(_ path: String) -> Bool
  func contents(_ path: String) throws -> [String]
  func isDirectory(_ path: String) -> Bool
  func subfolders(_ path: String) throws -> [String]
  func changeCurrentFolder(_ path: String)
  
  func delete(_ path: String) throws
  func createFolder(_ path: String) throws
}

class FilesDefault: Files {
  
  var currentFolder: String { fm.currentDirectoryPath }
  
  private let fm = FileManager.default
  
  func exists(_ path: String) -> Bool {
    fm.fileExists(atPath: path)
  }
  
  func contents(_ path: String) throws -> [String] {
    try fm.contentsOfDirectory(atPath: path)
  }
  
  func isDirectory(_ path: String) -> Bool {
      var isDirectory: ObjCBool = false
      guard fm.fileExists(atPath: path, isDirectory: &isDirectory) else {
        return false
      }
      return isDirectory.boolValue
  }
  
  func subfolders(_ path: String) throws -> [String] {
    try fm.contentsOfDirectory(atPath: path)
      .filter { isDirectory($0) }
  }
  
  func changeCurrentFolder(_ path: String) {
    fm.changeCurrentDirectoryPath(path)
  }
  
  func delete(_ path: String) throws {
    try fm.removeItem(atPath: path)
  }
  
  func createFolder(_ path: String) throws {
    try fm.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
  }
}
