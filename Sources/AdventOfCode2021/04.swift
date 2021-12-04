import Foundation
import Overture
import Parsing

enum Day04 {
    struct Five<T> {
        var a: T
        var b: T
        var c: T
        var d: T
        var e: T
        var values: [T] { [a, b, c, d, e] }
    }

    struct NumberSquare {
        var number: Int
        var marked: Bool = false
    }

    typealias DrawSequence = [Int]
    typealias BingoCard = Five<Five<NumberSquare>>
    typealias GameInput = (draw: DrawSequence, cards: [BingoCard])

    static let drawParser = Many(
        Int.parser(),
        separator: ","
    )

    static let cardRowParser = Skip(Whitespace<Substring.UTF8View>()).take(
        Many(
            Int.parser().map { NumberSquare(number: $0) },
            atLeast: 5, atMost: 5,
            separator: Whitespace<Substring.UTF8View>()
        ).map { numbers in
            Five<NumberSquare>(
                a: numbers[0],
                b: numbers[1],
                c: numbers[2],
                d: numbers[3],
                e: numbers[4]
            )
        }
    )

    static let cardParser = Many(
        cardRowParser,
        atLeast: 5, atMost: 5,
        separator: "\n".utf8
    ).map { rows in
        BingoCard(
            a: rows[0],
            b: rows[1],
            c: rows[2],
            d: rows[3],
            e: rows[4]
        )
    }

    static let cardsParser = Many(
        cardParser,
        atLeast: 1,
        separator: "\n".utf8
    )

    static let inputParser = drawParser.utf8
        .skip(Whitespace<Substring.UTF8View>())
        .take(cardsParser)
        .map { (draw: $0.0, cards: $0.1) }

    static func parseInput(_ input: String) -> GameInput {
        var input = input[...].utf8
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
}
