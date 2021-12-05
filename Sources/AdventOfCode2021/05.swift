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

    static func pointsOnLine(_ line: Line) -> [Point] {
        if line.a.x == line.b.x {
            // handle vertical lines
            return (min(line.a.y, line.b.y)...max(line.a.y, line.b.y)).map {
                .init(x: line.a.x, y: $0)
            }
        }
        if line.a.y == line.b.y {
            // handle horizontal lines
            return (min(line.a.x, line.b.x)...max(line.a.x, line.b.x)).map {
                .init(x: $0, y: line.a.y)
            }
        }
        return []
    }

    static func countOverlappingPoints(in lines: [Line]) -> Int {
        let allPoints = lines.flatMap(pointsOnLine)
        let grouped = Dictionary(grouping: allPoints, by: { $0 })
        return grouped.filter { $0.value.count > 1 }.count
    }

    static let partOne = pipe(parseInput, countOverlappingPoints)
}
