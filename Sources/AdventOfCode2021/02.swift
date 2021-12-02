import Foundation
import Overture

enum Day02 {
    typealias Position = (horizontal: Int, depth: Int)

    enum Movement {
        case up(Int)
        case down(Int)
        case forward(Int)
    }

    static func calculatePosition(
        from current: Position,
        movements: [Movement]
    ) -> Position {
        movements.reduce(current) { position, movement in
            switch movement {
            case let .up(value):
                return (position.horizontal, position.depth - value)
            case let .down(value):
                return (position.horizontal, position.depth + value)
            case let .forward(value):
                return (position.horizontal + value, position.depth)
            }
        }
    }

    static func aggregatePosition(from position: Position) -> Int {
        position.horizontal * position.depth
    }

    static func parseMovements(input: String) -> [Movement] {
        []
    }

    static let startingPosition: Position = (0, 0)

    static let partOne = pipe(
        parseMovements,
        with(startingPosition, curry(calculatePosition)),
        aggregatePosition
    )
}
