import Foundation
import Parsing
import Overture

enum Day17 {
    typealias Velocity = (x: Int, y: Int)
    typealias Position = (x: Int, y: Int)
    typealias TargetArea = (x: ClosedRange<Int>, y: ClosedRange<Int>)
    
    // MARK: - Parsing
    
    static let range = Int.parser()
        .skip("..")
        .take(Int.parser())
        .map { $0...$1 }
    
    static let targetArea = StartsWith<Substring>("target area: ")
        .skip("x=")
        .take(range)
        .skip(", y=")
        .take(range)
        .map { TargetArea(x: $0, y: $1) }
    
    static func parseInput(_ input: String) -> TargetArea {
        guard let result = targetArea.parse(input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Calculations
    
    static func isWithinTargetArea(
        position: Position,
        targetArea: TargetArea
    ) -> Bool {
        targetArea.x.contains(position.x) && targetArea.y.contains(position.y)
    }
    
    static func hasMissed(
        position: Position,
        targetArea: TargetArea
    ) -> Bool {
        hasOvershot(position: position, targetArea: targetArea)
            || hasFallenShort(position: position, targetArea: targetArea)
            || hasPassedThrough(position: position, targetArea: targetArea)
    }
    
    static func hasOvershot(position: Position, targetArea: TargetArea) -> Bool {
        position.x > targetArea.x.upperBound
    }
    
    static func hasFallenShort(position: Position, targetArea: TargetArea) -> Bool {
        position.y < targetArea.y.lowerBound && position.x < targetArea.x.lowerBound
    }
    
    static func hasPassedThrough(position: Position, targetArea: TargetArea) -> Bool {
        position.y < targetArea.y.lowerBound && targetArea.x.contains(position.x)
    }
    
    static func performMovementStep(
        from position: Position,
        velocity: Velocity
    ) -> (Position, Velocity) {
        let newPosition = Position(
            x: position.x + velocity.x,
            y: position.y + velocity.y
        )
        let newVelocity = Velocity(
            x: (velocity.x < 0) ? velocity.x + 1 : max(velocity.x - 1, 0),
            y: velocity.y - 1
        )
        return (newPosition, newVelocity)
    }
    
    static func performMovement(
        towards targetArea: TargetArea,
        initialVelocity: Velocity
    ) -> (Bool, [Position], Velocity) {
        var currentPosition = Position(x: 0, y: 0)
        var currentVelocity = initialVelocity
        var positions: [Position] = [currentPosition]
        
        while !hasMissed(position: currentPosition, targetArea: targetArea) {
            (currentPosition, currentVelocity) = performMovementStep(
                from: currentPosition,
                velocity: currentVelocity
            )
            
            positions.append(currentPosition)
//            print("Moved to \(currentPosition)")
            
            if isWithinTargetArea(position: currentPosition, targetArea: targetArea) {
                return (true, positions, currentVelocity)
            }
        }
        return (false, positions, currentVelocity)
    }
    
    static func findHeighestPosition(in positions: [Position]) -> Position {
        precondition(positions.count > 0, "You must provide at least one position!")
        return positions.max { $0.y < $1.y }!
    }
    
    static func findMostStylishVelocity(targetArea: TargetArea) -> Velocity {
        // lets choose some artificial bounds for brute forcing.
        let xRange = (0...200)
        let yRange = (0...200)
        
        var heighestPosition = Position(x: 0, y: 0)
        
        for x in xRange {
            for y in yRange {
                let (onTarget, positions, _) = performMovement(
                    towards: targetArea,
                    initialVelocity: (x: x, y: y)
                )
                let lastHeighest = findHeighestPosition(in: positions)
                
                if onTarget, lastHeighest > heighestPosition {
                    heighestPosition = lastHeighest
                }
            }
        }
        return heighestPosition
    }
    
    static let partOne = pipe(parseInput, findMostStylishVelocity)
}
