//
//  DrawView.swift
//  Eyeballing
//
//  Created by Afir Thes on 10.10.2022.
//

import UIKit

enum Shape {
    case circle
    case filledCircle
    case rectangle
    case filledRectangle
}

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi / 180
    }
}

class DrawView: UIView {
    
    var currentShape: Shape?

    override func draw(_ rect: CGRect) {
       
        guard   let currentContext = UIGraphicsGetCurrentContext(),
                let currentShape = currentShape else {
            
            print("Could not get context")
            return
        }
        
        switch currentShape {
            case .circle:
                drawCirclet(using: currentContext, isFilled: false)
            case .filledCircle:
                drawCirclet(using: currentContext, isFilled: true)
            case .rectangle:
                drawRectangle(using: currentContext, isFilled: false)
            case .filledRectangle:
                drawRectangle(using: currentContext, isFilled: true)
        }

    }
    
    
    func drawShape(selectedShape: Shape) {
        currentShape = selectedShape
        setNeedsDisplay()
    }
    
    private func drawCirclet(using context: CGContext, isFilled: Bool) {
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        context.addArc(center: centerPoint, radius: 150, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        context.setLineWidth(4.0)
        
        if isFilled {
            context.setFillColor(UIColor.blue.cgColor)
            context.fillPath()
        } else {
            context.setStrokeColor(UIColor.orange.cgColor)
            
            context.strokePath()
        }
    }
    
    private func drawRectangle(using context: CGContext, isFilled: Bool) {
        let strokeDistance: CGFloat = 60
        
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        let lowerLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y + strokeDistance)
        let lowerRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y + strokeDistance)
        let upperRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y - strokeDistance)
        let upperLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y - strokeDistance)
        
        context.move(to: lowerLeftCorner)
        context.addLine(to: lowerRightCorner)
        context.addLine(to: upperRightCorner)
        context.addLine(to: upperLeftCorner)
        context.addLine(to: lowerLeftCorner)
        
        context.setLineCap(.square)
        context.setLineWidth(4.0)
        
        if isFilled {
            context.setFillColor(UIColor.purple.cgColor)
            context.fillPath()
        } else {
            context.setStrokeColor(UIColor.red.cgColor)
            context.strokePath()
        }
    }
    
}
