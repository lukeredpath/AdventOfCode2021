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

        init(a: T, b: T, c: T, d: T, e: T) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
        }

        init(values: [T]) {
            assert(values.count == 5, "Can only make a line from exactly 5 squares")

            self.a = values[0]
            self.b = values[1]
            self.c = values[2]
            self.d = values[3]
            self.e = values[4]
        }
    }

    struct NumberSquare {
        var number: Int
        var marked: Bool = false
        var unmarked: Bool { !marked }
    }

    typealias DrawSequence = [Int]
    typealias Line = Five<NumberSquare>
    typealias BingoCard = Five<Line>
    typealias GameInput = (draw: DrawSequence, cards: [BingoCard])
    typealias GameResult = (card: BingoCard, winningNumber: Int)

    static let drawParser = Many(
        Int.parser(),
        separator: ","
    )

    static let cardRowParser = Skip(Whitespace<Substring.UTF8View>()).take(
        Many(
            Int.parser().map { NumberSquare(number: $0) },
            atLeast: 5, atMost: 5,
            separator: Whitespace<Substring.UTF8View>()
        )
        .map(Five<NumberSquare>.init(values:))
    )

    static let cardParser = Many(
        cardRowParser,
        atLeast: 5, atMost: 5,
        separator: "\n".utf8
    )
    .map(Five<Line>.init(values:))

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

    static func transpose(_ card: BingoCard) -> BingoCard {
        .init(
            a: .init(values: card.values.map(\.a)),
            b: .init(values: card.values.map(\.b)),
            c: .init(values: card.values.map(\.c)),
            d: .init(values: card.values.map(\.d)),
            e: .init(values: card.values.map(\.e))
        )
    }

    static func checkNumber(_ number: Int, card: BingoCard) -> BingoCard {
        BingoCard(values: card.values.map { row in
            Line(values: row.values.map { square in
                if square.number == number {
                    return update(square) { square in
                        square.marked = (square.number == number)
                    }
                } else {
                    return square
                }
            })
        })
    }

    static func isWinningLine(_ line: Line) -> Bool {
        line.values.allSatisfy(\.marked)
    }

    static func isWinningCard(_ card: BingoCard) -> Bool {
        card.values.contains(where: isWinningLine) ||
            transpose(card).values.contains(where: isWinningLine)
    }

    static func calculateWinningCardScore(card: BingoCard, winningNumber: Int) -> Int {
        winningNumber * card.values
            .flatMap(\.values)
            .filter(\.unmarked)
            .reduce(0) { $0 + $1.number }
    }

    static func findFirstWinningCard(input: GameInput) -> GameResult? {
        var cards = input.cards
        for number in input.draw {
            cards = cards.map(with(number, curry(checkNumber)))
            if let winningCard = cards.first(where: isWinningCard) {
                return (winningCard, number)
            }
        }
        return nil
    }

    static func findLastWinningCard(input: GameInput) -> GameResult? {
        var cards = input.cards
        for number in input.draw {
            cards = cards.map(with(number, curry(checkNumber)))

            if cards.count > 1 {
                cards = cards.filter { !isWinningCard($0) }
            } else if isWinningCard(cards[0]) {
                return (cards[0], number)
            }
        }
        return nil
    }

    static let partOne = pipe(
        parseInput,
        findFirstWinningCard,
        map(calculateWinningCardScore)
    )

    static let partTwo = pipe(
        parseInput,
        findLastWinningCard,
        map(calculateWinningCardScore)
    )
}
