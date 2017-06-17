//
//  Path+Circle.swift
//  PathTools
//
//  Created by James Bean on 6/11/16.
//
//

import Darwin
import GeometryTools

extension Path {
    
    // MARK: - Circle
    
    /// Creates a `Path` with the given `circle`.
    public init(_ circle: Circle) {
        
        let (x,y,r) = (circle.center.x, circle.center.y, circle.radius)
        let left = x - r
        let right = x + r
        let top = y + r
        let bottom = y - r
        
        // Distance from each point to its neighboring control points
        let a = (4 * (sqrt(2.0) - 1) / 3) * r
        
        self.init([
            
            BezierCurve(start: Point(x: x, y: top),
                        control1: Point(x: x + a, y: top),
                        control2: Point(x: right, y: y + a),
                        end: Point(x: right, y: y)
            ),
            
            BezierCurve(
                start: Point(x: right, y: y),
                control1: Point(x: right, y: y - a),
                control2: Point(x: x + a, y: bottom),
                end: Point(x: x, y: bottom)
            ),
            
            // bottom center -> left
            BezierCurve(
                start: Point(x: x, y: bottom),
                control1: Point(x: x - a, y: bottom),
                control2: Point(x: left, y: y - a),
                end: Point(x: left, y: y)
            ),
            
            // left -> top center
            BezierCurve(
                start: Point(x: left, y: y),
                control1: Point(x: left, y: y + a),
                control2: Point(x: x - a, y: top),
                end: Point(x: x, y: top)
            )
        ])
    }
    
    /// - returns: `Path` with a circle shape with the given `radius` and `center`.
    public static func circle(center: Point, radius: Double) -> Path {
        return Path(Circle(center: center, radius: radius))
    }
}
