import XCTest
import CustomDump
import Parsing
import simd

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
    
    func test16_Part1_HexToBin() {
        XCTAssertEqual("101010111100", Day16.packetBytes.parse("ABC"))

        // Make sure we can also convert long strings with zero padded values
        XCTAssertEqual(
            "100010100000000001001010100000000001101010000000000000101111010001111000",
            Day16.packetBytes.parse("8A004A801A8002F478")
        )
    }
    
    func test16_Part1_ParsingLiteralPackets() throws {
        let example = "110100101111111000101000"
        
        var input = example[...]
        XCTAssertEqual(6, Day16.packetVersion.parse(&input))
        XCTAssertEqual(4, Day16.packetTypeID.parse(&input))
        XCTAssertEqual(["0", "1", "1", "1"], Day16.insideGroup.parse(&input))
        XCTAssertEqual(["1", "1", "1", "0"], Day16.insideGroup.parse(&input))
        XCTAssertEqual(["0", "1", "0", "1"], Day16.finalGroup.parse(&input))
        XCTAssertEqual("000", input, "Should be left with zero padding")
        XCTAssertEqual(["0", "0", "0"], Day16.zeroPadding.parse(&input))
        
        input = example[...]
        let packet = try XCTUnwrap(Day16.packet.parse(&input))
        XCTAssertEqual(6, packet.header.version)
        XCTAssertEqual(4, packet.header.typeID)
        XCTAssertEqual(.literal(2021), packet.payload)
    }
    
    func test16_Part1_MultipleLiteralPacketsWithZeroPadding() throws {
        // This represents an 11 and 16  bit packet:
        // 1. 110-100-01010
        // 2. 0101001000100100
        let example = "110100010100101001000100100"
        
        let packets = try XCTUnwrap(Many(Day16.packet).parse(example))
    
        XCTAssertEqual(2, packets.count)
        
        XCTAssertNoDifference(
            [
                Day16.Packet(header: (6, 4), payload: .literal(10)),
                Day16.Packet(header: (2, 4), payload: .literal(20)),
            ],
            packets
        )
    }
    
    func test16_Part2_ParsingOperatorPackets() throws {
        let example1 = "00111000000000000110111101000101001010010001001000000000"
        
        var input = example1[...]
        let header1 = try XCTUnwrap(Day16.packetHeader.parse(&input))
        XCTAssertEqual(1, header1.version)
        XCTAssertEqual(6, header1.typeID)
        
        let packet1 = try XCTUnwrap(Day16.operatorPacket(header: header1).parse(&input))

        XCTAssertNoDifference(
            .lessThan(
                Day16.Packet(header: (6, 4), payload: .literal(10)),
                Day16.Packet(header: (2, 4), payload: .literal(20))
            ),
            packet1.payload
        )
        
        let example2 = "11101110000000001101010000001100100000100011000001100000"
        input = example2[...]
        let header2 = try XCTUnwrap(Day16.packetHeader.parse(&input))
        XCTAssertEqual(7, header2.version)
        XCTAssertEqual(3, header2.typeID)
        
        let packet2 = try XCTUnwrap(Day16.operatorPacket(header: header2).parse(&input))
        XCTAssertEqual(
            .max([
                Day16.Packet(header: (2, 4), payload: .literal(1)),
                Day16.Packet(header: (4, 4), payload: .literal(2)),
                Day16.Packet(header: (1, 4), payload: .literal(3))
            ]),
            packet2.payload
        )
    }
    
    func test16_SumPacketVersions() {
        let packet = Day16.Packet(
            header: (version: 1, typeID: 1),
            payload: .sum([
                .init(
                    header: (version: 3, typeID: 4),
                    payload: .literal(1)
                ),
                .init(
                    header: (version: 5, typeID: 1),
                    payload: .product([
                        .init(
                            header: (version: 2, typeID: 4),
                            payload: .literal(2)
                        ),
                        .init(
                            header: (version: 8, typeID: 4),
                            payload: .literal(3)
                        )
                    ])
                )
            ])
        )
        
        XCTAssertEqual(19, Day16.sumPacketVersions(packet: packet))
    }
    
    func testDay16_Part1_Examples() {
        XCTAssertEqual(16, Day16.partOne("8A004A801A8002F478"))
        XCTAssertEqual(12, Day16.partOne("620080001611562C8802118E34"))
        XCTAssertEqual(23, Day16.partOne("C0015000016115A2E0802F182340"))
        XCTAssertEqual(31, Day16.partOne("A0016C880162017C3686B18A3D4780"))
    }
    
    func test16_Part1_Solution() throws {
        let result = try XCTUnwrap(Day16.partOne(input_16))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 16 (Part 1) answer: \(result)")
    }
    
    func test16_Part2_PacketEvaluation() {
        XCTAssertEqual(12,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 0),
                    payload: .sum([
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2)),
                        .init(header: (1, 4), payload: .literal(6))
                    ])
                ))
        )
        XCTAssertEqual(48,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 1),
                    payload: .product([
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2)),
                        .init(header: (1, 4), payload: .literal(6))
                    ])
                ))
        )
        XCTAssertEqual(2,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 2),
                    payload: .min([
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2)),
                        .init(header: (1, 4), payload: .literal(6))
                    ])
                ))
        )
        XCTAssertEqual(6,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 3),
                    payload: .max([
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2)),
                        .init(header: (1, 4), payload: .literal(6))
                    ])
                ))
        )
        XCTAssertEqual(1,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 5),
                    payload: .greaterThan(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2))
                    )
                ))
        )
        XCTAssertEqual(0,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 5),
                    payload: .greaterThan(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(8))
                    )
                ))
        )
        XCTAssertEqual(0,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 6),
                    payload: .lessThan(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2))
                    )
                ))
        )
        XCTAssertEqual(1,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 6),
                    payload: .lessThan(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(8))
                    )
                ))
        )
        XCTAssertEqual(0,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 7),
                    payload: .equal(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(2))
                    )
                ))
        )
        XCTAssertEqual(1,
            Day16.evaluatePacket(
                .init(
                    header: (version: 1, typeID: 7),
                    payload: .equal(
                        .init(header: (1, 4), payload: .literal(4)),
                        .init(header: (1, 4), payload: .literal(4))
                    )
                ))
        )
    }
    
    func test16_Part2_Examples() {
        XCTAssertEqual(3, Day16.partTwo("C200B40A82"))
        XCTAssertEqual(54, Day16.partTwo("04005AC33890"))
        XCTAssertEqual(7, Day16.partTwo("880086C3E88112"))
        XCTAssertEqual(9, Day16.partTwo("CE00C43D881120"))
        XCTAssertEqual(1, Day16.partTwo("D8005AC2A8F0"))
        XCTAssertEqual(0, Day16.partTwo("F600BC2D8F"))
        XCTAssertEqual(0, Day16.partTwo("9C005AC2F8F0"))
        XCTAssertEqual(1, Day16.partTwo("9C0141080250320F1802104A08"))
    }
    
    func test16_Part2_Solution() throws {
        let result = try XCTUnwrap(Day16.partTwo(input_16))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 16 (Part 2) answer: \(result)")
    }
    
    func test17_Part1_Movement() {
        let start = Day17.Position(x: 0, y: 0)
        let velocity = Day17.Velocity(x: 2, y: 10)
        
        var (newPosition, newVelocity) = Day17.performMovementStep(
            from: start,
            velocity: velocity
        )
        
        XCTAssertEqual(newPosition.x, 2)
        XCTAssertEqual(newPosition.y, 10)
        XCTAssertEqual(newVelocity.x, 1)
        XCTAssertEqual(newVelocity.y, 9)
        
        (newPosition, newVelocity) = Day17.performMovementStep(
            from: newPosition,
            velocity: newVelocity
        )
        
        XCTAssertEqual(newPosition.x, 3)
        XCTAssertEqual(newPosition.y, 19)
        XCTAssertEqual(newVelocity.x, 0)
        XCTAssertEqual(newVelocity.y, 8)
        
        (newPosition, newVelocity) = Day17.performMovementStep(
            from: newPosition,
            velocity: newVelocity
        )
        
        XCTAssertEqual(newPosition.x, 3)
        XCTAssertEqual(newPosition.y, 27)
        XCTAssertEqual(newVelocity.x, 0)
        XCTAssertEqual(newVelocity.y, 7)
        
        (newPosition, newVelocity) = Day17.performMovementStep(
            from: newPosition,
            velocity: (x: -2, y: 0)
        )
        
        XCTAssertEqual(newPosition.x, 1)
        XCTAssertEqual(newPosition.y, 27)
        XCTAssertEqual(newVelocity.x, -1)
        XCTAssertEqual(newVelocity.y, -1)
        
        (newPosition, newVelocity) = Day17.performMovementStep(
            from: newPosition,
            velocity: newVelocity
        )
        
        XCTAssertEqual(newPosition.x, 0)
        XCTAssertEqual(newPosition.y, 26)
        XCTAssertEqual(newVelocity.x, 0)
        XCTAssertEqual(newVelocity.y, -2)
    }
    
    func test17_Part1_Parsing() {
        let inputString = "target area: x=20..30, y=-10..-5"
        let targetArea = Day17.parseInput(inputString)
        XCTAssertEqual(targetArea.x, 20 ... 30)
        XCTAssertEqual(targetArea.y, -10 ... -5)
    }
    
    func test17_Part1_TargetAreaCheck() {
        XCTAssert(
            Day17.isWithinTargetArea(
                position: (x: 10, y: 10),
                targetArea: (x: (10...13), y: (8...13))
            )
        )
        XCTAssert(
            Day17.isWithinTargetArea(
                position: (x: 0, y: 2),
                targetArea: (x: (-2...2), y: (0...2))
            )
        )
        XCTAssertFalse(
            Day17.isWithinTargetArea(
                position: (x: 0, y: 2),
                targetArea: (x: (-5 ... -1), y: (0...3))
            )
        )
        XCTAssertFalse(
            Day17.isWithinTargetArea(
                position: (x: -3, y: 5),
                targetArea: (x: (-5 ... -1), y: (0...3))
            )
        )
    }
    
    func testDay17_Part1_BoundsCheck() {
        // Check positions above or to the left of the target area
        XCTAssertFalse(
            Day17.hasMissed(
                position: (x: 3, y: 0),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        XCTAssertFalse(
            Day17.hasMissed(
                position: (x: 6, y: 0),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        XCTAssertFalse(
            Day17.hasMissed(
                position: (x: 0, y: -8),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        // Check positions below and to the left (fallen short)
        XCTAssert(
            Day17.hasMissed(
                position: (x: 0, y: -11),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        // Check positions below but within the x (passed through)
        XCTAssert(
            Day17.hasMissed(
                position: (x: 8, y: -11),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        // Check positions that have exceeded the target x (overshot)
        XCTAssert(
            Day17.hasMissed(
                position: (x: 12, y: -7),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
        // Check on target position
        XCTAssertFalse(
            Day17.hasMissed(
                position: (x: 8, y: -7),
                targetArea: (x: 5...10, y: -10 ... -5)
            )
        )
    }
    
    func testDay17_Part1_VelocityCalculationExamples() {
        let targetArea = Day17.TargetArea(x: 20...30, y: -10 ... -5)

        var (onTarget, positions, _) = Day17.performMovement(
            towards: targetArea,
            initialVelocity: Day17.Velocity(x: 7, y: 2)
        )
        
        XCTAssert(onTarget)
        XCTAssertEqual(positions.last!.x, 28)
        XCTAssertEqual(positions.last!.y, -7)
        
        (onTarget, positions, _) = Day17.performMovement(
            towards: targetArea,
            initialVelocity: Day17.Velocity(x: 6, y: 3)
        )
        
        XCTAssert(onTarget)
        XCTAssertEqual(positions.last!.x, 21)
        XCTAssertEqual(positions.last!.y, -9)
        
        (onTarget, _, _) = Day17.performMovement(
            towards: targetArea,
            initialVelocity: Day17.Velocity(x: 17, y: -4)
        )
        
        XCTAssertFalse(onTarget)
        
        (onTarget, positions, _) = Day17.performMovement(
            towards: targetArea,
            initialVelocity: Day17.Velocity(x: 6, y: 9)
        )
        let heighestPosition = Day17.findHeighestPosition(in: positions)
        
        XCTAssert(onTarget)
        XCTAssertEqual(heighestPosition.y, 45)
    }
    
    func test17_Part1_Example() {
        let targetArea = Day17.TargetArea(x: 20...30, y: -10 ... -5)
        let heighestPosition = Day17.findMostStylishVelocity(targetArea: targetArea)
        XCTAssertEqual(heighestPosition.y, 45)
    }
    
    func test17_Part1_Solution() throws {
        let result = try XCTUnwrap(Day17.partOne(input_17))
        XCTAssert(result.y > 0, "Expected non-zero result")
        print("Day 17 (Part 1) answer: \(result.y)")
    }
    
    func test17_Part2_Example() {
        let targetArea = Day17.TargetArea(x: 20...30, y: -10 ... -5)
        let velocities = Day17.findSuccessfulVelocities(targetArea: targetArea)
        XCTAssertEqual(velocities.count, 112)
    }
    
    func test17_Part2_Solution() throws {
        let result = try XCTUnwrap(Day17.partTwo(input_17))
        XCTAssert(result.count > 0, "Expected non-zero result")
        print("Day 17 (Part 2) answer: \(result.count)")
    }
    
    func test18_Part1_AddNumbers() {
        let a: Day18.Number = [1, 2]
        let b: Day18.Number = [3, 4]

        XCTAssertEqual(
            Day18.add(a, b),
            [.number([1, 2]), .number([3, 4])]
        )
    }
    
    func test18_Part1_SplitNumber() {
        XCTAssertEqual(Day18.split(0), [0, 0])
        XCTAssertEqual(Day18.split(10), [5, 5])
        XCTAssertEqual(Day18.split(11), [5, 6])
        XCTAssertEqual(Day18.split(15), [7, 8])
    }
    
    func test18_Part1_SimpleReduction() {
        let numbers: [Day18.Number] = [
            [1, 2],
            [3, 4],
            [5, [6, 7]]
        ]
        
        XCTAssertNoDifference(
            Day18.reduceMany(numbers),
            [[[1, 2], [3, 4]], [5, [6, 7]]]
        )
    }
    
    func test18_Part1_ReduceWithSplits() {
        let number: [Day18.Number] = [[[1, 11], 2], [3, [15, 4]]]
        
        XCTAssertNoDifference(
            Day18.reduceMany(number),
            [[[1, [5, 6]], 2], [3, [[7, 8], 4]]]
        )
    }
    
    func test18_Part1_ReduceWithExplode() {
        XCTAssertNoDifference(
            Day18.reduce([[[[[9, 8], 1], 2], 3], [4, 5]]),
            [[[[0, 9], 2], 3], [4, 5]]
        )

        XCTAssertNoDifference(
            Day18.reduce([7, [6, [5, [4, [3, 2]]]]]),
            [7, [6, [5, [7, 0]]]]
        )

        XCTAssertNoDifference(
            Day18.reduce([[6, [5, [4, [3, 2]]]], 1]),
            [[6, [5, [7, 0]]], 3]
        )
        
        XCTAssertNoDifference(
            Day18.reduce([[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]]),
            [[3, [2, [8, 0]]], [9, [5, [7, 0]]]]
        )
    }
    
    func test18_Part1_ExampleReduce() {
        let result = Day18.reduceMany([
            [[[[4,3],4],4],[7,[[8,4],9]]],
            [1,1]
        ])
        
        XCTAssertNoDifference(
            result,
            [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
        )
    }
    
    func test18_Part1_CalculateMagnitude() {
        XCTAssertEqual(
            Day18.magnitudeOf([[1,2],[[3,4],5]]),
            143
        )
        XCTAssertEqual(
            Day18.magnitudeOf([[[[0,7],4],[[7,8],[6,0]]],[8,1]]),
            1384
        )
        XCTAssertEqual(
            Day18.magnitudeOf([[[[5,0],[7,4]],[5,5]],[6,6]]),
            1137
        )
    }
    
    func test18_Part1_Parsing() {
        XCTAssertNoDifference(
            Day18.number.parse("[1,2]"),
            [1, 2]
        )
        XCTAssertNoDifference(
            Day18.number.parse("[[1,2],3]"),
            [[1, 2], 3]
        )
        XCTAssertNoDifference(
            Day18.number.parse("[[1,9],[8,5]]"),
            [[1,9],[8,5]]
        )
    }
    
    func test18_Part1_Example() {
        let input = """
        [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
        [[[5,[2,8]],4],[5,[[9,9],0]]]
        [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
        [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
        [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
        [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
        [[[[5,4],[7,7]],8],[[8,3],8]]
        [[9,3],[[9,9],[6,[4,9]]]]
        [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
        [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
        """
        
        XCTAssertEqual(Day18.partOne(input), 4140)
    }
    
    func test18_Part1_Solution() throws {
        let result = try XCTUnwrap(Day18.partOne(input_18))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 18 (Part 1) answer: \(result)")
    }
    
    func test18_Part2_Example() {
        let input = """
        [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
        [[[5,[2,8]],4],[5,[[9,9],0]]]
        [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
        [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
        [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
        [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
        [[[[5,4],[7,7]],8],[[8,3],8]]
        [[9,3],[[9,9],[6,[4,9]]]]
        [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
        [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
        """
        
        XCTAssertEqual(Day18.partTwo(input), 3993)
    }
    
    func test18_Part2_Solution() throws {
        let result = try XCTUnwrap(Day18.partTwo(input_18))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 18 (Part 2) answer: \(result)")
    }
    
    func test19_Part1_PointRotation() {
        let pointA = Day19.Coord3D(x: 1, y: 1, z: 1)
        
        XCTAssertNoDifference(
            Day19.rotatePoint(pointA, by: .init(x: 0, y: 0, z: 0)),
            .init(x: 1, y: 1, z: 1)
        )
        
        XCTAssertEqual(
            Day19.rotatePoint(pointA, by: .init(x: 90, y: 0, z: 0)),
            .init(x: 1, y: -1, z: 1)
        )
        
        XCTAssertEqual(
            Day19.rotatePoint(pointA, by: .init(x: 180, y: 0, z: 0)),
            .init(x: 1, y: -1, z: -1)
        )
        
        XCTAssertEqual(
            Day19.rotatePoint(pointA, by: .init(x: 270, y: 0, z: 0)),
            .init(x: 1, y: 1, z: -1)
        )
    }
    
//    func test19_Part1_PointPermutations() {
//        let pointA = Day19.Coord3D(x: 1, y: 1, z: 1)
//        
//        let expectedPointsA: Set<Day19.Coord3D> = [
//            .init(x: 1, y: 1, z: 1),
//            .init(x: -1, y: 1, z: 1),
//            .init(x: -1, y: -1, z: 1),
//            .init(x: 1, y: -1, z: 1),
//            .init(x: -1, y: 1, z: -1),
//            .init(x: 1, y: 1, z: -1),
//            .init(x: 1, y: -1, z: -1),
//            .init(x: -1, y: -1, z: -1)
//        ]
//        
//        let permutationsA = Day19.calculatePointPermutations(pointA)
//        
//        XCTAssertNoDifference(permutationsA, expectedPointsA)
//        
//        let pointB = Day19.Coord3D(x: 5, y: 6, z: -4)
//        let permutationsB = Day19.calculatePointPermutations(pointB)
//        
//        // Instead of testng all lets just test the ones from the
//        // examples given in the puzzle.
//        XCTAssert(permutationsB.contains(.init(x: 5, y: 6, z: -4)))
//        XCTAssert(permutationsB.contains(.init(x: 4, y: 6, z: 5)))
//        XCTAssert(permutationsB.contains(.init(x: -4, y: -6, z: 5)))
//        XCTAssert(permutationsB.contains(.init(x: -5, y: 4, z: -6)))
//        XCTAssert(permutationsB.contains(.init(x: -6, y: -4, z: -5)))
//    }
    
    func test19_Part1_Parsing() {
        let coord = Day19.coordinate.parse("1,2,3")
        XCTAssertEqual(coord, .init(x: 1, y: 2, z: 3))
        
        let inputString = """
        --- scanner 0 ---
        -1,-1,1
        -2,-2,2
        -3,-3,3
        -2,-3,1
        5,6,-4
        8,0,7

        --- scanner 1 ---
        1,-1,1
        2,-2,2
        3,-3,3
        2,-1,3
        -5,4,-6
        -8,-7,0
        """
        
        let input = Day19.parseInput(inputString)
        
        XCTAssertEqual(2, input.count)
        XCTAssertEqual(0, input[0].number)
        XCTAssertEqual(6, input[0].beacons.count)
        XCTAssert(input[0].beacons.contains(.init(x: -1, y: -1, z: 1)))
        XCTAssertEqual(1, input[1].number)
        XCTAssertEqual(6, input[1].beacons.count)
        XCTAssert(input[1].beacons.contains(.init(x: 1, y: -1, z: 1)))
    }
    
    func test19_Part1_Example() throws {
        let inputString = """
        --- scanner 0 ---
        404,-588,-901
        528,-643,409
        -838,591,734
        390,-675,-793
        -537,-823,-458
        -485,-357,347
        -345,-311,381
        -661,-816,-575
        -876,649,763
        -618,-824,-621
        553,345,-567
        474,580,667
        -447,-329,318
        -584,868,-557
        544,-627,-890
        564,392,-477
        455,729,728
        -892,524,684
        -689,845,-530
        423,-701,434
        7,-33,-71
        630,319,-379
        443,580,662
        -789,900,-551
        459,-707,401

        --- scanner 1 ---
        686,422,578
        605,423,415
        515,917,-361
        -336,658,858
        95,138,22
        -476,619,847
        -340,-569,-846
        567,-361,727
        -460,603,-452
        669,-402,600
        729,430,532
        -500,-761,534
        -322,571,750
        -466,-666,-811
        -429,-592,574
        -355,545,-477
        703,-491,-529
        -328,-685,520
        413,935,-424
        -391,539,-444
        586,-435,557
        -364,-763,-893
        807,-499,-711
        755,-354,-619
        553,889,-390
        
        --- scanner 2 ---
        649,640,665
        682,-795,504
        -784,533,-524
        -644,584,-595
        -588,-843,648
        -30,6,44
        -674,560,763
        500,723,-460
        609,671,-379
        -555,-800,653
        -675,-892,-343
        697,-426,-610
        578,704,681
        493,664,-388
        -671,-858,530
        -667,343,800
        571,-461,-707
        -138,-166,112
        -889,563,-600
        646,-828,498
        640,759,510
        -630,509,768
        -681,-892,-333
        673,-379,-804
        -742,-814,-386
        577,-820,562

        --- scanner 3 ---
        -589,542,597
        605,-692,669
        -500,565,-823
        -660,373,557
        -458,-679,-417
        -488,449,543
        -626,468,-788
        338,-750,-386
        528,-832,-391
        562,-778,733
        -938,-730,414
        543,643,-506
        -524,371,-870
        407,773,750
        -104,29,83
        378,-903,-323
        -778,-728,485
        426,699,580
        -438,-605,-362
        -469,-447,-387
        509,732,623
        647,635,-688
        -868,-804,481
        614,-800,639
        595,780,-596

        --- scanner 4 ---
        727,592,562
        -293,-554,779
        441,611,-461
        -714,465,-776
        -743,427,-804
        -660,-479,-426
        832,-632,460
        927,-485,-438
        408,393,-506
        466,436,-512
        110,16,151
        -258,-428,682
        -393,719,612
        -211,-452,876
        808,-476,-593
        -575,615,604
        -485,667,467
        -680,325,-822
        -627,-443,-432
        872,-547,-609
        833,512,582
        807,604,487
        839,-516,451
        891,-625,532
        -652,-548,-490
        30,-46,-14
        """
        
        let exampleInput = try XCTUnwrap(Day19.parseInput(inputString))
        
        let overlap = try XCTUnwrap(Day19.findScannerOverlap(
            scannerA: exampleInput[0],
            scannerB: exampleInput[1],
            minimumOverlappingPoints: 12
        ))
        
        XCTAssertEqual(
            overlap.translation,
            .init(x: 68, y: -1246, z: -43)
        )
        
        let overlaps = Day19.findOverlappingScanners(input: exampleInput)
        let zeroToOneOverlap = overlaps[0]
        
        XCTAssertEqual(zeroToOneOverlap.first, 0)
        XCTAssertEqual(zeroToOneOverlap.second, 1)
        XCTAssertEqual(
            zeroToOneOverlap.translation,
                .init(x: 68, y: -1246, z: -43)
        )
        
        var counted: [Int] = []
        
        let allBeacons = Day19.findBeacons(
            from: 0,
            input: exampleInput,
            overlaps: overlaps,
            alreadyCounted: &counted
        )

        XCTAssertEqual(79, allBeacons.count)
        XCTAssertEqual([0, 1, 2, 3, 4], counted.sorted())
    }
    
    func test19_Part1_Solution() throws {
        let result = try XCTUnwrap(Day19.partOne(input_19))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 19 (Part 1) answer: \(result)")
        XCTAssertEqual(result, 332)
    }
    
    func test19_Part2_Example() throws {
        let inputString = """
        --- scanner 0 ---
        404,-588,-901
        528,-643,409
        -838,591,734
        390,-675,-793
        -537,-823,-458
        -485,-357,347
        -345,-311,381
        -661,-816,-575
        -876,649,763
        -618,-824,-621
        553,345,-567
        474,580,667
        -447,-329,318
        -584,868,-557
        544,-627,-890
        564,392,-477
        455,729,728
        -892,524,684
        -689,845,-530
        423,-701,434
        7,-33,-71
        630,319,-379
        443,580,662
        -789,900,-551
        459,-707,401

        --- scanner 1 ---
        686,422,578
        605,423,415
        515,917,-361
        -336,658,858
        95,138,22
        -476,619,847
        -340,-569,-846
        567,-361,727
        -460,603,-452
        669,-402,600
        729,430,532
        -500,-761,534
        -322,571,750
        -466,-666,-811
        -429,-592,574
        -355,545,-477
        703,-491,-529
        -328,-685,520
        413,935,-424
        -391,539,-444
        586,-435,557
        -364,-763,-893
        807,-499,-711
        755,-354,-619
        553,889,-390
        
        --- scanner 2 ---
        649,640,665
        682,-795,504
        -784,533,-524
        -644,584,-595
        -588,-843,648
        -30,6,44
        -674,560,763
        500,723,-460
        609,671,-379
        -555,-800,653
        -675,-892,-343
        697,-426,-610
        578,704,681
        493,664,-388
        -671,-858,530
        -667,343,800
        571,-461,-707
        -138,-166,112
        -889,563,-600
        646,-828,498
        640,759,510
        -630,509,768
        -681,-892,-333
        673,-379,-804
        -742,-814,-386
        577,-820,562

        --- scanner 3 ---
        -589,542,597
        605,-692,669
        -500,565,-823
        -660,373,557
        -458,-679,-417
        -488,449,543
        -626,468,-788
        338,-750,-386
        528,-832,-391
        562,-778,733
        -938,-730,414
        543,643,-506
        -524,371,-870
        407,773,750
        -104,29,83
        378,-903,-323
        -778,-728,485
        426,699,580
        -438,-605,-362
        -469,-447,-387
        509,732,623
        647,635,-688
        -868,-804,481
        614,-800,639
        595,780,-596

        --- scanner 4 ---
        727,592,562
        -293,-554,779
        441,611,-461
        -714,465,-776
        -743,427,-804
        -660,-479,-426
        832,-632,460
        927,-485,-438
        408,393,-506
        466,436,-512
        110,16,151
        -258,-428,682
        -393,719,612
        -211,-452,876
        808,-476,-593
        -575,615,604
        -485,667,467
        -680,325,-822
        -627,-443,-432
        872,-547,-609
        833,512,582
        807,604,487
        839,-516,451
        891,-625,532
        -652,-548,-490
        30,-46,-14
        """
    
        let exampleInput = try XCTUnwrap(Day19.parseInput(inputString))
        
//        let positions = Day19.calculateScannerPositions(input: exampleInput)
    }
    
    func testDay20_Calculations() {
        let exampleGrid: Day20.Grid = [
            [1,0,0,1,0],
            [1,0,0,0,0],
            [1,1,0,0,1],
            [0,0,1,0,0],
            [0,0,1,1,1]
        ]
        
        let point = Day20.Point(2, 2)
        
        XCTAssertEqual(
            Day20.binaryNumberStringFromPoint(point, in: exampleGrid),
            "000100010"
        )
        XCTAssertEqual(
            Day20.indexForPoint(point, in: exampleGrid),
            34
        )
    }
    
    func testDay20_EnhanceGrid() throws {
        let algorithmString = """
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#
        
        """
        
        let exampleGrid: Day20.Grid = [
            [1,0,0,1,0],
            [1,0,0,0,0],
            [1,1,0,0,1],
            [0,0,1,0,0],
            [0,0,1,1,1]
        ]
        
        let algorithm = try XCTUnwrap(Day20.algorithm.parse(algorithmString))
        
        var exampleOutput = ""
        Day20.printGrid(exampleGrid) { exampleOutput += $0 }
        Day20.printGrid(exampleGrid)
        
        XCTAssertNoDifference(
        """
        #..#.
        #....
        ##..#
        ..#..
        ..###
        
        """,
        exampleOutput
        )
        
        let enhanced = Day20.enhanceGrid(
            exampleGrid,
            algorithm: algorithm,
            iteration: 1
        )
        
        var enhancedOutput = ""
        Day20.printGrid(enhanced) { enhancedOutput += $0 }
        Day20.printGrid(enhanced)
        
        XCTAssertNoDifference(
        """
        .##.##.
        #..#.#.
        ##.#..#
        ####..#
        .#..##.
        ..##..#
        ...#.#.
        
        """,
        enhancedOutput
        )
        
        let enhanced2 = Day20.enhanceGrid(
            enhanced,
            algorithm: algorithm,
            iteration: 2
        )
        
        var enhancedOutput2 = ""
        Day20.printGrid(enhanced2) { enhancedOutput2 += $0 }
        Day20.printGrid(enhanced2)
        
        XCTAssertNoDifference(
        """
        .......#.
        .#..#.#..
        #.#...###
        #...##.#.
        #.....#.#
        .#.#####.
        ..#.#####
        ...##.##.
        ....###..
        
        """,
        enhancedOutput2
        )
        
        XCTAssertEqual(35, Day20.countLitPixels(in: enhanced2))
        
        Day20.printGrid(enhanced2) {
            print($0, separator: "", terminator: "")
        }
    }
    
    func test20_Part1_Solution() throws {
        let result = try XCTUnwrap(Day20.partOne(input_20))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 20 (Part 1) answer: \(result)")
        XCTAssertEqual(result, 5391)
    }
    
    func test20_Part2_Example() {
        let exampleInput = """
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#
        
        #..#.
        #....
        ##..#
        ..#..
        ..###
        """
        
        let result = Day20.partTwo(exampleInput)
        XCTAssertEqual(result, 3351)
    }
    
    func test20_Part2_Solution() throws {
        let result = try XCTUnwrap(Day20.partTwo(input_20))
        XCTAssert(result > 0, "Expected non-zero result")
        print("Day 20 (Part 2) answer: \(result)")
        XCTAssertEqual(result, 16383)
    }
}
    
