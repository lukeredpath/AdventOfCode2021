import Foundation
import Overture
import Parsing

enum Day18 {
    typealias Pair = Day14.Pair
    typealias Number = Pair<Element>
    
    enum Element: Equatable {
        case regular(Int)
        indirect case pair(Number)
    }
    
    static func add(_ lhs: Number, _ rhs: Number) -> Number {
        .init(.pair(lhs), .pair(rhs))
    }
    
    static func split(_ value: Int) -> Number {
        .init(
            .regular(Int((Double(value) / 2).rounded(.down))),
            .regular(Int((Double(value) / 2).rounded(.up)))
        )
    }
    
    static func explode() {
        
    }
    
    static func reduce(_ number: Number) -> Number {
        number
    }
    
    static func reduce(_ numbers: [Number]) -> Number {
        guard numbers.count > 1 else { return numbers[0] }
        
        return numbers.dropFirst().reduce(numbers[0]) { partialResult, number in
            reduce(add(partialResult, number))
        }
    }
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
        self = .pair(.init(elements[0], elements[1]))
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
