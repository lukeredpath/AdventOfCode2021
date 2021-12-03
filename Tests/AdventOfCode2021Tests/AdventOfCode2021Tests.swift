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

        func test02_Part1_ExampleCalculationNoAim() {
            var position: Day02.Position = (horizontal: 0, depth: 0, aim: 0)

            position = Day02.calculatePositionNoAim(
                from: position,
                movements: [.forward(3), .down(5)]
            )

            XCTAssertEqual(position.horizontal, 3)
            XCTAssertEqual(position.depth, 5)

            position = Day02.calculatePositionNoAim(
                from: position,
                movements: [.up(1), .forward(5), .down(2)]
            )

            XCTAssertEqual(position.horizontal, 8)
            XCTAssertEqual(position.depth, 6)
        }

        func test02_Part1_Parser() throws {
            var input = "forward 1"[...]
            let result_1 = try XCTUnwrap(Day02.movementRowParser.parse(&input))
            XCTAssertEqual("", input)
            XCTAssertEqual(result_1, .forward(1))

            input = "up 2"[...]
            let result_2 = try XCTUnwrap(Day02.movementRowParser.parse(&input))
            XCTAssertEqual("", input)
            XCTAssertEqual(result_2, .up(2))

            input = "down 3"[...]
            let result_3 = try XCTUnwrap(Day02.movementRowParser.parse(&input))
            XCTAssertEqual("", input)
            XCTAssertEqual(result_3, .down(3))
        }

        func test02_Part1_ExampleCalculationWithAim() {
            var position: Day02.Position = (horizontal: 0, depth: 0, aim: 0)

            position = Day02.calculatePositionWithAim(
                from: position,
                movements: [.forward(3)]
            )

            XCTAssertEqual(position.horizontal, 3)
            XCTAssertEqual(position.depth, 0)
            XCTAssertEqual(position.aim, 0)

            position = Day02.calculatePositionWithAim(
                from: position,
                movements: [.down(2), .forward(2)]
            )

            XCTAssertEqual(position.horizontal, 5)
            XCTAssertEqual(position.depth, 4)
            XCTAssertEqual(position.aim, 2)

            position = Day02.calculatePositionWithAim(
                from: position,
                movements: [.up(1), .down(5), .forward(5)]
            )

            XCTAssertEqual(position.horizontal, 10)
            XCTAssertEqual(position.depth, 34)
            XCTAssertEqual(position.aim, 6)
        }

        func test02_Part1_Solution() {
            let result = Day02.partOne(input_02)
            XCTAssert(result > 0, "Expected final position to be non-zero")
            print("Final position: \(result)")
        }

        func test02_Part2_Solution() {
            let result = Day02.partTwo(input_02)
            XCTAssert(result > 0, "Expected final position to be non-zero")
            print("Final position (with aim): \(result)")
        }

        func test03_Part3_Parsing() throws {
            var input = "0"[...]
            let bitZero = try XCTUnwrap(Day03.bitParser.parse(&input))
            XCTAssertEqual(0, bitZero)

            input = "1"[...]
            let bitOne = try XCTUnwrap(Day03.bitParser.parse(&input))
            XCTAssertEqual(1, bitOne)

            input = "2"[...]
            let notABit = Day03.bitParser.parse(&input)
            XCTAssertNil(notABit)

            var incompleteRow = "0010"[...]
            XCTAssertNil(Day03.rowParser.parse(&incompleteRow))

            var rowInput = "00101"[...]
            let result = try XCTUnwrap(Day03.rowParser.parse(&rowInput))
            XCTAssertEqual("", rowInput)
            XCTAssertEqual(result.0, 0)
            XCTAssertEqual(result.1, 0)
            XCTAssertEqual(result.2, 1)
            XCTAssertEqual(result.3, 0)
            XCTAssertEqual(result.4, 1)
        }
    }
