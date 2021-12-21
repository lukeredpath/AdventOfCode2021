import Foundation
import Overture
import Parsing

enum Day20 {
    typealias Grid = [[UInt]]
    typealias Point = Day11.Point
    typealias Algorithm = [UInt]
    typealias Input = (algorithm: Algorithm, image: Grid)
    
    // MARK: - Parsing
    
    static let light = Prefix<Substring>(1) { $0 == "#" }.map { _ in UInt(1) }
    static let dark = Prefix<Substring>(1) { $0 == "." }.map { _ in UInt(0) }
    static let pixel = light.orElse(dark)
    static let algorithm = Many(pixel, exactly: 512).skip("\n")
    static let inputRow = Many(pixel)
    static let inputImage = Many(inputRow, separator: "\n")
    static let input = algorithm.skip("\n").take(inputImage)
    
    static func parseInput(_ inputString: String) -> Input {
        guard let result = input.parse(inputString) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
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
    
    static func padGrid(_ grid: Grid, padValue: UInt) -> Grid {
        guard grid.count > 0 else { return [] }

        let colCount = grid[0].count
        let darkRow: [UInt] = Array(repeating: padValue, count: colCount + 4)
        let colPadded: Grid = grid.map { row in
            [padValue, padValue] + row + [padValue, padValue]
        }
        
        return [darkRow, darkRow] + colPadded + [darkRow, darkRow]
    }
    
    static func indexForPoint(_ point: Point, in grid: Grid) -> Int {
        Int(binaryNumberStringFromPoint(point, in: grid), radix: 2) ?? 0
    }
    
    static func enhanceGrid(
        _ grid: Grid,
        algorithm: Algorithm,
        iteration: Int
    ) -> Grid {
        // Infinitely expanding pixels start as off and then flicker
        // between on and off when the 0-bit is lit.
        let zeroValue = (iteration % 2 == 0) ? algorithm[0] : 0
        let padded = padGrid(grid, padValue: zeroValue)
        let rows = (1..<padded.count - 1)
        let cols = (1..<padded[0].count - 1)
        return rows.map { row in
            cols.map { col in
                let point = Point(row, col)
                let index = indexForPoint(point, in: padded)
                return algorithm[index]
            }
        }
    }
    
    static func countLitPixels(in grid: Grid) -> UInt {
        grid.reduce(0) { total, row in
            row.reduce(total, +)
        }
    }
    
    static func printGrid(_ grid: Grid, print: (String) -> Void = debugPrint) {
        for row in grid {
            for col in row {
                print(col == 1 ? "#" : ".")
            }
            print("\n")
        }
    }
    
    // MARK: - Solutions
    
    static let debugPrint: (String) -> Void = {
        print($0, separator: "", terminator: "")
    }
    
    static func enhanceInput(_ input: Input, times: Int) -> UInt {
        let grid = (1..<times + 1).reduce(input.image) { grid, iter in
            enhanceGrid(
                grid,
                algorithm: input.algorithm,
                iteration: iter
            )
        }
        return countLitPixels(in: grid)
    }
    
    static let partOne = pipe(
        parseInput,
        with(2, flip(curry(enhanceInput)))
    )
    
    static let partTwo = pipe(
        parseInput,
        with(50, flip(curry(enhanceInput)))
    )
}
