//
//  FloatingPoint+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
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

import Foundation

extension FloatingPoint where Self: RandomWithinClosedRange {

    /// Generates a random value of `Self`.
    public static func random(using randomGenerator: RandomGenerator) -> Self {
        return random(within: 0...1, using: randomGenerator)
    }

    /// Returns a random value of `Self` inside of the closed range.
    public static func random(within closedRange: ClosedRange<Self>, using randomGenerator: RandomGenerator) -> Self {
        let multiplier = closedRange.upperBound - closedRange.lowerBound
        return closedRange.lowerBound + multiplier * (Self(UInt.random(using: randomGenerator)) / Self(UInt.max))
    }

}

extension FloatingPoint where Self: RandomThroughValue {

    /// The random base from which to generate.
    public static var randomBase: Self {
        return 0
    }

}

extension FloatingPoint where Self: RandomWithinClosedRange & RandomThroughValue {

    /// Generates a random value of `Self` from `Self.randomBase` through `value` using `randomGenerator`.
    public static func random(through value: Self, using randomGenerator: RandomGenerator) -> Self {
        let range: ClosedRange<Self>
        if value < randomBase {
            range = value...randomBase
        } else {
            range = randomBase...value
        }
        return random(within: range, using: randomGenerator)
    }

}

extension Double: RandomThroughValue, RandomWithinClosedRange {
}

extension Float: RandomThroughValue, RandomWithinClosedRange {
}

#if os(macOS)
extension Float80: RandomThroughValue, RandomWithinClosedRange {
}
#endif

extension Double: RandomDistribuable {

    public func raised(to power: Double) -> Double {
        return Foundation.pow(self, power)
    }

    /// Returns e raised to the exponent `self`.
    public func exponentOfE() -> Double {
        return Foundation.exp(self)
    }

    public func log() -> Double {
        return Foundation.log(self)
    }

    public static var nextGaussianValue: Double? = nil

}

extension Float: RandomDistribuable {

    public func raised(to power: Float) -> Float {
        return Foundation.pow(self, power)
    }

    /// Returns e raised to the exponent `self`.
    public func exponentOfE() -> Float {
        return Foundation.exp(self)
    }

    public func log() -> Float {
        return Foundation.log(self)
    }

    public static var nextGaussianValue: Float? = nil

}

extension Double: BernoulliProbability {

    public static var bernouilliRange: ClosedRange<Double> {
        return 0...1
    }

}
