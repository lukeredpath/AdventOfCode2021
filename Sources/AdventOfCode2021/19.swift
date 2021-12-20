import Foundation
import Overture
import Parsing
import simd

@available(macOS 10.12, *)
enum Day19 {
    typealias Coord3D = simd_int3
    typealias Rotation = simd_int3 // rotation in degrees
    typealias Scanner = (number: Int, beacons: Set<Coord3D>)
    typealias Input = [Scanner]
    typealias Overlap = (
        first: Int,
        second: Int,
        translation: Coord3D,
        rotation: Coord3D
    )
    
    // MARK: - Parsing
    
    static let coordinate = Int32.parser()
        .skip(",")
        .take(Int32.parser())
        .skip(",")
        .take(Int32.parser())
        .map { Coord3D(x: $0.0, y: $0.1, z: $0.2) }
    
    static let scannerHeader = StartsWith("--- scanner ")
        .take(Int.parser())
        .skip(" ---")
    
    static let scanner = scannerHeader
        .skip(("\n"))
        .take(Many(coordinate, separator: "\n").map(Set.init))
        .map { Scanner(number: $0.0, beacons: $0.1) }
    
    static let input = Many(scanner, separator: "\n\n")
    
    static func parseInput(_ inputString: String) -> Input {
        guard let result = input.parse(inputString) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Calculations
    
    private static func rotateX(_ point: Coord3D, by angle: Double) -> Coord3D {
        let rotationMatrix: simd_double3x3 = double3x3([
            simd_double3(1,          0,            0),
            simd_double3(0,  cos(angle), -sin(angle)),
            simd_double3(0,   sin(angle), cos(angle))
        ])
        return applyRotationMatrix(rotationMatrix, to: point)
    }
    
    private static func rotateY(_ point: Coord3D, by angle: Double) -> Coord3D {
        let rotationMatrix: simd_double3x3 = double3x3([
            simd_double3(cos(angle),  0,  sin(angle)),
            simd_double3(0,           1,           0),
            simd_double3(-sin(angle), 0,  cos(angle))
        ])
        return applyRotationMatrix(rotationMatrix, to: point)
    }
    
    private static func rotateZ(_ point: Coord3D, by angle: Double) -> Coord3D {
        let rotationMatrix: simd_double3x3 = double3x3([
            simd_double3(cos(angle), -sin(angle), 0),
            simd_double3(sin(angle), cos(angle),  0),
            simd_double3(0,          0,           1)
        ])
        return applyRotationMatrix(rotationMatrix, to: point)
    }
    
    private static func applyRotationMatrix(_ matrix: simd_double3x3, to point: Coord3D) -> Coord3D {
        let doublePoint = simd_double3(
            x: Double(point.x),
            y: Double(point.y),
            z: Double(point.z)
        )
        let rotated = doublePoint * matrix
        return Coord3D(
            x: Int32(round(rotated.x)),
            y: Int32(round(rotated.y)),
            z: Int32(round(rotated.z))
        )
    }
    
    private static func degressToRadians(_ degrees: Int32) -> Double {
        let angle = Measurement(value: Double(degrees), unit: UnitAngle.degrees)
        return Double(angle.converted(to: .radians).value)
    }
    
    // This results in 48 orientations which includes flipped mirrors - we only
    // need half of these but for some reason I wasn't able to work out the right
    // list and this does work even though its doing more work than needed.
    private static let intervals: [Int32] = [0, 90, 180, -90]
    private static let possibleOrientations: [Rotation] = intervals.flatMap { x in
        intervals.flatMap { y in
            intervals.map { z in
                Rotation(x: x, y: y, z: z)
            }
        }
    }
    
    static func rotatePoint(_ point: Coord3D, by rotation: Rotation) -> Coord3D {
        let rotation: (Coord3D) -> Coord3D = pipe(
            with(degressToRadians(rotation.x), flip(curry(rotateX))),
            with(degressToRadians(rotation.y), flip(curry(rotateY))),
            with(degressToRadians(rotation.z), flip(curry(rotateZ)))
        )
        return rotation(point)
    }
    
    struct RotatedCoord3D: Hashable {
        var rotation: Rotation
        var coord: Coord3D
    }
    
    // Rotates a point for all possible scanner orientations.
    static func calculatePointPermutations(_ point: Coord3D) -> Set<RotatedCoord3D> {
        return Set(possibleOrientations.map { rotation in
            .init(rotation: rotation, coord: rotatePoint(point, by: rotation))
        })
    }
    
    static func translation(from pointA: Coord3D, to pointB: Coord3D) -> Coord3D {
        .init(
            x: pointA.x - pointB.x,
            y: pointA.y - pointB.y,
            z: pointA.z - pointB.z
        )
    }
    
    static func findScannerOverlap(
        scannerA: Scanner,
        scannerB: Scanner,
        minimumOverlappingPoints: Int = 12
    ) -> Overlap? {
        print("Finding overlaps between \(scannerA.number) and \(scannerB.number)")
        var translations: [Coord3D: [(Rotation, Coord3D)]] = [:]
        for pointA in scannerA.beacons {
            for pointB in scannerB.beacons {
                for rotatedCoord in calculatePointPermutations(pointB) {
                    var current = translations[pointB, default: []]
                    let translation = translation(from: pointA, to: rotatedCoord.coord)
                    current.append((rotatedCoord.rotation, translation))
                    translations[pointB] = current
                }
            }
        }
        
        let grouped = Dictionary(grouping: translations.flatMap { $0.value }, by: { $0.1 })
        
        // If there is a matching translation in at least 12 points in set b, then we
        // can consider that these sets overlap and the translation is the translation
        // from the scanner of set a to the scanner of set b.
        guard let overlapping = grouped.values.first(
            where: { $0.count >= minimumOverlappingPoints }
        ) else { return nil }
        
        return (
            first: scannerA.number,
            second: scannerB.number,
            translation: overlapping.first!.1,
            rotation: overlapping.first!.0
        )
    }
    
    
    static func findOverlappingScanners(input: Input) -> [Overlap] {
        let combinations = input.flatMap { scannerA in
            input.filter { $0 != scannerA }.map { scannerB in
                (scannerA, scannerB)
            }
        }
        return combinations.compactMap { (scannerA, scannerB) in
            findScannerOverlap(scannerA: scannerA, scannerB: scannerB)
        }
    }
    
    static func findBeacons(
        from scannerNumber: Int,
        input: Input,
        overlaps: [Overlap],
        alreadyCounted: inout [Int]
    ) -> Set<Coord3D> {
        guard !alreadyCounted.contains(scannerNumber) else { return [] }
        
        alreadyCounted.append(scannerNumber)
        
        let scanner = input.first { $0.number == scannerNumber }!
        let scannerOverlaps = overlaps.filter { overlap in
            overlap.first == scannerNumber
        }
        return scannerOverlaps.reduce(scanner.beacons) { beacons, overlap in
            let secondBeacons = findBeacons(
                from: overlap.second,
                input: input,
                overlaps: overlaps,
                alreadyCounted: &alreadyCounted
            )
            let secondBeaconsRelativeToFirst = Set(secondBeacons.map { beacon -> Coord3D in
                let rotatedPointB = Day19.rotatePoint(beacon, by: overlap.rotation)
                return Day19.Coord3D(
                    x: rotatedPointB.x + overlap.translation.x,
                    y: rotatedPointB.y + overlap.translation.y,
                    z: rotatedPointB.z + overlap.translation.z
                )
            })
            return beacons.union(secondBeaconsRelativeToFirst)
        }
    }
    
    static func countBeacons(input: Input) -> Int {
        let overlaps = findOverlappingScanners(input: input)
        var counted: [Int] = []
        let beaconsFromZero = findBeacons(
            from: 0,
            input: input,
            overlaps: overlaps,
            alreadyCounted: &counted
        )
        // also find any that we cannot be found by following
        // scanners directly from zero.
//        let notCounted = Set(input.map(\.number)).subtracting(counted)
//        let allBeacons = notCounted.reduce(beaconsFromZero) { beacons, number in
//            beacons.union(findBeacons(
//                from: number,
//                input: input,
//                overlaps: overlaps,
//                alreadyCounted: &counted
//            ))
//        }
        assert(input.count == counted.count)
        return beaconsFromZero.count
    }
    
    static func calculateScannerPositions(input: Input) -> [Int: Coord3D] {
//        var positions: [Int: Coord3D] = [:]
        let overlaps = findOverlappingScanners(input: input)
        var calculated: [Int] = []
        
        return calculateNextScannerPosition(
            from: (0, .init(x: 0, y: 0, z: 0), .init(x: 0, y: 0, z: 0)),
            overlaps: overlaps,
            alreadyCalculated: &calculated
        )
        assert(calculated.count == input.count)
        
//        return positions
    }
    
    static func calculateNextScannerPosition(
        from scanner: (number: Int, position: Coord3D, rotation: Coord3D),
        overlaps: [Overlap],
        alreadyCalculated: inout [Int]
    ) -> [Int: Coord3D] {
        guard !alreadyCalculated.contains(scanner.number) else { return [:] }
        
        var positions: [Int: Coord3D] = [scanner.0: scanner.1]
        
        alreadyCalculated.append(scanner.number)
        
        let scannerOverlaps = overlaps.filter { overlap in
            overlap.first == scanner.0
        }
        for overlap in scannerOverlaps {
//            let rotated = rotatePoint(overlap.translation, by: scanner.rotation)
            let position = rotatePoint(Coord3D(
                x: scanner.position.x + overlap.translation.x,
                y: scanner.position.y + overlap.translation.y,
                z: scanner.position.z + overlap.translation.z
            ), by: scanner.rotation)
            
            let nextPositions = calculateNextScannerPosition(
                from: (overlap.second, position, overlap.rotation),
                overlaps: overlaps,
                alreadyCalculated: &alreadyCalculated
            )
            for key in nextPositions.keys {
                let position = nextPositions[key]!
                positions[key] = rotatePoint(position, by: scanner.rotation)
            }
        }
        return positions
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(parseInput, countBeacons)
}
