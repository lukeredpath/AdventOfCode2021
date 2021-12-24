import Foundation
import Parsing
import Overture
import simd

enum Day22 {
    typealias Cuboid = (x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>)
    typealias CubeState = Bool
    typealias RebootStep = (state: CubeState, cuboid: Cuboid)
    typealias Cube = SIMD3<Int>
    typealias Reactor = Dictionary<Cube, CubeState>
    
    // MARK: - Parsing
    
    static let onState = StartsWith<Substring>("on").map { true }
    
    static let offState = StartsWith<Substring>("off").map { false }
    
    static let coordRange = Int.parser()
        .skip("..")
        .take(Int.parser())
        .map { $0.0...$0.1 }
    
    static let cuboid = StartsWith("x=")
        .take(coordRange)
        .skip(",y=")
        .take(coordRange)
        .skip(",z=")
        .take(coordRange)
        .map { (x: $0.0, y: $0.1, z: $0.2) }
    
    static let rebootStep = onState
        .orElse(offState)
        .skip(" ")
        .take(cuboid)
        .map { (state: $0.0, cuboid: $0.1) }
    
    static let input = Many(rebootStep, separator: "\n")
    
    static func parseInput(_ inputString: String) -> [RebootStep] {
        guard let result = input.parse(inputString) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Calcuations

    static func performRebootStep(_ step: RebootStep, on reactor: inout Reactor) {
        for x in step.cuboid.x {
            for y in step.cuboid.y {
                for z in step.cuboid.z {
                    let cube = Cube(x: x, y: y, z: z)
                    reactor[cube] = step.state
                }
            }
        }
    }

    static func countTurnedOn(in reactor: Reactor) -> Int {
        reactor.values.filter { $0 }.count
    }
    
    static func rebootReactor(steps: [RebootStep]) -> Reactor {
        steps.reduce(into: [:]) { reactor, step in
            performRebootStep(step, on: &reactor)
        }
    }
    
    static func rebootReactorOptimized(steps: [RebootStep]) -> Int {
        var processedSteps: [RebootStep] = []
        
        for step in steps {
            let intersectingSteps = processedSteps.compactMap { existingStep -> RebootStep? in
                // If the steps do not overlap, we don't need to do anything.
                guard let intersection = intersection(
                    between: existingStep.cuboid,
                    and: step.cuboid
                ) else { return nil } // no overlap
                
                if existingStep.state {
                    // if the intersection is with an existing on step, we should
                    // add an off intersection to mirror it so we don't double-count the ons.
                    return (state: false, cuboid: intersection)
                } else {
                    // if the intersection is with an existing off step, we should
                    // add an on intersection to mirror it so we don't double-count the offs.
                    return (state: true, cuboid: intersection)
                }
            }
            
            if step.state {
                processedSteps.append(step)
            }
            
            processedSteps.append(contentsOf: intersectingSteps)
        }
        
        // Now we can simply calculate the volume of on cuboids minus off cuboids
        return calculateOnCubes(steps: processedSteps)
    }
    
    static let initializationZone: Cuboid = (x: -50...50, y: -50...50, z: -50...50)
    
    static func filterInitializationSteps(_ allSteps: [RebootStep]) -> [RebootStep] {
        allSteps.filter(isInitializationStep)
    }

    static func isInitializationStep(_ step: RebootStep) -> Bool {
        guard let intersection = intersection(between: initializationZone, and: step.cuboid)
        else { return false } // is not contained within the zone at all
        
        // If the intersection matches the original cuboid, it must be fully contained.
        return (
            intersection.x == step.cuboid.x &&
            intersection.y == step.cuboid.y &&
            intersection.z == step.cuboid.z
        )
    }
    
    static func intersection(between first: Cuboid, and second: Cuboid) -> Cuboid? {
        guard
            let x = calculateOverlap(first: first.x, second: second.x),
            let y = calculateOverlap(first: first.y, second: second.y),
            let z = calculateOverlap(first: first.z, second: second.z)
        else { return nil }
        
        return (x: x, y: y, z: z)
    }
    
    static func calculateOnCubes(steps: [RebootStep]) -> Int {
        return steps.reduce(0) { sum, step in
            if step.state {
                return sum + cuboidVolume(step.cuboid)
            } else {
                return sum - cuboidVolume(step.cuboid)
            }
        }
    }
    
    static func cuboidVolume(_ cuboid: Cuboid) -> Int {
        cuboid.x.count * cuboid.y.count * cuboid.z.count
    }
    
    private static func calculateOverlap(
        first: ClosedRange<Int>,
        second: ClosedRange<Int>
    ) -> ClosedRange<Int>? {
        guard first.overlaps(second) else { return nil }
        
        if second.lowerBound <= first.upperBound && second.lowerBound >= first.lowerBound && second.upperBound > first.upperBound {
            // second lower bound overlaps with first upper bound
            return (second.lowerBound...first.upperBound)
        }
        if second.upperBound >= first.lowerBound && second.upperBound <= first.upperBound && second.lowerBound < first.lowerBound {
            // second upperbound overlaps with first lower bound
            return (first.lowerBound...second.upperBound)
        }
        if first.lowerBound >= second.lowerBound && first.upperBound <= second.upperBound {
            // first is contained within second
            return first
        }
        if second.lowerBound >= first.lowerBound && second.upperBound <= first.upperBound {
            // second is contained within first
            return second
        }
        fatalError("Unexpected overlap detected between \(first) and \(second).")
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(
        parseInput,
        filterInitializationSteps,
        rebootReactor,
        countTurnedOn
    )
    
    static let partOneOptimised = pipe(
        parseInput,
        filterInitializationSteps,
        rebootReactorOptimized
    )
    
    static let partTwo = pipe(
        parseInput,
        rebootReactorOptimized
    )
}
