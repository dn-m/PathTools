//
//  PathElement.swift
//  PathTools
//
//  Created by James Bean on 6/10/16.
//
//

import QuartzCore

public enum PathElement {
    case move(CGPoint)
    case line(CGPoint)
    case quadCurve(CGPoint, CGPoint)
    case curve(CGPoint, CGPoint, CGPoint)
    case close
}
