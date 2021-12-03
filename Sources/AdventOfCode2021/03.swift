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

        let gammaBits = (0..<rows[0].count).map { index -> Character in
            mostCommonBit(in: rows, position: index)
        }
        let gammaBitString = String(gammaBits)
        let epsilonBitString = inverseBits(from: gammaBitString)

        return (bitsToInt(gammaBitString), bitsToInt(epsilonBitString))
    }

    static func mostCommonBit(in rows: [String], position: Int) -> Character {
        mostCommonBit(from: rows.map { Array($0)[position] })
    }

    static func mostCommonBit(from bitValues: [Character]) -> Character {
        let totals = countBits(from: bitValues)
        return totals.0 > totals.1 ? "0" : "1"
    }

    static func countBits(from bitValues: [Character]) -> (Int, Int) {
        bitValues.reduce((0, 0)) { counts, bitValue in
            if bitValue == "0" {
                return (counts.0 + 1, counts.1)
            } else {
                return (counts.0, counts.1 + 1)
            }
        }
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

    static func calculateOxygenGeneratorRating(from rows: [String], position: Int = 0) -> Int {
        calculateValueFromBitCriteria(rows: rows) { $0.0 > $0.1 ? "0" : "1" }
    }

    static func calculateCO2ScrubberRating(from rows: [String]) -> Int {
        calculateValueFromBitCriteria(rows: rows) { $0.1 >= $0.0 ? "0" : "1" }
    }

    static func calculateValueFromBitCriteria(
        rows: [String],
        position: Int = 0,
        matchValue: (((Int, Int)) -> Character)
    ) -> Int {
        guard rows.count > 0 else { return 0 }
        guard position < rows[0].count else { return 0 }

        let meetsCriteria = rows.filter { row in
            let counts = countBits(from: rows.map { Array($0)[position] })
            let characters = Array(row)
            return characters[position] == matchValue(counts)
        }

        if meetsCriteria.count == 1 { return bitsToInt(meetsCriteria.first!) }

        return calculateValueFromBitCriteria(
            rows: meetsCriteria,
            position: position + 1,
            matchValue: matchValue
        )
    }

    static func calculateLifeSupportRating(from input: [String]) -> Int {
        let oxygenRating = calculateOxygenGeneratorRating(from: input)
        let co2ScrubberRating = calculateCO2ScrubberRating(from: input)
        return oxygenRating * co2ScrubberRating
    }

    static func calculatePowerConsumption(from diagnostic: Diagnostic) -> Int {
        diagnostic.gamma * diagnostic.epsilon
    }

    static let partOne = pipe(parseInput, analyseReport, calculatePowerConsumption)
    static let partTwo = pipe(parseInput, calculateLifeSupportRating)
}
