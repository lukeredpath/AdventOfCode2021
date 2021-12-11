import Foundation
import Overture
import Parsing

enum Day11 {
    typealias OctupusGrid = [[Int]]
    typealias Point = Day09.Point
    typealias StepOutput = (grid: OctupusGrid, flashes: Int)
    
    static let gridValue = Prefix<Substring>
        .init(1, while: { $0.isNumber })
        .compactMap(pipe(String.init, Int.init))
    
    static let gridLine = Many(
        gridValue,
        atLeast: 10, atMost: 10
    )
    
    static let grid = Many(
        gridLine,
        atLeast: 10, atMost: 10,
        separator: "\n"
    )
    
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
    
    static func performFlashes(grid: OctupusGrid, flashCount: Int) -> StepOutput {
        var flashCount = flashCount
        var grid = grid
        for (rowIndex, row) in grid.enumerated() {
            for (colIndex, value) in row.enumerated() {
                if value > 9 {
                    flashCount += 1
                    grid[rowIndex][colIndex] = 0
                    for point in findSurroundingPoints(of: .init(rowIndex, colIndex), in: grid) {
                        if grid[point.row][point.col] == 0 { continue }
                        grid[point.row][point.col] += 1
                    }
                }
            }
        }
        if grid.flatMap({ $0 }).allSatisfy({ $0 <= 9 }) {
            return (grid, flashCount)
        }
        return performFlashes(grid: grid, flashCount: flashCount)
    }
    
    static func parseInput(_ input: String) -> OctupusGrid {
        var input = input[...]
        guard let result = grid.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    static func performSteps(grid: OctupusGrid, stepCount: Int) -> StepOutput {
        let initialOutput: StepOutput = (grid, 0)
        return (1...stepCount).reduce(into: initialOutput) { output, _ in
            let result = performStep(output.grid)
            output = (result.grid, result.flashes + output.flashes)
        }
    }
    
    static func isInSync(_ grid: OctupusGrid) -> Bool {
        grid.flatMap { $0 }.allSatisfy { $0 == 0 }
    }
    
    static func findSyncPoint(grid: OctupusGrid) -> Int {
        var stepNumber = 0
        var inSync = false
        var grid = grid
        while !inSync {
            stepNumber += 1
            grid = performStep(grid).grid
            inSync = isInSync(grid)
        }
        return stepNumber
    }
    
    static let performStep = pipe(
        incrementPower,
        with(0, flip(curry(performFlashes)))
    )
    
    static let partOne = pipe(
        parseInput,
        with(100, flip(curry(performSteps)))
    )
    
    static let partTwo = pipe(
        parseInput,
        findSyncPoint
    )
}
