import Foundation
import Yams

struct ConfigFile: Codable {
  let pods: [PodConfig]
  let configs: [Config]
}

enum PodType: String, Codable {
  case app
  case pod
  case example
}

struct PodConfig: Codable {
  let name: String
  let gitUrl: String
  let type: PodType
  
  enum CodingKeys: String, CodingKey {
    case name
    case gitUrl = "git"
    case type
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.gitUrl = try container.decode(String.self, forKey: .gitUrl)
    self.type = try container.decodeIfPresent(PodType.self, forKey: .type) ?? .pod
  }
}

struct Config: Codable {
  let name: String
  let shallow: Bool?
  let pods: [String: String]
}

class ConfigParser {
  
  func parse(configPathFile: String) throws -> ConfigFile {
    let string = try String(contentsOfFile: configPathFile)
    return try YAMLDecoder().decode(ConfigFile.self, from: string)
  }
}
