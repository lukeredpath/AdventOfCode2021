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
    
    static func initializeReactor(steps: [RebootStep]) -> Reactor {
        steps.reduce(into: [:]) { reactor, step in
            performRebootStep(step, on: &reactor)
        }
    }
    
    static func filterInitializationSteps(_ allSteps: [RebootStep]) -> [RebootStep] {
        allSteps.filter { step in
            step.cuboid.x.lowerBound >= -50 && step.cuboid.x.upperBound <= 50 &&
            step.cuboid.y.lowerBound >= -50 && step.cuboid.y.upperBound <= 50 &&
            step.cuboid.z.lowerBound >= -50 && step.cuboid.z.upperBound <= 50
        }
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(
        parseInput,
        filterInitializationSteps,
        initializeReactor,
        countTurnedOn
    )
}
