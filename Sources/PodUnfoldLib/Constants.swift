import Foundation

struct Constants {
  static let defaultShallow = false
  static let defaultConfigFile = "unfold.yml"
  static let defaultArgs = ArgsCommand.unfold(configFilePath: Constants.defaultConfigFile, configName: nil)
}
