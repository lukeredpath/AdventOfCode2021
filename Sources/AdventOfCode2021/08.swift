import Foundation
import Parsing
import Overture

enum Day08 {
    typealias SignalMapping = [String: Int]

    struct SignalPattern: Hashable {
        var signals: String
        var length: Int { signals.count }
        var characters: [Character] { Array(signals) }
        var characterSet: Set<Character> { Set(characters) }
    }

    struct Display {
        var one: SignalPattern
        var two: SignalPattern
        var three: SignalPattern
        var four: SignalPattern
        var allDigits: [SignalPattern] { [one, two, three, four] }
    }

    typealias InputRow = (signals: Set<SignalPattern>, display: Display)

    static let signalPattern = Prefix<Substring> { $0 != " " && $0 != "\n" }
        .map { SignalPattern(signals: String($0)) }

    static let signals = Many(
        signalPattern,
        atLeast: 10, atMost: 10,
        separator: " "
    )

    static let outputDigits = Many(
        signalPattern,
        atLeast: 4, atMost: 4,
        separator: " "
    ).map { patterns in
        Display(
            one: patterns[0],
            two: patterns[1],
            three: patterns[2],
            four: patterns[3]
        )
    }

    static let inputRow = signals
        .map { Set($0) }
        .skip(" | ")
        .take(outputDigits)

    static let inputParser = Many(inputRow, separator: "\n")

    static func parseInput(_ input: String) -> [InputRow] {
        var input = input[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input")
        }
        return result
    }

    static func countUniqueSignals(in input: [InputRow]) -> Int {
        // The digits 1, 4, 7 and 8 each have a unique number of
        // signal patterns - 2, 4, 3 and 7 segments respectively.
        input.flatMap(\.display.allDigits).filter { signalPattern in
            [2, 4, 3, 7].contains(signalPattern.length)
        }.count
    }

    static func deduceSignalMapping(from signals: Set<SignalPattern>) -> SignalMapping {
        precondition(signals.count == 10, "Require 10 unique signals to deduce the mapping")
        var mapping: SignalMapping = [:]
        // We can easily determine the mappings for 1, 4, 7 and 8
        guard let signal1 = signals.first(where: { $0.length == 2 }) else {
            fatalError("Signals did not contain a pattern for '1'")
        }
        mapping[String(signal1.signals.sorted())] = 1
        guard let signal4 = signals.first(where: { $0.length == 4 }) else {
            fatalError("Signals did not contain a pattern for '4'")
        }
        mapping[String(signal4.signals.sorted())] = 4
        guard let signal7 = signals.first(where: { $0.length == 3 }) else {
            fatalError("Signals did not contain a pattern for '7'")
        }
        mapping[String(signal7.signals.sorted())] = 7
        guard let signal8 = signals.first(where: { $0.length == 7 }) else {
            fatalError("Signals did not contain a pattern for '8'")
        }
        mapping[String(signal8.signals.sorted())] = 8
        // 6 is the only 6-signal digit whose characters are not a superset of 7
        guard let signal6 = signals.first(
            where: {
                $0.length == 6 &&
                !signal7.characterSet.isSubset(of: $0.characterSet)
            }
        ) else {
            fatalError("Signals did not contain a pattern for '6'")
        }
        mapping[String(signal6.signals.sorted())] = 6
        // 9 is a superset of 4, but not 0
        guard let signal9 = signals.first(
            where: {
                $0.length == 6 && $0.characterSet.isSuperset(of: signal4.characterSet)
            }
        ) else {
            fatalError("Signals did not contain a pattern for '9'")
        }
        mapping[String(signal9.signals.sorted())] = 9
        // 0 must be the only other signal pattern with 6 signals
        guard let signal0 = signals.first(
            where: {
                $0.length == 6 && $0 != signal9 && $0 != signal6
            }
        ) else {
            fatalError("Signals did not contain a pattern for '0'")
        }
        mapping[String(signal0.signals.sorted())] = 0
        // 2 is the only 5-signal digit whose characters are not a subset of 9
        guard let signal2 = signals.first(
            where: {
                $0.length == 5 &&
                !$0.characterSet.isSubset(of: signal9.characterSet)
            }
        ) else {
            fatalError("Signals did not contain a pattern for '2'")
        }
        mapping[String(signal2.signals.sorted())] = 2
        // 5 is the only 5-signal digit whose characters are a subset of 6
        guard let signal5 = signals.first(
            where: {
                $0.length == 5 &&
                $0.characterSet.isSubset(of: signal6.characterSet)
            }
        ) else {
            fatalError("Signals did not contain a pattern for '5'")
        }
        mapping[String(signal5.signals.sorted())] = 5
        // 3 is the only other 5-signal digit remaining
        guard let signal3 = signals.first(
            where: {
                $0.length == 5 && $0 != signal2 && $0 != signal5
            }
        ) else {
            fatalError("Signals did not contain a pattern for '3'")
        }
        mapping[String(signal3.signals.sorted())] = 3
        return mapping
    }

    static func decodeDisplay(_ display: Display, mapping: SignalMapping) -> Int {
        let mappedDigits = display.allDigits.compactMap {
            mapping[String($0.signals.sorted())]
        }
        guard mappedDigits.count == display.allDigits.count else {
            fatalError("Unable to map each signal to a known digit!")
        }
        guard let number = Int(mappedDigits.map(String.init).joined()) else {
            fatalError("Could not decode display number")
        }
        return number
    }

    static func calculateDisplayOutput(for row: InputRow) -> Int {
        decodeDisplay(row.display, mapping: deduceSignalMapping(from: row.signals))
    }

    static func sumDisplays(_ displayNumbers: [Int]) -> Int {
        displayNumbers.reduce(0, +)
    }

    static let partOne = pipe(parseInput, countUniqueSignals)
    static let partTwo = pipe(parseInput, map(calculateDisplayOutput), sumDisplays)
}
