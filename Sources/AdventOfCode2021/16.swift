import Foundation
import Parsing
import Overture

enum Day16 {
    typealias Packet = (version: Int, typeID: Int, value: Int)
    
    // MARK: - Utilities
    
    static func hexStringToBinaryString(_ hexString: String) -> String? {
        guard let intValue = Int(hexString, radix: 16) else { return nil }
        return String(intValue, radix: 2)
    }
    
    static let binaryStringToInt: (String) -> Int? = with(
        2, flip(curry(Int.init(_:radix:)))
    )
    
    static func bitsToInt(_ bits: [Substring]) -> Int? {
        binaryStringToInt(bits.joined())
    }
    
    // MARK: - Parsing
    
    static let zero = Prefix<Substring>(1, while: { $0 == "0" })
    static let one = Prefix<Substring>(1, while: { $0 == "1" })
    static let bit = zero.orElse(one)
    static let packetVersion = Many(bit, exactly: 3).compactMap(bitsToInt)
    static let packetTypeID = Many(bit, exactly: 3).compactMap(bitsToInt)
    static let groupValue = Many(bit, exactly: 4)
    static let insideGroup = Skip(one).take(groupValue)
    static let finalGroup = Skip(zero).take(groupValue)
    static let groups = Many(insideGroup, atLeast: 1)
        .take(finalGroup)
        .compactMap { bitsToInt($0.flatMap { $0 } + $1) }
    static let zeroPadding = Many(zero, atLeast: 0, atMost: 3)
    static let packet = packetVersion
        .take(packetTypeID)
        .take(groups)
        .skip(zeroPadding)
        .map { Packet(version: $0, typeID: $1, value: $2) }
}

