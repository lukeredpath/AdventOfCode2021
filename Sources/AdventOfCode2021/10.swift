import Foundation
import Overture
import Parsing

enum Day10 {
    enum SyntaxError: Equatable {
        case corrupted(expected: Character, found: Character)
        case incomplete(stack: [Character])
    }
    
    static let delimiters: [Character: Character] = [
        "{" : "}",
        "[" : "]",
        "<" : ">",
        "(" : ")"
    ]
    
    static func scanChunks(_ input: String) -> SyntaxError? {
        var stack: [Character] = []
        for character in input[...] {
            if delimiters.keys.contains(character) {
                stack.append(character)
            } else if delimiters.values.contains(character) {
                guard let last = stack.popLast(), let expected = delimiters[last] else {
                    continue
                }
                if character != expected {
                    return .corrupted(expected: expected, found: character)
                }
            }
        }
        guard stack.isEmpty else {
            return .incomplete(stack: stack)
        }
        return nil
    }
    
    static func findCompletionCharacters(stack: [Character]) -> [Character] {
        stack.compactMap { delimiters[$0] }.reversed()
    }
    
    static func parseInput(_ input: String) -> [String] {
        input.components(separatedBy: .newlines)
    }
    
    static func calculateCorruptedScore(_ errors: [SyntaxError?]) -> Int {
        errors.reduce(into: 0) { partialResult, error in
            switch error {
            case let .corrupted(_, found):
                partialResult += corruptedScore(found: found)
            default:
                break
            }
        }
    }
    
    static func calculateAutocompleteScores(_ errors: [SyntaxError?]) -> [Int] {
        errors.compactMap { error in
            switch error {
            case let .incomplete(stack):
                return autocompleteScore(characters: findCompletionCharacters(stack: stack))
            default:
                return nil
            }
        }
    }
    
    static func autocompleteScore(characters: [Character]) -> Int {
        characters.reduce(into: 0) { partialResult, character in
            partialResult *= 5
            switch character {
            case ")":
                partialResult += 1
            case "]":
                partialResult += 2
            case "}":
                partialResult += 3
            case ">":
                partialResult += 4
            default:
                break
            }
        }
    }
    
    static func corruptedScore(found: Character) -> Int {
        switch found {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: return 0
        }
    }
    
    static func findWinningScore(_ scores: [Int]) -> Int {
        scores.sorted()[(scores.count) / 2]
    }
    
    static let partOne = pipe(
        parseInput,
        map(scanChunks),
        calculateCorruptedScore
    )
    
    static let partTwo = pipe(
        parseInput,
        map(scanChunks),
        calculateAutocompleteScores,
        findWinningScore
    )
}
