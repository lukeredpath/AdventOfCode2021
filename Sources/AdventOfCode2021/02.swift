import Foundation
import Overture
import Parsing

enum Day02 {
    typealias Position = (horizontal: Int, depth: Int, aim: Int)

    enum Movement: Equatable {
        case up(Int)
        case down(Int)
        case forward(Int)
    }

    static func calculatePositionNoAim(
        from current: Position,
        movements: [Movement]
    ) -> Position {
        movements.reduce(current) { position, movement in
            switch movement {
            case let .up(value):
                return (position.horizontal, position.depth - value, 0)
            case let .down(value):
                return (position.horizontal, position.depth + value, 0)
            case let .forward(value):
                return (position.horizontal + value, position.depth, 0)
            }
        }
    }

    static func calculatePositionWithAim(
        from current: Position,
        movements: [Movement]
    ) -> Position {
        movements.reduce(current) { position, movement in
            switch movement {
            case let .up(value):
                return (position.horizontal, position.depth, position.aim - value)
            case let .down(value):
                return (position.horizontal, position.depth, position.aim + value)
            case let .forward(value):
                return (position.horizontal + value, value * position.aim + position.depth, position.aim)
            }
        }
    }

    static func aggregatePosition(from position: Position) -> Int {
        position.horizontal * position.depth
    }

    static let movementRowParser = Prefix<Substring> { $0 != " " }
        .skip(" ")
        .take(Int.parser())
        .compactMap { (movement, value) -> Movement? in
            switch movement {
            case "up":
                return .up(value)
            case "down":
                return .down(value)
            case "forward":
                return .forward(value)
            default:
                return nil
            }
        }

    static let movementsParser = Many(movementRowParser, separator: "\n")

    static func parseMovements(input: String) -> [Movement] {
        var inputSubstring = input[...]
        guard let result = movementsParser.parse(&inputSubstring) else {
            return []
        }
        return result
    }

    static let startingPosition: Position = (0, 0, 0)

    static let partOne = pipe(
        parseMovements,
        with(startingPosition, curry(calculatePositionNoAim)),
        aggregatePosition
    )

    static let partTwo = pipe(
        parseMovements,
        with(startingPosition, curry(calculatePositionWithAim)),
        aggregatePosition
    )
}
