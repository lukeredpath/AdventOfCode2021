import Foundation
import Parsing
import Overture

enum Day15 {
    typealias Point = Day05.Point
    typealias Grid = [[Int]]
    typealias Distance = (point: Point, risk: Int)
    
    // MARK: - Parsing
    
    static let node = Prefix<Substring>(1)
        .compactMap(pipe(String.init, Int.init))
    
    static let row = Many(node, atLeast: 1)

    static let grid = Many(row, atLeast: 1, separator: "\n")
    
    static func parseInput(_ input: String) -> Grid {
        var input = input[...]
        guard let result = grid.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Grid calculations
    
    static func lookupValue(in grid: Grid, at point: Point) -> Int {
        grid[point.y][point.x]
    }
    
    static func pointsInGrid(width: Int, height: Int) -> Set<Point> {
        Set((0..<width).flatMap { x in
            (0..<height).map { y -> Point in
                .init(x: x, y: y)
            }
        })
    }
    
    static func pointsInGrid(_ grid: Grid) -> Set<Point> {
        pointsInGrid(width: grid[0].count, height: grid.count)
    }
    
    static func findShortestDistance(in grid: Grid) -> Int {
        // dijktstra
        let start = Point(x: 0, y: 0)
        let target = Point(x: grid[0].count - 1, y: grid.count - 1)
        var distances: [Point: Int] = [start: 0]
        var queue = PriorityQueue<Point> {
            distances[$0, default: .max] < distances[$1, default: .max]
        }
        for point in pointsInGrid(grid) {
            queue.enqueue(point)
        }
        
        while let node = queue.dequeue() {
            guard node != target else { break }
            
            let neighbours: Set<Point> = [
                .init(x: node.x + 1, y: node.y),
                .init(x: node.x, y: node.y + 1)
            ]
            
            guard let currentNodeDistance = distances[node] else {
                fatalError("Could not find distance for current node.")
            }
            
            for neighbour in neighbours {
                guard let index = queue.index(of: neighbour) else { continue }
                
                let value = lookupValue(in: grid, at: neighbour)
                let distanceThroughCurrent = currentNodeDistance + value

                if distanceThroughCurrent < distances[neighbour, default: .max] {
                    distances[neighbour] = distanceThroughCurrent
                    queue.changePriority(index: index, value: neighbour)
                }
            }
        }
        
        return distances[target]!
    }
    
    static func extrapolateFullGrid(from tile: Grid) -> Grid {
        // converts a 1 tile grid to a 5x1 tile grid
        let extrapolateCols: (Grid) -> Grid = { tile in
            tile.map { row in
                (0..<5).flatMap { tileX in
                    row.map { increaseRisk($0, by: tileX) }
                }
            }
        }
        // converts a 5x1 tile grid to a 5x5 tile grid
        let extrapolateRows: (Grid) -> Grid = { tile in
            (0..<5).flatMap { tileY in
                tile.map { row in
                    row.map { increaseRisk($0, by: tileY) }
                }
            }
        }
        return extrapolateCols(extrapolateRows(tile))
    }
    
    static func increaseRisk(_ risk: Int, by increase: Int) -> Int {
        let newRisk = risk + increase
        return (newRisk <= 9) ? newRisk : newRisk - 9
    }
    
    static let partOne = pipe(parseInput, findShortestDistance)
    static let partTwo = pipe(parseInput, extrapolateFullGrid, findShortestDistance)
}
