import Foundation

class GitBuilder {

  private var command = "git"

  @discardableResult
  func clone(url: String) -> Self {
    command += " clone \(url)"
    return self
  }

  @discardableResult
  func folder(_ folder: String) -> Self {
    command += " \(folder)"
    return self
  }

  @discardableResult
  func branch(_ branch: String) -> Self {
    command += " -b \(branch)"
    return self
  }

  @discardableResult
  func depth(_ depth: Int) -> Self {
    if depth > 0 {
      command += " --depth \(depth)"
    }
    return self
  }

  func build() -> String {
    command
  }
}
