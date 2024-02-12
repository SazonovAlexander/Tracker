import Foundation


final class Increment {
    
    private static var number: UInt = 0
    
    static func nextId() -> UInt {
        number += 1
        return number
    }
}
