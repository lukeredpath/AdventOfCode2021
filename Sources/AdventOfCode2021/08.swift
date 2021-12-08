import Foundation
import Parsing
import Overture

enum Day08 {
    struct SignalPattern {
        var signals: String
        var length: Int { signals.count }
    }

    struct Display {
        var one: SignalPattern
        var two: SignalPattern
        var three: SignalPattern
        var four: SignalPattern
        var allDigits: [SignalPattern] { [one, two, three, four] }
    }

    typealias InputRow = (signals: [SignalPattern], display: Display)

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

    static let partOne = pipe(parseInput, countUniqueSignals)
}
