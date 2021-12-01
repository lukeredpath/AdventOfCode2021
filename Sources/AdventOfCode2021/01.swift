import Foundation
import Overture

enum Day01 {
    static func parseInput(lines: String) -> [Int] {
        lines
            .components(separatedBy: .newlines)
            .compactMap(Int.init)
    }

    static func analyseInput(_ input: [Int]) -> Int {
        input[1...].indices.reduce(0) { count, index in
            input[index] > input[index - 1]
                ? count + 1
                : count
        }
    }

    static func calculateSliceTotals(_ input: [Int]) -> [Int] {
        input.indices.reduce(into: [Int]()) { sliceTotals, index in
            guard index + 2 < input.count else { return }
            let slice = input[index...index + 2]
            sliceTotals.append(slice.reduce(0, +))
        }
    }

    static let partOne = pipe(parseInput, analyseInput)
    static let partTwo = pipe(parseInput, calculateSliceTotals, analyseInput)
}
