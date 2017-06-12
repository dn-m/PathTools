//
//  CubicBezierCurveTests.swift
//  PathTools
//
//  Created by James Bean on 6/9/17.
//
//

import XCTest
import GeometryTools
@testable import PathTools

class CubicBezierCurveTests: XCTestCase {
    
    func testUpAndDown() {

        let upAndDown = CubicBezierCurve(
            start: Point(x: -1, y: 0),
            control1: Point(x: 0, y: 1),
            control2: Point(x: 0, y: -1),
            end: Point(x: 1, y: 0)
        )
        
        stride(from: Double(0), through: 1.0, by: 0.1).forEach { t in
            print("up and down at: \(t): \(upAndDown[t])")
        }
    }
    
    func testSlopeDown() {
        
        let slopeDown = CubicBezierCurve(
            start: Point(x: 0, y: 1),
            control1: Point(x: 0, y: 0),
            control2: Point(x: 0, y: 0),
            end: Point(x: 1, y: 0)
        )
        
        XCTAssertEqual(slopeDown[0.5], Point(x: 0.125, y: 0.125))
    }
    
    func testSlopeUp() {
        
        let slopeDown = CubicBezierCurve(
            start: Point(x: 0, y: 0),
            control1: Point(x: 1, y: 0),
            control2: Point(x: 1, y: 0),
            end: Point(x: 1, y: 1)
        )
        
        XCTAssertEqual(slopeDown[0.5], Point(x: 0.875, y: 0.125))
    }
    
    func testYsAtX() {
        
        let upAndDown = CubicBezierCurve(
            start: Point(x: -1, y: 0),
            control1: Point(x: 0, y: 1),
            control2: Point(x: 0, y: -1),
            end: Point(x: 1, y: 0)
        )
        
        stride(from: Double(0), to: 1, by: 0.01).forEach { t in
            let point = upAndDown[t]
            let ys = upAndDown.ys(x: point.x)
            XCTAssert(ys.contains(point.y, accuracy: 0.0000001))
        }
    }
    func testXsAtY() {
        
        let upAndDown = CubicBezierCurve(
            start: Point(x: -1, y: 0),
            control1: Point(x: 0, y: 1),
            control2: Point(x: 0, y: -1),
            end: Point(x: 1, y: 0)
        )
        
        stride(from: Double(0), to: 1, by: 0.01).forEach { t in
            let point = upAndDown[t]
            let xs = upAndDown.xs(y: point.y)
            XCTAssert(xs.contains(point.x, accuracy: 0.0000001))
        }
    }
    
    func testLength() {
        
        let upAndDown = CubicBezierCurve(
            start: Point(x: -1, y: 0),
            control1: Point(x: 0, y: 1),
            control2: Point(x: 0, y: -1),
            end: Point(x: 1, y: 0)
        )
        
        let l = upAndDown.length
    }
}

/// - TODO: Move to `dn-m/ArithmeticTools`.
extension Sequence where Iterator.Element == Double {
    
    func contains(_ value: Double, accuracy: Double) -> Bool {
        
        for el in self {
            if abs(value - el) < accuracy {
                return true
            }
        }
        return false
    }
}
