import Foundation
import Parsing
import Overture

enum Day07 {
    static func parseInput(_ input: String) -> [Int] {
        let parser = Many(Int.parser(), separator: ",")
        var input = input[...]
        guard let result = parser.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }

    static func calculateFuel(positions: [Int], target: Int) -> Int {
        positions.reduce(0) { (fuel, position) in
            fuel + abs(position - target)
        }
    }

    static func calculateFuel2(positions: [Int], target: Int) -> Int {
        positions.reduce(0) { (acc, position) in
            let distance = abs(position - target)
            let fuel = distance * (distance + 1) / 2
            return acc + fuel
        }
    }

    static func findOptimumFuel(input: [Int], calculateFuel: ([Int], Int) -> Int) -> Int? {
        let range = (input.min()!...input.max()!)
        var lastFuel: Int? = nil
        for target in range {
            let fuel = calculateFuel(input, target)
            if let lastFuel = lastFuel, fuel > lastFuel {
                return lastFuel
            }
            lastFuel = fuel
        }
        return nil
    }

    static let partOne = pipe(
        parseInput,
        with(calculateFuel, flip(curry(findOptimumFuel)))
    )

    static let partTwo = pipe(
        parseInput,
        with(calculateFuel2, flip(curry(findOptimumFuel)))
    )
}
