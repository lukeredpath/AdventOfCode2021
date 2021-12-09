import Foundation
import Overture
import Parsing

enum Day09 {
    typealias HeightMap = [[Int]]

    struct Point: Hashable {
        var row: Int
        var col: Int

        init( _ row: Int, _ col: Int) {
            self.row = row
            self.col = col
        }
    }

    typealias Basin = Set<Point>

    static let inputRowParser = Many(
        Prefix<Substring>(1, while: { $0 != "\n" })
            .compactMap(pipe(String.init, Int.init))
    )

    static let inputParser = Many(inputRowParser, separator: "\n")

    static func parseInput(_ input: String) -> HeightMap {
        var input = input[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input")
        }
        return result
    }

    static func findValue(at point: Point, in map: HeightMap) -> Int {
        map[point.row][point.col]
    }

    static func findValues(at points: [Point], in map: HeightMap) -> [Int] {
        points.map(with(map, flip(curry(findValue))))
    }

    static func findSurroundingPoints(of point: Point, in map: HeightMap) -> [Point] {
        var points: [Point] = []
        if point.col > 0 {
            points.append(.init(point.row, point.col - 1))
        }
        if (point.col + 1) < map[point.row].count {
            points.append(.init(point.row, point.col + 1))
        }
        if point.row > 0 {
            points.append(.init(point.row - 1, point.col))
        }
        if (point.row + 1) < map.count {
            points.append(.init(point.row + 1, point.col))
        }
        return points
    }

    static func allPoints(in map: HeightMap) -> [Point] {
        map.enumerated().flatMap { (rowIndex, row) in
            row.enumerated().map { (colIndex, _) -> Point in
                .init(rowIndex, colIndex)
            }
        }
    }

    static func isLowPoint(_ point: Point, in map: HeightMap) -> Bool {
        let height = findValues(at: [point], in: map)[0]
        let surroundingPoints = findSurroundingPoints(of: point, in: map)
        return findValues(at: surroundingPoints, in: map).allSatisfy { value in
            value > height
        }
    }

    static func findLowPoints(in map: HeightMap) -> [Point] {
        allPoints(in: map).filter { isLowPoint($0, in: map) }
    }

    static func findLowPointValues(in map: HeightMap) -> [Int] {
        findValues(at: findLowPoints(in: map), in: map)
    }

    static func findBasins(in map: HeightMap) -> [Basin] {
        findLowPoints(in: map).map { point in
            findBasin(from: point, in: map)
        }
    }

    static func findBasin(from point: Point, in map: HeightMap) -> Basin {
        let pointHeight = findValue(at: point, in: map)
        return Set([point] + findSurroundingPoints(of: point, in: map).flatMap { adjacentPoint -> Basin in
            let adjacentHeight = findValue(at: adjacentPoint, in: map)
            guard adjacentHeight > pointHeight, adjacentHeight != 9 else {
                return []
            }
            return findBasin(from: adjacentPoint, in: map)
        })
    }

    static func calculateRiskScore(lowPoints: [Int]) -> Int {
        lowPoints.reduce(0, +) + lowPoints.count
    }

    static func findThreeLargestBasins(in basins: [Basin]) -> [Basin] {
        Array(basins.sorted { $0.count > $1.count }[0..<3])
    }

    static func calculateBasinScore(basins: [Basin]) -> Int {
        basins.dropFirst().map(\.count).reduce(basins[0].count, *)
    }

    static let partOne = pipe(
        parseInput,
        findLowPointValues,
        calculateRiskScore
    )

    static let partTwo = pipe(
        parseInput,
        findBasins,
        findThreeLargestBasins,
        calculateBasinScore
    )
}
