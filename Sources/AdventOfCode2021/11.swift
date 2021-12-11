import Foundation
import Overture

enum Day11 {
    typealias OctupusGrid = [[Int]]
    typealias Point = Day09.Point
    typealias StepOutput = (grid: OctupusGrid, flashes: Int)
    
    static func findSurroundingPoints(of point: Point, in grid: OctupusGrid) -> Set<Point> {
        let previousColumn = max(point.col - 1, 0)
        let nextColumn = min(point.col + 1, grid[point.row].count - 1)
        let previousRow = max(point.row - 1, 0)
        let nextRow = min(point.row + 1, grid.count - 1)
        let points: [Point] = [
            .init(point.row, previousColumn),
            .init(point.row, nextColumn),
            .init(previousRow, point.col),
            .init(previousRow, previousColumn),
            .init(previousRow, nextColumn),
            .init(nextRow, point.col),
            .init(nextRow, previousColumn),
            .init(nextRow, nextColumn)
        ]
        return Set(points).subtracting([point])
    }
    
    static func incrementPower(grid: OctupusGrid) -> OctupusGrid {
        grid.map { row in row.map { $0 + 1 } }
    }
    
    static func performFlashes(grid: OctupusGrid) -> StepOutput {
        (grid, 0)
    }
    
    static func parseInput(_ input: String) -> OctupusGrid {
        []
    }
    
    static let performStep = pipe(incrementPower, performFlashes)
    
    static let stepOne = pipe(parseInput, performStep)
}
