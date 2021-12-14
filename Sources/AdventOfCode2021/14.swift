import Foundation
import Overture
import Parsing

enum Day14 {
    typealias Polymer = String
    typealias Element = Character
    typealias InsertionRule = (match: Pair<Element>, insertion: Character)
    typealias Input = (template: Polymer, rules: [InsertionRule])
    
    struct Pair<T> {
        var a: T
        var b: T
        
        init(_ a: T, _ b: T) {
            self.a = a
            self.b = b
        }
    }
    
    // MARK: - Parsing
    
    static let template = PrefixUpTo<Substring>("\n").map(Polymer.init)
    static let element = Prefix<Substring>(1).map { $0[0] }
    static let pair = Many(element, atLeast: 2, atMost: 2).map { elements -> Pair<Element> in
        .init(elements[0], elements[1])
    }
    static let rule = pair.skip(" -> ").take(element)
    static let rules = Many(rule, separator: "\n")
    static let inputParser = template.skip("\n\n").take(rules)
    
    static func parseInput(_ input: String) -> Input {
        var input = input[...]
        guard let result = inputParser.parse(&input) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Rule application
    
    static func applyRule(_ rule: InsertionRule, to pair: Pair<Element>) -> [Pair<Element>] {
        guard rule.match == pair else { return [pair] }
        
        return [
            .init(pair.a, rule.insertion),
            .init(rule.insertion, pair.b)
        ]
    }
    
    static func extractPairs(from polymer: Polymer) -> [Pair<Element>] {
        let indexPairs = zip((0..<polymer.count - 1), 1..<polymer.count)
        return indexPairs.map { .init(polymer[$0], polymer[$1]) }
    }
    
    static func applyRules(_ rules: [InsertionRule], to polymer: Polymer) -> Polymer {
        let pairs: [Pair<Element>] = extractPairs(from: polymer).flatMap { pair -> [Pair<Element>] in
            if let matchingRule = rules.first(where: { $0.match == pair }) {
                return applyRule(matchingRule, to: pair)
            } else {
                return [pair]
            }
        }
        return combinePairs(pairs)
    }
    
    static func combinePairs(_ pairs: [Pair<Element>]) -> Polymer {
        guard !pairs.isEmpty else { return "" }
        return (pairs.map(\.a) + [pairs.last!.b]).map(String.init).joined()
    }
    
    static func performPairInsertion(input: Input, iterations count: Int) -> Polymer {
        (1...count).reduce(into: input.template) { partialResult, _ in
            partialResult = applyRules(input.rules, to: partialResult)
        }
    }
    
    static func countElements(in polymer: Polymer) -> [Element: Int] {
        polymer[...].reduce(into: Dictionary<Element, Int>()) { counts, element in
            counts[element] = counts[element, default: 0] + 1
        }
    }
    
    static func countRange(in counts: [Element: Int]) -> Pair<Int> {
        .init(counts.values.max()!, counts.values.min()!)
    }
    
    static func calculateDifference(between values: Pair<Int>) -> Int {
        values.a - values.b
    }
    
    static let partOne = pipe(
        parseInput,
        with(10, flip(curry(performPairInsertion))),
        countElements,
        countRange,
        calculateDifference
    )
}

extension Day14.Pair: Equatable where T: Equatable {}
extension Day14.Pair: Hashable where T: Hashable {}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
