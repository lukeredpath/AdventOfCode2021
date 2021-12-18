import Foundation
import Overture
import Parsing

enum Day18 {
    typealias Pair = Day14.Pair
    typealias Number = Pair<Element>
    typealias Explosion = (lhs: Int, rhs: Int, replacement: Element)
    
    enum Element: Equatable, Hashable {
        case regular(Int)
        indirect case number(Number)
    }
    
    // MARK: - Parsing
    
    static var number: AnyParser<Substring, Number> {
        StartsWith("[")
            .take(element)
            .skip(",")
            .take(element)
            .skip("]")
            .map { Number($0, $1) }
            .eraseToAnyParser()
    }
    
    static var numberElement: AnyParser<Substring, Element> {
        Lazy { number }.map(Element.number).eraseToAnyParser()
    }
    
    static let regularElement = Int.parser()
        .map { Element.regular($0) }
    
    static let element = numberElement.orElse(regularElement)
    
    static let numbers = Many(number, separator: "\n")
    
    static func parseInput(_ inputString: String) -> [Number] {
        guard let result = numbers.parse(inputString) else {
            fatalError("Could not parse input!")
        }
        return result
    }
    
    // MARK: - Number operations
    
    static func add(_ lhs: Number, _ rhs: Number) -> Number {
        .init(.number(lhs), .number(rhs))
    }
    
    static func addToLeft(number: Number, addend: Int) -> Number {
        switch number.a {
        case let .regular(a):
            return .init(.regular(a + addend), number.b)
        case let .number(a):
            return .init(.number(addToLeft(number: a, addend: addend)), number.b)
        }
    }
    
    static func addToRight(number: Number, addend: Int) -> Number {
        switch number.b {
        case let .regular(b):
            return .init(number.a, .regular(b + addend))
        case let .number(b):
            return .init(number.a, .number(addToRight(number: b, addend: addend)))
        }
    }
    
    static func split(_ value: Int) -> Number {
        .init(
            .regular(Int((Double(value) / 2).rounded(.down))),
            .regular(Int((Double(value) / 2).rounded(.up)))
        )
    }
    
    static func explode(_ number: Number, stack: [Number] = []) -> Explosion {
        if stack.count == 4,
            case let .regular(lhs) = number.a,
            case let .regular(rhs) = number.b {
            // We have found a pair to explode
            return (lhs: lhs, rhs: rhs, .regular(0))
        } else {
            switch (number.a, number.b) {
            case (let .number(a), let .regular(b)):
                let explosion = explode(a, stack: stack + [number])
                return (lhs: explosion.lhs, rhs: 0, replacement: .number(
                    .init(
                        explosion.replacement,
                        .regular(b + explosion.rhs)
                    )
                ))
            case (let .number(a), let .number(b)):
                // If we have a number on both sides, we only consider the
                // right if there is no explosion on the left.
                var explosion = explode(a, stack: stack + [number])
                if explosion.replacement != .number(a) {
                    // If the replacement is different the number was exploded
                    return (lhs: explosion.lhs, rhs: 0, replacement: .number(
                        .init(
                            explosion.replacement,
                            .number(addToLeft(number: b, addend: explosion.rhs))
                        )
                    ))
                } else {
                    // Otherwise there was no explosion, so try explode(b)
                    explosion = explode(b, stack: stack + [number])
                    return (lhs: 0, rhs: explosion.rhs, replacement: .number(
                        .init(
                            .number(addToRight(number: a, addend: explosion.lhs)),
                            explosion.replacement
                        )
                    ))
                }
            case (let .regular(a), let .number(b)):
                let explosion = explode(b, stack: stack + [number])
                return (lhs: 0, rhs: explosion.rhs, replacement: .number(
                    .init(
                        .regular(a + explosion.lhs),
                        explosion.replacement
                    )
                ))
            case (.regular, .regular):
                return (lhs: 0, rhs: 0, replacement: .number(number))
            }
        }
    }
    
    static func canSplit(_ value: Int) -> Bool {
        value >= 10
    }
    
    static func canSplit(_ number: Number) -> Bool {
        switch (number.a, number.b) {
        case (let .number(a), let .regular(b)):
            return canSplit(a) || canSplit(b)
            
        case (let .regular(a), let .number(b)):
            return canSplit(a) || canSplit(b)
            
        case (let .number(a), let .number(b)):
            return canSplit(a) || canSplit(b)
            
        case (let .regular(a), let .regular(b)):
            return canSplit(a) || canSplit(b)
        }
    }
    
    static func split(_ number: Number) -> Number {
        switch (number.a, number.b) {
        case (let .number(a), let .regular(b)) where canSplit(a):
            return .init(.number(split(a)), .regular(b))
            
        case (let .number(a), let .regular(b)) where canSplit(b):
            return .init(.number(a), .number(split(b)))
            
        case (let .regular(a), let .number(b)) where canSplit(a):
            return .init(.number(split(a)), .number(b))
            
        case (let .regular(a), let .number(b)) where canSplit(b):
            return .init(.regular(a), .number(split(b)))
            
        case (let .number(a), let .number(b)) where canSplit(a):
            return .init(.number(split(a)), .number(b))
                         
        case (let .number(a), let .number(b)) where canSplit(b):
            return .init(.number(a), .number(split(b)))
            
        case (let .regular(a), let .regular(b)) where canSplit(a):
            return .init(.number(split(a)), .regular(b))
            
        case (let .regular(a), let .regular(b)) where canSplit(b):
            return .init(.regular(a), .number(split(b)))
            
        default:
            return number
        }
    }
    
    static func reduceOnce(_ number: Number) -> (result: Number, isComplete: Bool) {
        if case let .number(exploded) = explode(number).replacement,
            exploded != number {
            return (exploded, false)
        }
        let split = split(number)
        if split != number {
            return (split, false)
        }
        return (number, true)
    }
    
    static func reduce(_ number: Number) -> Number {
        var result = number
        var isComplete = false
        while !isComplete {
            (result, isComplete) = reduceOnce(result)
        }
        return result
    }
    
    static func reduceMany(_ numbers: [Number]) -> Number {
        guard numbers.count > 1 else { return numbers[0] }
        
        return numbers.dropFirst().reduce(numbers[0]) { partialResult, number in
            reduce(add(partialResult, number))
        }
    }
    
    static func magnitudeOf(_ element: Element) -> Int {
        switch element {
        case let .regular(value):
            return value
        case let .number(number):
            return calculateMagnitude(of: number)
        }
    }
    
    static func calculateMagnitude(of number: Number) -> Int {
        (magnitudeOf(number.a) * 3) + (magnitudeOf(number.b) * 2)
    }
    
    static func findLargestMagnitude(from numbers: [Number]) -> Int {
        pairPermuationsOf(numbers).map { pair in
            calculateMagnitude(of: reduceMany([pair.a, pair.b]))
        }.max() ?? 0
    }
    
    static func pairPermuationsOf(_ numbers: [Number]) -> [Pair<Number>] {
        let numberSet = Set(numbers)
        return numberSet.flatMap { number in
            numberSet.subtracting([number]).map { otherNumber in
                return Pair(number, otherNumber)
            }
        }
    }
    
    // MARK: - Solutions
    
    static let partOne = pipe(parseInput, reduceMany, calculateMagnitude)
    static let partTwo = pipe(parseInput, findLargestMagnitude)
}

extension Day18.Element: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self = .regular(value)
    }
}

extension Day18.Element: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Self...) {
        precondition(
            elements.count == 2,
            "Pairs must be initialised with a 2-element array."
        )
        self = .number(.init(elements[0], elements[1]))
    }
}

extension Day18.Pair: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: T...) {
        precondition(
            elements.count == 2,
            "Pairs must be initialised with a 2-element array."
        )
        self.init(elements[0], elements[1])
    }
}
