    import XCTest
    @testable import AdventOfCode2021

    final class AdventOfCode2021Tests: XCTestCase {
        func test01_Part1_Solution() async {
            let result = Day01.partOne(input_01)
            XCTAssert(result > 0, "Expected count to be non-zero")
            print("Number of increases: \(result)")
        }

        func test01_Part2_Solution() {
            let result = Day01.partTwo(input_01)
            XCTAssert(result > 0, "Expected count to be non-zero")
            print("Number of window increases: \(result)")
        }

        func test02_Part1_ExampleCalculation() {
            var position: Day02.Position = (horizontal: 0, depth: 0)

            position = Day02.calculatePosition(
                from: position,
                movements: [.forward(3), .down(5)]
            )

            XCTAssertEqual(position.horizontal, 3)
            XCTAssertEqual(position.depth, 5)

            position = Day02.calculatePosition(
                from: position,
                movements: [.up(1), .forward(5), .down(2)]
            )

            XCTAssertEqual(position.horizontal, 8)
            XCTAssertEqual(position.depth, 6)
        }

        func test02_Part1_Solution() {
            let result = Day02.partOne(input_02)
            XCTAssert(result > 0, "Expected final position to be non-zero")
            print("Final position: \(result)")
        }
    }
