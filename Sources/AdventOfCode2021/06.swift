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
        fish > 0 ? [fish - 1] : [6, 8]
    }

    static func counts(for currentFish: [Lanternfish]) -> [Lanternfish: UInt] {
        var counts: [Lanternfish: UInt] = [:]
        for fish in (0...7) {
            let count = currentFish.filter { $0 == fish }.count
            counts[Day06.Lanternfish(fish), default: 0] = UInt(count)
        }
        return counts
    }

    static func simulateDay(counts: inout [Lanternfish: UInt]) {
        var numberReproduced: UInt = 0
        for fish in (0...8) {
            let count = counts[Day06.Lanternfish(fish), default: 0]
            counts[Day06.Lanternfish(fish), default: 0] -= count

            if fish > 0 {
                counts[Day06.Lanternfish(fish - 1), default: 0] += count
            } else {
                numberReproduced = count
            }
        }
        counts[8, default: 0] += numberReproduced
        counts[6, default: 0] += numberReproduced
    }

    static func performSimulation(
        currentFish: [Lanternfish],
        numberOfDays: UInt
    ) -> [Lanternfish] {
        (1...numberOfDays).reduce(currentFish) { accumulatedFish, day in
            accumulatedFish.flatMap(dayElapsed)
        }
    }

    static func performOptimisedSimulation(
        currentFish: [Lanternfish],
        numberOfDays: UInt
    ) -> UInt {
        var counts = counts(for: currentFish)
        for _ in (1...numberOfDays) {
            simulateDay(counts: &counts)
        }
        return counts.values.reduce(0) { $0 + $1 }
    }

    static func produceSimulation(numberOfDays: UInt) -> ([Lanternfish]) -> [Lanternfish] {
        with(numberOfDays, flip(curry(performSimulation)))
    }

    static func produceOptimizedSimulation(numberOfDays: UInt) -> ([Lanternfish]) -> UInt {
        with(numberOfDays, flip(curry(performOptimisedSimulation)))
    }

    static let partOne = pipe(
        parseInput,
        with(80, produceSimulation),
        get(\.count)
    )

    static let partTwo = pipe(
        parseInput,
        with(256, produceOptimizedSimulation)
    )
}
