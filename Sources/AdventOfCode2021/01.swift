import Foundation
import Overture

enum Day01 {
    static func parseInput(lines: String) -> [Int] {
        return lines
            .components(separatedBy: .newlines)
            .compactMap(Int.init)
    }

    static func analyseInput(_ input: [Int]) -> Int {
        var increases = 0
        for index in input[1...].indices {
            if input[index] > input[index - 1] {
                increases += 1
            }
        }
        return increases
    }

    static func calculateSliceTotals(_ input: [Int]) -> [Int] {
        var sliceTotals: [Int] = []
        for index in input.indices {
            guard index + 2 < input.count else { continue }
            let slice = input[index...index + 2]
            sliceTotals.append(slice.reduce(0, +))
        }
        return sliceTotals
    }

    static let partOne = pipe(parseInput, analyseInput)
    static let partTwo = pipe(parseInput, calculateSliceTotals, analyseInput)
}
