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

        func test03_Part1_ExampleAnalysis() {
            let exampleBitsInput = """
            00100
            11110
            10110
            10111
            10101
            01111
            00111
            11100
            10000
            11001
            00010
            01010
            """

            let exampleBits = Day03.parseInput(lines: exampleBitsInput)
            let diagnostic = Day03.analyseReport(exampleBits)

            XCTAssertEqual(diagnostic.gamma, 22)
            XCTAssertEqual(diagnostic.epsilon, 9)
            XCTAssertEqual(Day03.calculatePowerConsumption(from: diagnostic), 198)
        }

        func test03_Part1_Solution() {
            let result = Day03.partOne(input_03)
            XCTAssert(result > 0, "Expected power consumption to be non-zero")
            print("Power consumption: \(result)")
        }

        func test03_Part2_ExampleAnalysis() {
            let exampleBitsInput = """
            00100
            11110
            10110
            10111
            10101
            01111
            00111
            11100
            10000
            11001
            00010
            01010
            """

            let exampleBits = Day03.parseInput(lines: exampleBitsInput)
            let oxygenRating = Day03.calculateOxygenGeneratorRating(from: exampleBits)
            let co2Rating = Day03.calculateCO2ScrubberRating(from: exampleBits)

            XCTAssertEqual(oxygenRating, 23)
            XCTAssertEqual(co2Rating, 10)
        }

        func test03_Part2_Solution() {
            let result = Day03.partTwo(input_03)
            XCTAssert(result > 0, "Expected life support rating to be non-zero")
            print("Life support rating: \(result)")
        }

        func test04_Part1_BingoCardParser() throws {
            var exampleCard = """
            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19
            """[...]

            let card: Day04.BingoCard = try XCTUnwrap(
                Day04.cardParser.parse(&exampleCard.utf8)
            )

            XCTAssertEqual(card.a.values.map(\.number), [22, 13, 17, 11,  0])
            XCTAssertEqual(card.b.values.map(\.number), [ 8,  2, 23,  4, 24])
            XCTAssertEqual(card.c.values.map(\.number), [21,  9, 14, 16,  7])
            XCTAssertEqual(card.d.values.map(\.number), [ 6, 10,  3, 18,  5])
            XCTAssertEqual(card.e.values.map(\.number), [ 1, 12, 20, 15, 19])

            var multipleCards = """
            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19

            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19
            """[...]

            let cards: [Day04.BingoCard] = try XCTUnwrap(
                Day04.cardsParser.parse(&multipleCards.utf8)
            )

            XCTAssertEqual(cards.count, 2)
        }

        func test04_Part1_DrawSequenceParser() throws {
            var exampleSequence = """
            1,2,3,4,5
            """[...]

            let sequence = try XCTUnwrap(Day04.drawParser.parse(&exampleSequence))

            XCTAssertEqual(sequence, [1, 2, 3, 4, 5])
        }

        func test04_Part1_InputParser() throws {
            let exampleInput = """
            1,2,3,4,5

            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19

            68 56 28 57 12
            78 66 20 85 51
            35 23  7 99 44
            86 37  8 45 49
            40 77 32  6 88
            """

            let gameInput = try XCTUnwrap(Day04.parseInput(exampleInput))

            XCTAssertEqual(gameInput.draw, [1, 2, 3, 4, 5])
            XCTAssertEqual(gameInput.cards.count, 2)
        }

        func test04_Part1_ExampleGame() throws {
            let exampleInput = """
            7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19

             3 15  0  2 22
             9 18 13 17  5
            19  8  7 25 23
            20 11 10 24  4
            14 21 16 12  6

            14 21 17 24  4
            10 16 15  9 19
            18  8 23 26 20
            22 11 13  6  5
             2  0 12  3  7
            """

            let winningScore = try XCTUnwrap(Day04.partOne(exampleInput))

            XCTAssertEqual(winningScore, 4512)
        }

        func test04_Part1_Solution() throws {
            let winningScore = try XCTUnwrap(Day04.partOne(input_04))
            XCTAssert(winningScore > 0, "Expected winning score to be non-zero")
            print("Day 04 (Part 1) answer: \(winningScore)")
        }

        func test04_Part2_ExampleGame() throws {
            let exampleInput = """
            7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

            22 13 17 11  0
             8  2 23  4 24
            21  9 14 16  7
             6 10  3 18  5
             1 12 20 15 19

             3 15  0  2 22
             9 18 13 17  5
            19  8  7 25 23
            20 11 10 24  4
            14 21 16 12  6

            14 21 17 24  4
            10 16 15  9 19
            18  8 23 26 20
            22 11 13  6  5
             2  0 12  3  7
            """

            let lastWinningScore = try XCTUnwrap(Day04.partTwo(exampleInput))

            XCTAssertEqual(lastWinningScore, 1924)
        }

        func test04_Part2_Solution() throws {
            let lastWinningScore = try XCTUnwrap(Day04.partTwo(input_04))
            XCTAssert(lastWinningScore > 0, "Expected winning score to be non-zero")
            print("Day 04 (Part 2) answer: \(lastWinningScore)")
        }
    }
