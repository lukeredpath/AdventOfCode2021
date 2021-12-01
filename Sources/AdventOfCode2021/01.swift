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

    static let run = pipe(parseInput, analyseInput)
}
