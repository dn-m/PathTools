//
//  Path+CGPath.swift
//  PathTools
//
//  Created by James Bean on 6/3/17.
//
//

import QuartzCore

extension Path {
    
    /// `CGPath` representation of `Path`.
    public var cgPath: CGPath {
        
        let path = CGMutablePath()
        
        guard let firstCurve = curves.first else {
            return path
        }
        
        var last = firstCurve.start
        
        path.move(to: CGPoint(last))

        for (c, curve) in curves.enumerated() {

            // Manage closed subpatch
            if c == curves.count - 1, curve.order == .linear, curve.end == last {
                path.closeSubpath()
                continue
            }
            
            if curve.start != last {
                path.move(to: CGPoint(curve.start))
                last = curve.start
            }
            
            switch curve.order {
            case .linear:
                path.addLine(to: CGPoint(curve.end))
            case .quadratic:
                path.addQuadCurve(to: CGPoint(curve.end), control: CGPoint(curve.points[1]))
            case .cubic:
                path.addCurve(
                    to: CGPoint(curve.end),
                    control1: CGPoint(curve.points[1]),
                    control2: CGPoint(curve.points[2])
                )
            }
        }
        
        return path.copy()!
    }
    
    /// Creates a `Path` with a `CGPath`.
    public init(_ cgPath: CGPath?) {
        var pathElements: [PathElement] = []
        withUnsafeMutablePointer(to: &pathElements) { elementsPointer in
            cgPath?.apply(info: elementsPointer) { (userInfo, nextElementPointer) in
                let nextElement = PathElement(element: nextElementPointer.pointee)
                let elementsPointer = userInfo!.assumingMemoryBound(to: [PathElement].self)
                elementsPointer.pointee.append(nextElement)
            }
        }
        self.init(pathElements: pathElements)
    }
}
