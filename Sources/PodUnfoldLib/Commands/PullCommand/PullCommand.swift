import Foundation

class PullCommand: Command {
  
  private let folder: String?
  private let files: Files
  private let shell: Shell
  
  init(folder: String?, files: Files, shell: Shell) {
    self.folder = folder
    self.files = files
    self.shell = shell
  }
  
  func execute() throws {
    let fullFolder = buildFolder()
    try files.subfolders(fullFolder).forEach { subfolder in
      let podFolder = fullFolder + "/" + subfolder
      do {
        guard try files.isGit(podFolder) else { return }
        shell.echo("Pulling \(subfolder)")
        updatePod(podFolder)
      } catch {
        shell.echo("\(subfolder) is not a git repository")
      }
    }
  }
  
  private func buildFolder() -> String {
    files.currentFolder + (folder != nil ? "/\(folder!)" : "")
  }
  
  private func updatePod(_ path: String) {
    files.changeCurrentFolder(path)
    let git = GitBuilder()
      .pull()
      .build()
    shell.run(git)
  }
}
