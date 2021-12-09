import Foundation
import Overture
import Parsing

enum Day09 {
    typealias HeightMap = [[Int]]

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

    static func findLowPoints(in map: HeightMap) -> [Int] {
        map.enumerated().flatMap { (rowIndex, row) in
            row.enumerated().compactMap { (colIndex, value) in
                guard
                    (colIndex > 0 ? value < row[colIndex - 1] : true) &&
                    (colIndex < (row.count - 1) ? value < row[colIndex + 1] : true) &&
                    (rowIndex > 0 ? value < map[rowIndex - 1][colIndex] : true) &&
                    (rowIndex < (map.count - 1) ? value < map[rowIndex + 1][colIndex] : true)
                else { return nil }
                return value
            }
        }
    }

    static func calculateRiskScore(lowPoints: [Int]) -> Int {
        lowPoints.reduce(0, +) + lowPoints.count
    }

    static let partOne = pipe(parseInput, findLowPoints, calculateRiskScore)
}
