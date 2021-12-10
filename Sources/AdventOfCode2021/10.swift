import Foundation
import Overture
import Parsing

enum Day10 {
    struct SyntaxError: Equatable {
        let expected: Character
        let found: Character
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
                    // For now lets ignore any values when the stack is empty or
                    // invalid characters.
                    continue
                }
                if character != expected {
                    return .init(expected: expected, found: character)
                }
            }
        }
        return nil
    }
    
    static func parseInput(_ input: String) -> [String] {
        input.components(separatedBy: .newlines)
    }
    
    static func scoreErrors(_ errors: [SyntaxError?]) -> Int {
        errors.reduce(into: 0) { partialResult, error in
            if let error = error {
                partialResult += scoreForError(error)
            }
        }
    }
    
    static func scoreForError(_ error: SyntaxError) -> Int {
        switch error.found {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: return 0
        }
    }
    
    static let partOne = pipe(
        parseInput,
        map(scanChunks),
        scoreErrors
    )
}
