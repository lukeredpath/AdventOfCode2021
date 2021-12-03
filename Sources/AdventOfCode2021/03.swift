import Foundation
import Overture
import Parsing

enum Day03 {
    typealias Bits = (Int, Int, Int, Int, Int)
    typealias Diagnostic = (gamma: Bits, epsilon: Bits)

    static func intCharacter(matching value: Character) -> AnyParser<Substring, Int> {
        Prefix<Substring>(1) { $0 == value }
            .map(String.init)
            .compactMap { Int($0) }
            .eraseToAnyParser()
    }

    static let bitParser = OneOfMany(
        intCharacter(matching: "0"),
        intCharacter(matching: "1")
    )

    static let rowParser = Many(bitParser, atLeast: 5, atMost: 5)
        .map { values -> Bits in
            (values[0], values[1], values[2], values[3], values[4])
        }

    static let inputParser = Many(rowParser, separator: "\n")

    static func parseInput(lines: String) -> [Bits] {
        var input = lines[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input")
        }
        return result
    }
//
//    static func analyseReport(_ rows: [Bits]) -> Diagnostic {
//        (gamma: (0, 0, 0, 0 ,0), epsilon: (0, 0, 0, 0, 0))
//    }
//
//    static func powerConsumption(from diagnostic: Diagnostic) -> Int {
//        0
//    }
//
//    // static let partThree = (String) -> Int
//    static let partOne = pipe(parseInput, analyseReport, powerConsumption)
}
