//
//  RandomInClosedRange.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2017 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A type that can generate an random value in a closed range.
public protocol RandomInClosedRange: Comparable {

    /// Returns a random value of `Self` inside of the closed range using `randomGenerator`.
    static func random<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> Self

}

extension RandomInClosedRange where Self: Strideable & Comparable, Self.Stride : SignedInteger {

    /// Returns a random value of `Self` inside of the closed range.
    public static func random<R: RandomGenerator>(in closedRange: CountableClosedRange<Self>,
                                                  using randomGenerator: inout R) -> Self {
        return random(in: closedRange, using: &randomGenerator)
    }

}

extension RandomInClosedRange {

    #if swift(>=3.2)

    /// Returns a sequence of random values in `closedRange` using `randomGenerator`.
    public static func randoms<R>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> RandomsWithinClosedRange<Self, R> {
        return RandomsWithinClosedRange(closedRange: closedRange, randomGenerator: &randomGenerator)
    }

    /// Returns a sequence of random values limited by `limit` in `closedRange` using `randomGenerator`.
    public static func randoms<R>(limitedBy limit: Int, in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> LimitedRandomsWithinClosedRange<Self, R> {
        return LimitedRandomsWithinClosedRange(limit: limit, closedRange: closedRange, randomGenerator: &randomGenerator)
    }

    #else

    /// Returns a sequence of random values in `closedRange` using `randomGenerator`.
    public static func randoms<R: RandomGenerator>(in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> RandomsWithinClosedRange<Self, R> {
        return RandomsWithinClosedRange(closedRange: closedRange, randomGenerator: &randomGenerator)
    }

    /// Returns a sequence of random values limited by `limit` in `closedRange` using `randomGenerator`.
    public static func randoms<R: RandomGenerator>(limitedBy limit: Int, in closedRange: ClosedRange<Self>, using randomGenerator: inout R) -> LimitedRandomsWithinClosedRange<Self, R> {
        return LimitedRandomsWithinClosedRange(limit: limit, closedRange: closedRange, randomGenerator: &randomGenerator)
    }

    #endif

}

/// A sequence of random values of a `RandomInClosedRange` type, generated by a `RandomGenerator`.
///
/// - warning: An instance *should not* outlive its `RandomGenerator`.
///
/// - seealso: `LimitedRandomsWithinClosedRange`
public struct RandomsWithinClosedRange<Element: RandomInClosedRange, RG: RandomGenerator>: IteratorProtocol, Sequence {

    /// A pointer to the `RandomGenerator`
    private let _randomGenerator: UnsafeMutablePointer<RG>

    /// The closed range to generate in.
    public var closedRange: ClosedRange<Element>

    /// Creates an instance with `closedRange` and `randomGenerator`.
    public init(closedRange: ClosedRange<Element>, randomGenerator: inout RG) {
        _randomGenerator = UnsafeMutablePointer(&randomGenerator)
        self.closedRange = closedRange
    }

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists. Once `nil` has been returned, all subsequent calls return `nil`.
    public mutating func next() -> Element? {
        return Element.random(in: closedRange, using: &_randomGenerator.pointee)
    }

}

/// A limited sequence of random values of a `RandomInClosedRange` type, generated by a `RandomGenerator`.
///
/// - warning: An instance *should not* outlive its `RandomGenerator`.
///
/// - seealso: `RandomsWithinClosedRange`
public struct LimitedRandomsWithinClosedRange<Element: RandomInClosedRange, RG: RandomGenerator>: IteratorProtocol, Sequence {

    /// A pointer to the `RandomGenerator`
    private let _randomGenerator: UnsafeMutablePointer<RG>

    /// The iteration for the random value generation.
    private var _iteration: Int = 0

    /// The limit value.
    public var limit: Int

    /// The closed range to generate in.
    public var closedRange: ClosedRange<Element>

    /// A value less than or equal to the number of elements in
    /// the sequence, calculated nondestructively.
    ///
    /// - Complexity: O(1)
    public var underestimatedCount: Int {
        return limit &- _iteration
    }

    /// Creates an instance with `limit`, `closedRange`, and `randomGenerator`.
    public init(limit: Int, closedRange: ClosedRange<Element>, randomGenerator: inout RG) {
        _randomGenerator = UnsafeMutablePointer(&randomGenerator)
        self.limit = limit
        self.closedRange = closedRange
    }

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists. Once `nil` has been returned, all subsequent calls return `nil`.
    public mutating func next() -> Element? {
        guard _iteration < limit else { return nil }
        _iteration = _iteration &+ 1
        return Element.random(in: closedRange, using: &_randomGenerator.pointee)
    }

}
