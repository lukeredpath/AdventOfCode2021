import Foundation
import Overture
import Parsing

enum Day05 {
    struct Point: Equatable, Hashable {
        var x: Int
        var y: Int
    }

    struct Line: Equatable {
        var a: Point
        var b: Point
    }

    static let coordinateParser = Int.parser()
        .skip(",")
        .take(Int.parser())
        .map(Point.init)

    static let lineParser = coordinateParser
        .skip(" -> ")
        .take(coordinateParser)
        .map(Line.init)

    static let inputParser = Many(lineParser, separator: "\n")

    static func parseInput(_ input: String) -> [Line] {
        var input = input[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }

    static func coordinateRange(a: Int, b: Int) -> [Int] {
        if a > b {
            return (b...a).reversed()
        } else {
            return Array(a...b)
        }
    }

    static func pointsOnLine(_ line: Line, countDiagonals: Bool) -> [Point] {
        if line.a.x == line.b.x {
            // handle vertical lines
            return coordinateRange(a: line.a.y, b: line.b.y).map {
                .init(x: line.a.x, y: $0)
            }
        }
        if line.a.y == line.b.y {
            // handle horizontal lines
            return coordinateRange(a: line.a.x, b: line.b.x).map {
                .init(x: $0, y: line.a.y)
            }
        }
        guard countDiagonals else { return [] }

        // handle diagonal lines
        return zip(
            coordinateRange(a: line.a.x, b: line.b.x),
            coordinateRange(a: line.a.y, b: line.b.y)
        ).map(Point.init)
    }

    static func countOverlappingPoints(in lines: [Line], countDiagonals: Bool) -> Int {
        let allPoints = lines.flatMap(with(countDiagonals, flip(curry(pointsOnLine))))
        let grouped = Dictionary(grouping: allPoints, by: { $0 })
        return grouped.filter { $0.value.count > 1 }.count
    }

    static let partOne = pipe(
        parseInput,
        with(false, flip(curry(countOverlappingPoints)))
    )

    static let partTwo = pipe(
        parseInput,
        with(true, flip(curry(countOverlappingPoints)))
    )
}
