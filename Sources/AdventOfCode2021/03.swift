import Foundation
import Overture
import Parsing

enum Day03 {
    typealias Diagnostic = (gamma: Int, epsilon: Int)

    static func parseInput(lines: String) -> [String] {
        lines.components(separatedBy: .newlines)
    }

    static func analyseReport(_ rows: [String]) -> Diagnostic {
        guard rows.count > 0 else { return (0, 0) }

        let gammaBits = (0...rows[0].count-1).map { index -> Character in
            mostCommonBit(from: rows.map { Array($0)[index] })
        }
        let gammaBitString = String(gammaBits)
        let epsilonBitString = inverseBits(from: gammaBitString)

        return (bitsToInt(gammaBitString), bitsToInt(epsilonBitString))
    }

    static func mostCommonBit(from bitValues: [Character]) -> Character {
        let totals = bitValues.reduce((0, 0)) { counts, bitValue in
            if bitValue == "0" {
                return (counts.0 + 1, counts.1)
            } else {
                return (counts.0, counts.1 + 1)
            }
        }
        return totals.0 > totals.1 ? "0" : "1"
    }

    static func inverseBits(from bitsString: String) -> String {
        bitsString.reduce(into: "") { inverseBits, character in
            inverseBits += inverseBit(character)
        }
    }

    static func inverseBit(_ bitChar: Character) -> String {
        bitChar == "0" ? "1" : "0"
    }

    static func bitsToInt(_ bitString: String) -> Int {
        guard let int = Int(bitString, radix: 2) else {
            fatalError("Invalid bit string!")
        }
        return int
    }

    static func powerConsumption(from diagnostic: Diagnostic) -> Int {
        diagnostic.gamma * diagnostic.epsilon
    }

    static let partOne = pipe(parseInput, analyseReport, powerConsumption)
}
