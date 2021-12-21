import Foundation
import Overture
import Parsing

enum Day20 {
    typealias Grid = [[UInt]]
    typealias Point = Day11.Point
    typealias Algorithm = [UInt]
    
    // MARK: - Parsing
    
    static let light = Prefix<Substring>(1) { $0 == "#" }.map { _ in UInt(1) }
    static let dark = Prefix<Substring>(1) { $0 == "." }.map { _ in UInt(0) }
    static let algorithm = Many(light.orElse(dark)).skip("\n")
    
    // MARK: - Calculations
    
    static func binaryNumberStringFromPoint(
        _ point: Point,
        in grid: Grid
    ) -> String {
        guard grid.count > 0 else { return "" }

        return (-1...1).reduce(into: "") { string, rowOffset in
            guard (0..<grid.count).contains(point.row + rowOffset) else {
                string += "0"
                return
            }
            string += (-1...1).compactMap { colOffset in
                guard (0..<grid[0].count).contains(point.col + colOffset) else {
                    return nil
                }
                let pixel = grid[point.row + rowOffset][point.col + colOffset]
                return pixel == 1 ? "1" : "0"
            }
        }
    }
    
    static func padGrid(_ grid: Grid) -> Grid {
        guard grid.count > 0 else { return [] }

        let colCount = grid[0].count
        let darkRow: [UInt] = Array(repeating: 0, count: colCount + 4)
        let colPadded: Grid = grid.map { row in
            [0, 0] + row + [0, 0]
        }
        
        return [darkRow, darkRow] + colPadded + [darkRow, darkRow]
    }
    
    static func indexForPoint(_ point: Point, in grid: Grid) -> Int {
        Int(binaryNumberStringFromPoint(point, in: grid), radix: 2) ?? 0
    }
    
    static func enhanceGrid(_ grid: Grid, algorithm: Algorithm) -> Grid {
        let padded = padGrid(grid)
        let rows = (1..<padded.count-1)
        let cols = (1..<padded[0].count - 1)
        return rows.map { row in
            cols.map { col in
                let point = Point(row, col)
                let index = indexForPoint(point, in: padded)
                return algorithm[index]
            }
        }
    }
    
    static func printGrid(_ grid: Grid, print: (String) -> Void) {
        for row in grid {
            for col in row {
                print(col == 1 ? "#" : ".")
            }
            print("\n")
        }
    }
}
