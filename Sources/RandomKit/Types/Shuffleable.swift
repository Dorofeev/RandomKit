//
//  Shuffleable.swift
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

/// A type whose elements can be shuffled.
public protocol Shuffleable {

    /// Shuffles the elements of `self` and returns the result.
    func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Self

    /// Shuffles the elements of `self`.
    mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R)

}

extension Shuffleable {

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        self = shuffled(using: &randomGenerator)
    }

}

/// A type whose elements can be shuffled in an index range.
public protocol ShuffleableInRange: Shuffleable {

    /// A type that represents a position in an instance of `Self`.
    associatedtype Index: Comparable

    /// Shuffles the elements of `self` in `range` and returns the result.
    func shuffled<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R) -> Self

    /// Shuffles the elements of `self` in `range`.
    mutating func shuffle<R: RandomGenerator>(in range: Range<Index>, using randomGenerator: inout R)

}

extension ShuffleableInRange where Index: Strideable, Index.Stride: SignedInteger {

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) {
        shuffle(in: range, using: &randomGenerator)
    }

}
