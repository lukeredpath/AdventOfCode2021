    import XCTest
    @testable import AdventOfCode2021

    final class AdventOfCode2021Tests: XCTestCase {
        func test01_Part1() async {
            let result = Day01.partOne(input_001)
            XCTAssert(result > 0, "Expected count to be non-zero")
            print("Number of increases: \(result)")
        }

        func test01_Part2() {
            let result = Day01.partTwo(input_001)
            XCTAssert(result > 0, "Expected count to be non-zero")
            print("Number of window increases: \(result)")
        }
    }
