//
//  ConvexPolygonProtocol.swift
//  PathTools
//
//  Created by James Bean on 6/6/17.
//
//

import Collections

/// Adds semantic guarantee of convexity
public protocol ConvexPolygonProtocol: PolygonProtocol { }

extension ConvexPolygonProtocol {
    
    /// - Returns: `ConvexPolygonContainer` containing only this `ConvexPolygonProtocol`-
    /// conforming type.
    public var collisionDetectable: ConvexPolygonContainer {
        return ConvexPolygonContainer(self)
    }
}
