import Foundation

extension Array {

  subscript(at index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
