import Foundation
import Overture
import Parsing

enum Day06 {
    typealias Lanternfish = UInt

    static func parseInput(_ input: String) -> [Lanternfish] {
        var input = input[...]
        guard let result = Many(UInt.parser(), separator: ",").parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }

    static func dayElapsed(for fish: Lanternfish) -> [Lanternfish] {
        if fish > 0 {
            return [fish - 1]
        } else {
            return [6, 8]
        }
    }

    static func performSimulation(
        currentFish: [Lanternfish],
        numberOfDays: UInt
    ) -> [Lanternfish] {
        (1...numberOfDays).reduce(currentFish) { accumulatedFish, _ in
            accumulatedFish.flatMap(dayElapsed)
        }
    }

    static func produceSimulation(numberOfDays: UInt) -> ([Lanternfish]) -> [Lanternfish] {
        with(numberOfDays, flip(curry(performSimulation)))
    }

    static let partOne = pipe(
        parseInput,
        with(80, produceSimulation),
        get(\.count)
    )
}
