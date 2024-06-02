import Foundation

extension String {
    mutating func swapAt(_ index1: Int, _ index2: Int) {
        var characters = Array(self)
        characters.swapAt(index1, index2)
        self = String(characters)
    }
    
    // important 
    subscript(i: Int) -> String {
        String(self[index(startIndex, offsetBy: i)])
    }
}
