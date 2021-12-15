import XCTest
import CustomDump

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

    func test05_Part1_PointCalculations() {
        let lineA = Day05.Line(a: .init(x: 0, y: 0), b: .init(x: 4, y: 4))
        XCTAssertEqual(
            Day05.pointsOnLine(lineA, countDiagonals: true),
            [
                .init(x: 0, y: 0),
                .init(x: 1, y: 1),
                .init(x: 2, y: 2),
                .init(x: 3, y: 3),
                .init(x: 4, y: 4)
            ]
        )

        let lineB = Day05.Line(a: .init(x: 0, y: 0), b: .init(x: 0, y: 4))
        XCTAssertEqual(
            Day05.pointsOnLine(lineB, countDiagonals: false),
            [
                .init(x: 0, y: 0),
                .init(x: 0, y: 1),
                .init(x: 0, y: 2),
                .init(x: 0, y: 3),
                .init(x: 0, y: 4)
            ]
        )

        let lineC = Day05.Line(a: .init(x: 0, y: 0), b: .init(x: 4, y: 0))
        XCTAssertEqual(
            Day05.pointsOnLine(lineC, countDiagonals: false),
            [
                .init(x: 0, y: 0),
                .init(x: 1, y: 0),
                .init(x: 2, y: 0),
                .init(x: 3, y: 0),
                .init(x: 4, y: 0)
            ]
        )

        let lineD = Day05.Line(a: .init(x: 0, y: 4), b: .init(x: 0, y: 0))
        XCTAssertEqual(
            Day05.pointsOnLine(lineD, countDiagonals: false),
            [
                .init(x: 0, y: 4),
                .init(x: 0, y: 3),
                .init(x: 0, y: 2),
                .init(x: 0, y: 1),
                .init(x: 0, y: 0)
            ]
        )

        let lineE = Day05.Line(a: .init(x: 4, y: 0), b: .init(x: 0, y: 0))
        XCTAssertEqual(
            Day05.pointsOnLine(lineE, countDiagonals: false),
            [
                .init(x: 4, y: 0),
                .init(x: 3, y: 0),
                .init(x: 2, y: 0),
                .init(x: 1, y: 0),
                .init(x: 0, y: 0)
            ]
        )

        let lineF = Day05.Line(a: .init(x: 0, y: 0), b: .init(x: 4, y: 4))
        XCTAssertEqual(
            Day05.pointsOnLine(lineF, countDiagonals: false),
            []
        )

        let lineG = Day05.Line(a: .init(x: 1, y: 4), b: .init(x: 4, y: 1))
        XCTAssertEqual(
            Day05.pointsOnLine(lineG, countDiagonals: true),
            [
                .init(x: 1, y: 4),
                .init(x: 2, y: 3),
                .init(x: 3, y: 2),
                .init(x: 4, y: 1)
            ]
        )
    }

    func test05_Part1_Parsing() throws {
        var coordinateInput = "5,8"[...]
        let point = try XCTUnwrap(Day05.coordinateParser.parse(&coordinateInput))
        XCTAssertEqual(point, Day05.Point(x: 5, y: 8))

        var lineInput = "5,8 -> 7,9"[...]
        let line = try XCTUnwrap(Day05.lineParser.parse(&lineInput))
        XCTAssertEqual(line, Day05.Line(a: .init(x: 5, y: 8), b: .init(x: 7, y: 9)))
    }

    func test05_Part1_Example() {
        let exampleInput = """
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """

        let totalPoints = Day05.partOne(exampleInput)
        XCTAssertEqual(5, totalPoints)
    }

    func test05_Part1_Solution() {
        let totalPoints = Day05.partOne(input_05)
        XCTAssert(totalPoints > 0, "Expected non-zero points")
        print("Day 5 (Part 1) answer: \(totalPoints)")
    }

    func test05_Part2_Example() {
        let exampleInput = """
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """

        let totalPoints = Day05.partTwo(exampleInput)
        XCTAssertEqual(12, totalPoints)
    }

    func test05_Part2_Solution() {
        let totalPoints = Day05.partTwo(input_05)
        XCTAssert(totalPoints > 0, "Expected non-zero points")
        print("Day 5 (Part 2) answer: \(totalPoints)")
    }

    func test06_Part1_SingleFish() {
        var fish: [Day06.Lanternfish] = [3]

        fish = fish.flatMap(Day06.dayElapsed)
        XCTAssertEqual([2], fish)

        fish = fish.flatMap(Day06.dayElapsed)
        XCTAssertEqual([1], fish)

        fish = fish.flatMap(Day06.dayElapsed)
        XCTAssertEqual([0], fish)

        fish = fish.flatMap(Day06.dayElapsed)
        XCTAssertEqual([6, 8], fish)
    }

    func test06_Part1_Parsing() {
        let fish = Day06.parseInput("3,4,3,1,2")
        XCTAssertEqual(fish, [3, 4, 3, 1, 2])
    }

    func test06_Part1_Example() {
        let simulation1 = Day06.produceSimulation(numberOfDays: 18)
        let result1 = simulation1([3, 4, 3, 1, 2])
        XCTAssertEqual(result1.count, 26)

        let simulation2 = Day06.produceSimulation(numberOfDays: 80)
        let result2 = simulation2([3, 4, 3, 1, 2])
        XCTAssertEqual(result2.count, 5934)
    }

    func test06_Part1_Solution() {
        let totalFish = Day06.partOne(input_06)
        XCTAssert(totalFish > 0, "Expected non-zero fish")
        print("Day 6 (Part 1) answer: \(totalFish)")
    }

    func test06_Part2_SimulateDay() {
        var counts = Day06.counts(for: [3, 4, 3, 1, 2])

        Day06.simulateDay(counts: &counts)
        XCTAssertEqual(
            [0: 1, 1: 1, 2: 2, 3: 1, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0],
            counts // 2,3,2,0,1
        )

        Day06.simulateDay(counts: &counts)
        XCTAssertEqual(
            [0: 1, 1: 2, 2: 1, 3: 0, 4: 0, 5: 0, 6: 1, 7: 0, 8: 1],
            counts // 1,2,1,6,0,8
        )

        Day06.simulateDay(counts: &counts)
        XCTAssertEqual(
            [0: 2, 1: 1, 2: 0, 3: 0, 4: 0, 5: 1, 6: 1, 7: 1, 8: 1],
            counts // 0,1,0,5,6,7,8
        )
    }

    func test06_Part2_Example() {
        let simulation1 = Day06.produceOptimizedSimulation(numberOfDays: 18)
        let result1 = simulation1([3, 4, 3, 1, 2])
        XCTAssertEqual(result1, 26)

        let simulation2 = Day06.produceOptimizedSimulation(numberOfDays: 256)
        let result2 = simulation2([3, 4, 3, 1, 2])
        XCTAssertEqual(result2, 26984457539)
    }

    func test06_Part2_Solution() {
        let totalFish = Day06.partTwo(input_06)
        XCTAssert(totalFish > 0, "Expected non-zero fish")
        print("Day 6 (Part 2) answer: \(totalFish)")
    }

    func test07_Part1_Example() {
        let totalFuel = Day07.findOptimumFuel(input: [16,1,2,0,4,2,7,1,2,14], calculateFuel: Day07.calculateFuel)

        XCTAssertEqual(37, totalFuel)
    }

    func test07_Part1_Solution() throws {
        let totalFuel = try XCTUnwrap(Day07.partOne(input_07))
        XCTAssert(totalFuel > 0, "Expected non-zero fuel")
        print("Day 7 (Part 1) answer: \(totalFuel)")
    }

    func test07_Part2_Example() {
        let totalFuel = Day07.findOptimumFuel(input: [16,1,2,0,4,2,7,1,2,14], calculateFuel: Day07.calculateFuel2)

        XCTAssertEqual(168, totalFuel)
    }

    func test07_Part2_Solution() throws {
        let totalFuel = try XCTUnwrap(Day07.partTwo(input_07))
        XCTAssert(totalFuel > 0, "Expected non-zero fuel")
        print("Day 7 (Part 2) answer: \(totalFuel)")
    }

    func test08_Part1_Parsing() {
        let input = """
        acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        """

        let result = Day08.parseInput(input)
        XCTAssertEqual(2, result.count)

        let display = result[0].display
        XCTAssertEqual(display.one.signals, "cdfeb")
        XCTAssertEqual(display.two.signals, "fcadb")
        XCTAssertEqual(display.three.signals, "cdfeb")
        XCTAssertEqual(display.four.signals, "cdbaf")

        let signals = result[0].signals.map(\.signals)
        XCTAssertEqual(10, signals.count)
        XCTAssert(signals.contains("acedgfb"))
        XCTAssert(signals.contains("cdfbe"))
        XCTAssert(signals.contains("gcdfa"))
        XCTAssert(signals.contains("fbcad"))
        XCTAssert(signals.contains("dab"))
        XCTAssert(signals.contains("cefabd"))
        XCTAssert(signals.contains("cdfgeb"))
        XCTAssert(signals.contains("eafb"))
        XCTAssert(signals.contains("cagedb"))
        XCTAssert(signals.contains("ab"))
    }

    func test08_Part1_Example() {
        let exampleInput = """
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
        """

        let uniqueSignalCount = Day08.partOne(exampleInput)

        XCTAssertEqual(26, uniqueSignalCount)
    }

    func test08_Part1_Solution() throws {
        let uniqueSignalCount = try XCTUnwrap(Day08.partOne(input_08))
        XCTAssert(uniqueSignalCount > 0, "Expected non-zero signal count")
        print("Day 8 (Part 1) answer: \(uniqueSignalCount)")
    }

    func test08_Part2_Example() {
        let exampleInput = """
        acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
        """
        let input = Day08.parseInput(exampleInput)
        let row = input[0]
        let mapping = Day08.deduceSignalMapping(from: row.signals)

        XCTAssertEqual(0, mapping["abcdeg"])
        XCTAssertEqual(1, mapping["ab"])
        XCTAssertEqual(2, mapping["acdfg"])
        XCTAssertEqual(3, mapping["abcdf"])
        XCTAssertEqual(4, mapping["abef"])
        XCTAssertEqual(5, mapping["bcdef"])
        XCTAssertEqual(6, mapping["bcdefg"])
        XCTAssertEqual(7, mapping["abd"])
        XCTAssertEqual(8, mapping["abcdefg"])
        XCTAssertEqual(9, mapping["abcdef"])

        XCTAssertEqual(5353, Day08.decodeDisplay(row.display, mapping: mapping))
    }

    func test08_Part2_Solution() throws {
        let displayTotal = try XCTUnwrap(Day08.partTwo(input_08))
        XCTAssert(displayTotal > 0, "Expected non-zero display total")
        print("Day 8 (Part 2) answer: \(displayTotal)")
    }

    func test09_Part1_Example() {
        let exampleInput = """
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """

        let input = Day09.parseInput(exampleInput)

        XCTAssertEqual(5, input.count)
        XCTAssertEqual(10, input[0].count)

        let lowPoints = Day09.findLowPointValues(in: input)

        XCTAssertEqual([1, 0, 5, 5], lowPoints)
        XCTAssertEqual(15, Day09.calculateRiskScore(lowPoints: lowPoints))
    }

    func test09_Part1_Solution() throws {
        let riskScore = try XCTUnwrap(Day09.partOne(input_09))
        XCTAssert(riskScore > 0, "Expected non-zero risk score")
        print("Day 9 (Part 1) answer: \(riskScore)")
    }

    func test09_Part2_Example() throws {
        let exampleInput = """
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """

        let result = Day09.partTwo(exampleInput)

        XCTAssertEqual(1134, result)
    }

    func test09_Part2_Solution() throws {
        let basinScore = try XCTUnwrap(Day09.partTwo(input_09))
        XCTAssert(basinScore > 0, "Expected non-zero basin score")
        print("Day 9 (Part 2) answer: \(basinScore)")
    }
    
    func test10_Part1_ScanChunks() {
        XCTAssertNil(Day10.scanChunks("[]"))
        XCTAssertNil(Day10.scanChunks("[<>{<>}]"))
        XCTAssertNil(Day10.scanChunks(">>>123[<>{<>}]"))
        XCTAssertNil(Day10.scanChunks("[(<>){<>}]"))
        
        XCTAssertEqual(
            Day10.scanChunks("[(<>}]"),
            .corrupted(expected: ")", found: "}")
        )
        
        XCTAssertEqual(
            Day10.scanChunks("[(<>)"),
            .incomplete(stack: ["["])
        )
    }
    
    func test10_Part2_ExampleCorruptedChunks() {
        XCTAssertEqual(
            Day10.scanChunks("{([(<{}[<>[]}>{[]{[(<()>"),
            .corrupted(expected: "]", found: "}")
        )
        XCTAssertEqual(
            Day10.scanChunks("[[<[([]))<([[{}[[()]]]"),
            .corrupted(expected: "]", found: ")")
        )
        XCTAssertEqual(
            Day10.scanChunks("[{[{({}]{}}([{[{{{}}([]"),
            .corrupted(expected: ")", found: "]")
        )
        XCTAssertEqual(
            Day10.scanChunks("[<(<(<(<{}))><([]([]()"),
            .corrupted(expected: ">", found: ")")
        )
        XCTAssertEqual(
            Day10.scanChunks("<{([([[(<>()){}]>(<<{{"),
            .corrupted(expected: "]", found: ">")
        )
    }
    
    func testDay10_Part1_Example() {
        let input = """
        [({(<(())[]>[[{[]{<()<>>
        [(()[<>])]({[<{<<[]>>(
        {([(<{}[<>[]}>{[]{[(<()>
        (((({<>}<{<{<>}{[]{[]{}
        [[<[([]))<([[{}[[()]]]
        [{[{({}]{}}([{[{{{}}([]
        {<[[]]>}<{[{[{[]{()[[[]
        [<(<(<(<{}))><([]([]()
        <{([([[(<>()){}]>(<<{{
        <{([{{}}[<[[[<>{}]]]>[]]
        """
        
        let score = Day10.partOne(input)
        
        XCTAssertEqual(score, 26397)
    }
    
    func test10_Part1_Solution() throws {
        let score = try XCTUnwrap(Day10.partOne(input_10))
        XCTAssert(score > 0, "Expected non-zero score")
        print("Day 10 (Part 1) answer: \(score)")
    }
    
    func test10_Part2_Autocompletion() {
        let incomplete = "[({(<(())[]>[[{[]{<()<>>"
        let error = Day10.scanChunks(incomplete)
        
        XCTAssertEqual(error, .incomplete(stack: ["[", "(", "{", "(", "[", "[", "{", "{"]))
        XCTAssertEqual(
            "}}]])})]",
            String(Day10.findCompletionCharacters(stack: ["[", "(", "{", "(", "[", "[", "{", "{"]))
        )
    }
    
    func test10_Part2_Scoring() {
        let characters: [Character] = ["}", "}", "]", "]", ")", "}", ")", "]"]
        let score = Day10.autocompleteScore(characters: characters)
        XCTAssertEqual(288957, score)
        
        let scores = [3, 1, 2, 5, 4]
        XCTAssertEqual(3, Day10.findWinningScore(scores))
    }
    
    func test10_Part2_Example() {
        let input = """
        [({(<(())[]>[[{[]{<()<>>
        [(()[<>])]({[<{<<[]>>(
        {([(<{}[<>[]}>{[]{[(<()>
        (((({<>}<{<{<>}{[]{[]{}
        [[<[([]))<([[{}[[()]]]
        [{[{({}]{}}([{[{{{}}([]
        {<[[]]>}<{[{[{[]{()[[[]
        [<(<(<(<{}))><([]([]()
        <{([([[(<>()){}]>(<<{{
        <{([{{}}[<[[[<>{}]]]>[]]
        """
        
        let score = Day10.partTwo(input)
        
        XCTAssertEqual(score, 288957)
    }
    
    func test10_Part2_Solution() throws {
        let score = try XCTUnwrap(Day10.partTwo(input_10))
        XCTAssert(score > 0, "Expected non-zero score")
        print("Day 10 (Part 2) answer: \(score)")
    }
    
    func test11_Part1_GridCalculations() {
        let exampleGrid = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]
        
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(0, 0), in: exampleGrid),
            .init([
                .init(0, 1),
                .init(1, 0),
                .init(1, 1)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(0, 1), in: exampleGrid),
            .init([
                .init(0, 0),
                .init(0, 2),
                .init(1, 0),
                .init(1, 1),
                .init(1, 2)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(0, 2), in: exampleGrid),
            .init([
                .init(0, 1),
                .init(1, 1),
                .init(1, 2)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(1, 0), in: exampleGrid),
            .init([
                .init(0, 0),
                .init(0, 1),
                .init(1, 1),
                .init(2, 0),
                .init(2, 1)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(1, 1), in: exampleGrid),
            .init([
                .init(0, 0),
                .init(0, 1),
                .init(0, 2),
                .init(1, 0),
                .init(1, 2),
                .init(2, 0),
                .init(2, 1),
                .init(2, 2)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(1, 2), in: exampleGrid),
            .init([
                .init(0, 1),
                .init(0, 2),
                .init(1, 1),
                .init(2, 1),
                .init(2, 2)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(2, 0), in: exampleGrid),
            .init([
                .init(1, 0),
                .init(1, 1),
                .init(2, 1)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(2, 1), in: exampleGrid),
            .init([
                .init(1, 0),
                .init(1, 1),
                .init(1, 2),
                .init(2, 0),
                .init(2, 2)
            ])
        )
        XCTAssertNoDifference(
            Day11.findSurroundingPoints(of: .init(2, 2), in: exampleGrid),
            .init([
                .init(1, 1),
                .init(1, 2),
                .init(2, 1)
            ])
        )
    }
    
    func testDay11_Part1_PerformStepNoFlashes() {
        let startingGrid = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ]
        
        var result = Day11.performStep(startingGrid)
        
        XCTAssertNoDifference(
            result.grid,
            [
                [1, 1, 1],
                [1, 1, 1],
                [1, 1, 1]
            ]
        )
        XCTAssertEqual(0, result.flashes)
        
        result = Day11.performStep(result.grid)
        
        XCTAssertNoDifference(
            result.grid,
            [
                [2, 2, 2],
                [2, 2, 2],
                [2, 2, 2]
            ]
        )
        XCTAssertEqual(0, result.flashes)
    }
    
    func testDay11_Part1_PerformStepFlashes() {
        let startingGrid = [
            [0, 0, 0],
            [0, 8, 0],
            [0, 0, 0]
        ]
        
        var result = Day11.performStep(startingGrid)
        
        XCTAssertNoDifference(
            result.grid,
            [
                [1, 1, 1],
                [1, 9, 1],
                [1, 1, 1]
            ]
        )
        XCTAssertEqual(0, result.flashes)
        
        result = Day11.performStep(result.grid)

        XCTAssertNoDifference(
            result.grid,
            [
                [3, 3, 3],
                [3, 0, 3],
                [3, 3, 3]
            ]
        )
        XCTAssertEqual(1, result.flashes)
    }
    
    func testDay11_Part1_Example() throws {
        let exampleInput = """
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """
        
        let startGrid = try XCTUnwrap(Day11.parseInput(exampleInput))
        
        var output = Day11.performStep(startGrid)
        XCTAssertEqual(0, output.flashes)
        
        output = Day11.performStep(output.grid)
        XCTAssertEqual(35, output.flashes)
        
        let expectedGrid = try XCTUnwrap(Day11.parseInput("""
        8807476555
        5089087054
        8597889608
        8485769600
        8700908800
        6600088989
        6800005943
        0000007456
        9000000876
        8700006848
        """))
        XCTAssertNoDifference(output.grid, expectedGrid)
        
        let result = Day11.partOne(exampleInput)

        XCTAssertEqual(204, result.flashes)
    }
    
    func test11_Part1_Solution() throws {
        let output = try XCTUnwrap(Day11.partOne(input_11))
        XCTAssert(output.flashes > 0, "Expected non-zero flashes")
        print("Day 11 (Part 1) answer: \(output.flashes)")
    }
    
    func test11_Part2_Solution() throws {
        let step = try XCTUnwrap(Day11.partTwo(input_11))
        XCTAssert(step > 0, "Expected non-zero step")
        print("Day 11 (Part 2) answer: \(step)")
    }
    
    func test12_Part1_SimpleRoute() {
        let paths = [
            ("start", "B"),
            ("start", "C"),
            ("B", "end"),
            ("C", "end")
        ]
        
        let expectedRoutes = Set([
            ["start", "B", "end"],
            ["start", "C", "end"]
        ])
        
        let result = Day12.calculateRoutes(
            map: Day12.mapPaths(paths)
        )
        
        XCTAssertNoDifference(expectedRoutes, result)
    }
    
    func test12_Part1_RouteWithDeadEnds() {
        let paths = [
            ("start", "B"),
            ("start", "C"),
            ("start", "d"),
            ("B", "end"),
            ("B", "e"),
            ("C", "end")
        ]
        
        let expectedRoutes = Set([
            ["start", "B", "end"],
            ["start", "C", "end"],
            ["start", "B", "e", "B", "end"]
        ])
        
        let result = Day12.calculateRoutes(
            map: Day12.mapPaths(paths)
        )
        
        XCTAssertNoDifference(expectedRoutes, result)
    }
    
    func test12_Part1_RouteWithSmallCaves() {
        let paths = [
            ("start", "A"),
            ("start", "b"),
            ("A", "c"),
            ("A", "b"),
            ("b", "d"),
            ("A", "end"),
            ("b", "end")
        ]
        
        let expectedRoutes = Set([
            ["start", "A", "b", "A", "c", "A", "end"],
            ["start", "A", "b", "A", "end"],
            ["start", "A", "b", "end"],
            ["start", "A", "c", "A", "b", "A", "end"],
            ["start", "A", "c", "A", "b", "end"],
            ["start", "A", "c", "A", "end"],
            ["start", "A", "end"],
            ["start", "b", "A", "c", "A", "end"],
            ["start", "b", "A", "end"],
            ["start", "b", "end"]
        ])
        
        let result = Day12.calculateRoutes(
            map: Day12.mapPaths(paths)
        )
        
        XCTAssertNoDifference(expectedRoutes, result)
    }
    
    func test12_Part1_Examples() {
        let exampleOne = """
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
        """
        
        XCTAssertEqual(19, Day12.partOne(exampleOne))
        
        let exampleTwo = """
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
        """
        
        XCTAssertEqual(226, Day12.partOne(exampleTwo))
    }
    
    func test12_Part1_Solution() throws {
        let count = try XCTUnwrap(Day12.partOne(input_12))
        XCTAssert(count > 0, "Expected non-zero count")
        print("Day 12 (Part 1) answer: \(count)")
    }
    
    func test12_Part2_Example() {
        let exampleOne = """
        start-A
        start-b
        A-c
        A-b
        b-d
        A-end
        b-end
        """
        
        XCTAssertEqual(36, Day12.partTwo(exampleOne))
        
        let exampleTwo = """
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
        """
        
        XCTAssertEqual(103, Day12.partTwo(exampleTwo))
        
        let exampleThree = """
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
        """
        
        XCTAssertEqual(3509, Day12.partTwo(exampleThree))
    }
    
    func test12_Part2_Solution() throws {
        let count = try XCTUnwrap(Day12.partTwo(input_12))
        XCTAssert(count > 0, "Expected non-zero count")
        print("Day 12 (Part 2) answer: \(count)")
    }

    func test13_Part1_FoldGridY() {
        let points: Day13.MarkedGrid = .init([
            .init(x: 1, y: 0),
            .init(x: 0, y: 2),
            .init(x: 2, y: 2)
        ])

        let foldedPoints = Day13.foldGrid(points, at: ("y", 1))

        XCTAssertNoDifference(
            foldedPoints,
            .init([
                .init(x: 1, y: 0),
                .init(x: 0, y: 0),
                .init(x: 2, y: 0)
            ])
        )
    }

    func test13_Part1_FoldGridX() {
        let points: Day13.MarkedGrid = .init([
            .init(x: 2, y: 0),
            .init(x: 0, y: 2),
            .init(x: 2, y: 2)
        ])

        let foldedGrid = Day13.foldGrid(points, at: ("x", 1))

        XCTAssertNoDifference(
            foldedGrid,
            .init([
                .init(x: 0, y: 0),
                .init(x: 0, y: 2)
            ])
        )
    }

    func test13_Part1_Parsing() throws {
        let exampleInput = """
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
        """

        let result = try XCTUnwrap(Day13.parseInput(exampleInput))

        XCTAssertEqual(result.marks.count, 18)
        XCTAssert(result.marks.contains(where: { $0.x == 6 && $0.y == 10}))
        XCTAssertEqual(result.folds.count, 2)
        XCTAssertEqual(result.folds[0].axis, "y")
        XCTAssertEqual(result.folds[0].value, 7)
    }

    func test13_Part1_Example() {
        let exampleInput = """
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
        """

        let marks = Day13.partOne(exampleInput)

        XCTAssertEqual(17, marks)
    }

    func test13_Part1_Solution() throws {
        let count = try XCTUnwrap(Day13.partOne(input_13))
        XCTAssert(count > 0, "Expected non-zero count")
        print("Day 13 (Part 1) answer: \(count)")
    }

    func test13_Part2_Solution() throws {
        Day13.partTwo(input_13)

        // Outputs:
        //    ####.#..#...##.#..#..##..####.#..#.###.
        //
        //    ...#.#..#....#.#..#.#..#.#....#..#.#..#
        //
        //    ..#..#..#....#.#..#.#..#.###..####.#..#
        //
        //    .#...#..#....#.#..#.####.#....#..#.###.
        //
        //    #....#..#.#..#.#..#.#..#.#....#..#.#...
        //
        //    ####..##...##...##..#..#.#....#..#.#...
    }
    
    func test14_Part1_RuleApplication() {
        let rule: Day14.InsertionRule = .init(match: .init("A", "B"), insertion: "C")
        
        XCTAssertNoDifference(
            Day14.applyRule(rule, to: .init("C", "D")),
            [.init("C", "D")]
        )
        
        XCTAssertNoDifference(
            Day14.applyRule(rule, to: .init("A", "B")),
            [.init("A", "C"), .init("C", "B")]
        )
    }
    
    func test14_Part1_ExtractPairs() {
        XCTAssertNoDifference(
            Day14.extractPairs(from: "ABCDE"),
            [
                .init("A", "B"),
                .init("B", "C"),
                .init("C", "D"),
                .init("D", "E")
            ]
        )
    }
    
    func test14_Part1_CombinePairs() {
        XCTAssertNoDifference(
            Day14.combinePairs([
                .init("A", "B"),
                .init("B", "C"),
                .init("C", "D"),
                .init("D", "E")
            ]),
            "ABCDE"
        )
    }
    
    func test14_Part1_ApplyMultipleRules() {
        let rules: [Day14.InsertionRule] = [
            .init(match: .init("A", "B"), insertion: "C"),
            .init(match: .init("D", "E"), insertion: "F")
        ]
        
        XCTAssertNoDifference(
            Day14.applyRules(rules, to: "ABCDE"),
            "ACBCDFE"
        )
    }
    
    func test14_Part1_Parsing() throws {
        let inputString = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """
        
        let input = try XCTUnwrap(Day14.parseInput(inputString))
        
        XCTAssertEqual(input.template, "NNCB")
        XCTAssertEqual(input.rules.count, 16)
        XCTAssertEqual(input.rules[0].match, .init("C", "H"))
        XCTAssertEqual(input.rules[0].insertion, "B")
    }
    
    func test14_Part1_CountElements() {
        XCTAssertNoDifference(
            Day14.countElements(in: "ABCDCDEA"),
            [
                "A": 2,
                "B": 1,
                "C": 2,
                "D": 2,
                "E": 1
            ]
        )
        XCTAssertNoDifference(
            Day14.countRange(in: Day14.countElements(in: "AAABBC")),
            .init(3, 1)
        )
    }
    
    func test14_Part1_ExampleInput() throws {
        let inputString = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """
        
        let input = try XCTUnwrap(Day14.parseInput(inputString))
        
        var polymer = Day14.performPairInsertion(input: input, iterations: 1)
        
        XCTAssertEqual(polymer, "NCNBCHB")
        
        polymer = Day14.performPairInsertion(
            input: (template: polymer, rules: input.rules),
            iterations: 1
        )
        
        XCTAssertEqual(polymer, "NBCCNBBBCBHCB")
        
        polymer = Day14.performPairInsertion(
            input: (template: polymer, rules: input.rules),
            iterations: 1
        )
        
        XCTAssertEqual(polymer, "NBBBCNCCNBBNBNBBCHBHHBCHB")
        
        let partOneResult = Day14.partOne(inputString)
        
        XCTAssertEqual(partOneResult, 1588)
    }
    
    func test14_Part1_Solution() throws {
        let result = try XCTUnwrap(Day14.partOne(input_14))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 14 (Part 1) answer: \(result)")
    }
    
    func test14_Part2_AlternativeImplementation() throws {
        let result1 = Day14.performOptimisedPairInsertion(
            input: (template: "AAABBC", rules: []),
            iterations: 1
        )
        
        XCTAssertNoDifference(
            result1,
            [
                "A": 3,
                "B": 2,
                "C": 1
            ]
        )
        
        let result2 = Day14.performOptimisedPairInsertion(
            input: (
                template: "AAABBC",
                rules: [
                    .init(match: .init("A", "A"), insertion: "E"),
                    .init(match: .init("B", "B"), insertion: "F")
                ]
            ),
            iterations: 1
        )
        
        // AEAEABFBC

        XCTAssertNoDifference(
            result2,
            [
                "A": 3,
                "B": 2,
                "C": 1,
                "E": 2,
                "F": 1
            ]
        )
    }
    
    func test14_Part2_Example() {
        let inputString = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """
        
        let result = Day14.partTwo(inputString)
        
        XCTAssertEqual(result, 2188189693529)
    }
    
    func test14_Part2_Solution() throws {
        let result = try XCTUnwrap(Day14.partTwo(input_14))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 14 (Part 2) answer: \(result)")
    }
    
    func test15_Part1_GridHelpers() {
        let expectedPoints: Set<Day15.Point> = [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 2, y: 0),
            .init(x: 0, y: 1),
            .init(x: 1, y: 1),
            .init(x: 2, y: 1),
            .init(x: 0, y: 2),
            .init(x: 1, y: 2),
            .init(x: 2, y: 2)
        ]
        
        XCTAssertNoDifference(
            Day15.pointsInGrid(width: 3, height: 3),
            expectedPoints
        )
        
        let grid = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
        ]
        
        XCTAssertNoDifference(
            Day15.pointsInGrid(grid),
            expectedPoints
        )
        
        XCTAssertEqual(5, Day15.lookupValue(in: grid, at: .init(x: 2, y: 1)))
    }
    
    func test15_Part1_ShortestPath() {
        let inputGrid = """
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
        """
        
        let grid = Day15.parseInput(inputGrid)
        
        XCTAssertEqual(10, grid.count)
        XCTAssertEqual(40, Day15.findShortestDistance(in: grid))
    }
    
    func test15_Part1_Solution() throws {
        let result = try XCTUnwrap(Day15.partOne(input_15))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 15 (Part 1) answer: \(result)")
    }
    
    func test15_Part2_ExtrapolateFullGrid() {
        let inputGrid = """
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
        """
        
        let tile = Day15.parseInput(inputGrid)
        let fullGrid = Day15.extrapolateFullGrid(from: tile)
        
        XCTAssertEqual(fullGrid.count, 50)
        XCTAssertEqual(fullGrid[0].count, 50)
        
        XCTAssertEqual(1, fullGrid[0][0])
        XCTAssertEqual(2, fullGrid[0][10])
        XCTAssertEqual(3, fullGrid[0][20])
        XCTAssertEqual(4, fullGrid[0][30])
        XCTAssertEqual(5, fullGrid[0][40])
        
        XCTAssertEqual(6, fullGrid[0][2])
        XCTAssertEqual(7, fullGrid[0][12])
        XCTAssertEqual(8, fullGrid[0][22])
        XCTAssertEqual(9, fullGrid[0][32])
        XCTAssertEqual(1, fullGrid[0][42])
        
        XCTAssertEqual(7, fullGrid[4][0])
        XCTAssertEqual(8, fullGrid[14][0])
        XCTAssertEqual(9, fullGrid[24][0])
        XCTAssertEqual(1, fullGrid[34][0])
        XCTAssertEqual(2, fullGrid[44][0])
    }
    
    func test15_Part2_ShortestPath() {
        let inputGrid = """
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
        """
        
        let tile = Day15.parseInput(inputGrid)
        let grid = Day15.extrapolateFullGrid(from: tile)
        
        XCTAssertEqual(315, Day15.findShortestDistance(in: grid))
    }
    
    func test15_Part2_Solution() throws {
        let result = try XCTUnwrap(Day15.partTwo(input_15))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 15 (Part 2) answer: \(result)")
    }
}
