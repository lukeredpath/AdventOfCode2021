import Foundation
import Parsing
import Overture

enum Day16 {
    typealias PacketHeader = (version: Int, typeID: Int)
    
    struct Packet: Equatable {
        let header: PacketHeader
        let value: PacketValue
        
        static func == (lhs: Day16.Packet, rhs: Day16.Packet) -> Bool {
            lhs.value == rhs.value
                && lhs.header.version == rhs.header.version
                && lhs.header.typeID == rhs.header.typeID
        }
    }
    
    enum PacketValue: Equatable {
        case literal(Int)
        case `operator`([Packet])
    }
    
    enum LengthType: Equatable {
        case subPacketLength(Int)
        case totalSubPackets(Int)
    }
    
    // MARK: - Utilities
    
    static let binaryStringToInt: (String) -> Int? = with(
        2, flip(curry(Int.init(_:radix:)))
    )
    
    static func bitsToInt(_ bits: [Substring]) -> Int? {
        binaryStringToInt(bits.joined())
    }
    
    // MARK: - Parsing
    
    static let zeroPaddedByteFromHex = Prefix<Substring>(1)
        .compactMap { Int($0, radix: 16) }
        .map { intValue -> String in
            let byteString = String(intValue, radix: 2)
            let padding = String(repeating: "0", count: 4 - byteString.count)
            return padding + byteString
        }
        
    static let packetBytes = Many(zeroPaddedByteFromHex).map { $0.joined()[...] }
    
    static let zero = Prefix<Substring>(1, while: { $0 == "0" })

    static let one = Prefix<Substring>(1, while: { $0 == "1" })

    static let bit = zero.orElse(one)

    static let packetVersion = Many(bit, exactly: 3).compactMap(bitsToInt)
    
    static let packetTypeID = Many(bit, exactly: 3)
        .compactMap(bitsToInt)
    
    static let groupValue = Many(bit, exactly: 4)

    static let insideGroup = Skip(one).take(groupValue)

    static let finalGroup = Skip(zero).take(groupValue)
    
    static let groups = Many(insideGroup)
        .take(finalGroup)
        .compactMap { bitsToInt($0.flatMap { $0 } + $1) }
    
    static let zeroPadding = Many(zero, atLeast: 0, atMost: 3)
    
    static let packetHeader = packetVersion.take(packetTypeID)
        .map { PacketHeader(version: $0, typeID: $1) }
    
    static let lengthTypeID = bit.compactMap { bitsToInt([$0]) }
    
    static let lengthType = lengthTypeID.flatMap { value -> AnyParser<Substring, LengthType> in
        if value == 0 {
            return Many(bit, exactly: 15)
                .compactMap(bitsToInt)
                .map(LengthType.subPacketLength)
                .eraseToAnyParser()
        } else {
            return Many(bit, exactly: 11)
                .compactMap(bitsToInt)
                .map(LengthType.totalSubPackets)
                .eraseToAnyParser()
        }
    }
    
    static func literalPacket(header: PacketHeader) -> AnyParser<Substring, Packet> {
        return groups
            .map(PacketValue.literal)
            .map { Packet(header: header, value: $0) }
            .eraseToAnyParser()
    }
    
    static func operatorPacket(header: PacketHeader) -> AnyParser<Substring, Packet> {
        return lengthType
            .flatMap { lengthType -> AnyParser<Substring, [Packet]> in
                switch lengthType {
                case let .totalSubPackets(count):
                    return Many(packet, exactly: count)
                        .eraseToAnyParser()
                    
                case let .subPacketLength(length):
                    return Prefix<Substring>(length)
                        .pipe(Many(packet))
                        .eraseToAnyParser()
                }
            }
            .map { Packet(header: header, value: .operator($0)) }
            .eraseToAnyParser()
    }
    
    static let packet = packetHeader
        .flatMap { header -> AnyParser<Substring, Packet> in
            if header.typeID == 4 {
                return literalPacket(header: header)
                    .eraseToAnyParser()
            } else {
                return operatorPacket(header: header)
            }
        }
    
    static func parseInput(_ hexInputString: String) -> Packet {
        var input = hexInputString[...]
        guard let packet = packetBytes.pipe(packet).parse(&input) else {
            fatalError("Could not parse binary input string!")
        }
        return packet
    }
    
    // MARK: - Packet Calculations
    
    static func sumPacketVersions(packet: Packet) -> Int {
        switch packet.value {
        case .literal:
            return packet.header.version
        case let .operator(packets):
            return packets.reduce(packet.header.version) {
                $0 + sumPacketVersions(packet: $1)
            }
        }
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(parseInput, sumPacketVersions)
}

