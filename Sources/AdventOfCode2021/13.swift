import Foundation
import Overture
import Parsing

enum Day13 {
    typealias Point = Day05.Point
    typealias MarkedGrid = Set<Point>
    typealias FoldPoint = (axis: String, value: Int)
    typealias Input = (marks: MarkedGrid, folds: [FoldPoint])

    static let point = Int.parser()
        .skip(",")
        .take(Int.parser())
        .map { Point(x: $0.0, y: $0.1) }

    static let points = Many(point, separator: "\n")
        .map { Set($0) }

    static let fold = StartsWith("fold along ")
        .take(PrefixUpTo("="))
        .skip("=")
        .take(Int.parser())
        .map { (axis: String($0.0), value: $0.1) }

    static let folds = Many(fold, separator: "\n")

    static let inputParser = points
        .skip("\n\n")
        .take(folds)
        .map { (marks: $0.0, folds: $0.1) }

    static func parseInput(_ input: String) -> Input {
        var input = input[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }

    static func translatePointX(_ point: Point, midPoint: Int) -> Point {
        let delta = (point.x - midPoint)
        return .init(x: midPoint - delta, y: point.y)
    }

    static func translatePointY(_ point: Point, midPoint: Int) -> Point {
        let delta = (point.y - midPoint)
        return .init(x: point.x, y: (midPoint - delta))
    }

    static func foldGrid(_ grid: MarkedGrid, at foldPoint: FoldPoint) -> Set<Point> {
        switch foldPoint {
        case ("x", let midPointX):
            let leftOfFold = grid.filter { $0.x < midPointX }
            let rightOfFold = grid.filter { $0.x > midPointX }
            let foldedPoints = rightOfFold.map { translatePointX($0, midPoint: midPointX) }
            return leftOfFold.union(foldedPoints)
        case ("y", let midPointY):
            let aboveTheFold = grid.filter { $0.y < midPointY }
            let belowTheFold = grid.filter { $0.y > midPointY }
            let foldedPoints = belowTheFold.map { translatePointY($0, midPoint: midPointY) }
            return aboveTheFold.union(foldedPoints)
        default:
            fatalError("Can only fold along the 'x' or 'y' axis")
        }
    }

    static func applyFolds(_ folds: [FoldPoint], to grid: MarkedGrid) -> MarkedGrid {
        folds.reduce(grid) { grid, fold in
            return foldGrid(grid, at: fold)
        }
    }

    static func processInput(_ input: Input) -> MarkedGrid {
        applyFolds(input.folds, to: input.marks)
    }

    static func visualiseGrid(_ grid: MarkedGrid) {
        let maxX = grid.map(\.x).max()!
        let maxY = grid.map(\.y).max()!
        for y in (0...maxY) {
            for x in (0...maxX) {
                let isMarked = grid.contains { $0.x == x && $0.y == y }
                print(isMarked ? "#" : ".", separator: "", terminator: "")
            }
            print("\n")
        }
        print("\n\n")
    }

    static let partOne = pipe(
        parseInput,
        over(\.folds, { [$0[0]]} ),
        processInput,
        get(\.count)
    )

    static let partTwo = pipe(
        parseInput,
        processInput,
        visualiseGrid
    )
}
