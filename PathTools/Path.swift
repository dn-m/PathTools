//
//  Path.swift
//  PathTools
//
//  Created by James Bean on 6/10/16.
//
//

import Collections
import ArithmeticTools
import GeometryTools

/// - TODO: Conform to `Collection` protocols (parameterized over `BezierCurve`)
public struct Path {
    
    // MARK: - Instance Properties
    
    public var isShape: Bool {
        return curves.all { curve in curve.order == .linear }
    }
    
    /// - Returns: `true` if there are no non-`.close` elements contained herein. Otherwise,
    /// `false`.
    public var isEmpty: Bool {
        return curves.isEmpty
    }
    
    internal let curves: [BezierCurve]
    
    // MARK: - Initializers
    
    /// Create a `Path` with the given `curves`.
    public init(_ curves: [BezierCurve]) {
        self.curves = curves
    }
    
    /// Create a `Path` with the given `pathElements`.
    internal init(pathElements: [PathElement]) {
        
        guard
            let (head, tail) = pathElements.destructured, case let .move(start) = head
        else {
            self = Path([])
            return
        }
        
        let builder = Path.builder.move(to: start)
        var last = start
        
        for element in tail {
            switch element {
            case .move(let point):
                _ = builder.move(to: point)
                last = point
            case .line(let point):
                point == last ? builder.close() : builder.addLine(to: point)
            case .quadCurve(let point, let control):
                builder.addQuadCurve(to: point, control: control)
            case .curve(let point, let control1, let control2):
                builder.addCurve(to: point, control1: control1, control2: control2)
            case .close:
                builder.close()
            }
        }
        
        self = builder.build()
    }
    
    // MARK: - Instance Methods
    
    /// - Returns: Polygonal representation of the `Path`.
    public func simplified(segmentCount: Int) -> Polygon {
        
        let vertices = curves.map { $0.simplified(segmentCount: segmentCount) }
        let (most, last) = vertices.split(at: vertices.count - 1)!
        let merged = most.flatMap { $0.dropLast() } + last[0]
        
        if merged.count == 2 {
            return Polygon(vertices: merged + merged[0])
        }
        
        return Polygon(vertices: merged)
    }
}

extension Path: Monoid {

    /// Empty path.
    public static let unit = Path([])
    
    /// - Returns: New `Path` with elements of two paths.
    public static func + (lhs: Path, rhs: Path) -> Path {
        return Path(lhs.curves + rhs.curves)
    }
}

extension Path: AnyCollectionWrapping {

    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<BezierCurve> {
        return AnyCollection(curves)
    }
}

extension Path: Equatable {
    
    // MARK: - Equatable
    
    public static func == (lhs: Path, rhs: Path) -> Bool {
        return lhs.curves == rhs.curves
    }
}

extension Path: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return curves.map { "\($0)" }.joined(separator: "\n")
    }
}
