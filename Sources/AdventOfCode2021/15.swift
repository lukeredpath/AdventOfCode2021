import Foundation
import Parsing
import Overture

enum Day15 {
    typealias Point = Day05.Point
    typealias Grid = [[Int]]
    
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
        var unvisited = pointsInGrid(grid)
        precondition(unvisited.count > 0, "Cannot calculate path through empty grid")

        let start = Point(x: 0, y: 0)
        let target = Point(x: grid[0].count - 1, y: grid.count - 1)
        var distances: [Point: Int] = [start: 0]
        var currentNode: Point? = start
        
        while let node = currentNode {
            let neighbours: Set<Point> = [
                .init(x: node.x + 1, y: node.y),
                .init(x: node.x, y: node.y + 1)
            ]
            
            guard let currentNodeDistance = distances[node] else {
                fatalError("Could not find distance for current node.")
            }
            
            for neighbour in neighbours {
                guard unvisited.contains(neighbour) else { continue }
                
                let value = lookupValue(in: grid, at: neighbour)
                let distanceThroughCurrent = currentNodeDistance + value
                
                if let currentNeighbourDistance = distances[neighbour] {
                    if distanceThroughCurrent < currentNeighbourDistance {
                        distances[neighbour] = distanceThroughCurrent
                    }
                } else {
                    distances[neighbour] = distanceThroughCurrent
                }
            }
            
            unvisited.remove(node)
            
            let nextNode = unvisited.sorted {
                distances[$0, default: .max] < distances[$1, default: .max]
            }.first!
            
            if nextNode == target {
                currentNode = nil
            } else {
                currentNode = nextNode
            }
        }
        
        return distances[target]!
    }
    
    static let partOne = pipe(parseInput, findShortestDistance)
}
