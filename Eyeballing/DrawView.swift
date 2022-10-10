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
    var bezierPath: CGPath!
    
    var exampleLineWidth: CGFloat = 300
    
    var textLayer: CATextLayer!
    
    var answerLayer: CAShapeLayer!
    var answerAngle: CGFloat = 45

    var answerX1: CGFloat = 0
    var answerX2: CGFloat = 0
    
    var startAnswerX1: CGFloat = 0
    var startAnswerX2: CGFloat = 0
    
    var answerLineWidth: CGFloat {
        return answerX2 - answerX1
    }
    
    var xPos: CGFloat = 0
    var yPos: CGFloat = 0
    
    private var tickleStartLocation: CGPoint = .zero
    private var tickleStartLocationInitialSpace: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        answerLayer = CAShapeLayer()
        
        answerLayer.path = buidAnswerPath(reposition: true)
        answerLayer.strokeColor = UIColor.blue.cgColor
        answerLayer.lineWidth = 3.0
        
        self.layer.addSublayer(answerLayer)
        
        textLayer = CATextLayer()
        textLayer.string = ""
        textLayer.frame = CGRect(x: 20, y: bounds.height - 30, width: 250, height: 80)
        textLayer.fontSize = 18
        textLayer.font = UIFont.systemFont(ofSize: 18)
        textLayer.foregroundColor = UIColor.white.cgColor
        self.layer.addSublayer(textLayer)
        
        randomiseExampleLine()
    }
    
    func showText(text: String) {
        textLayer.string = text
    }
    
    func hideText() {
        textLayer.string = ""
    }
    
    
    func buidAnswerPath(reposition: Bool) -> CGPath {
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let answerPath = UIBezierPath()
        
        answerPath.move(to: CGPoint(x: answerX1, y: 0))
        answerPath.addLine(to: CGPoint(x: answerX2, y: 0))
        
        //        let circlePath = UIBezierPath()
        //        circlePath.move(to: .zero)
        //        circlePath.addArc(withCenter: .zero, radius: 50, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        
        let rotate = CGAffineTransform(rotationAngle: answerAngle.degreesToRadians)
        answerPath.apply(rotate)
        
        
        let width = answerPath.bounds.width
        let height = answerPath.bounds.height
        
        if reposition {
            xPos = CGFloat.random( in: (10+width/2)...(bounds.size.width-(10+width/2)) )
            yPos = CGFloat.random( in: (40+height/2)...(bounds.size.height-(10+height/2)) )
        }
        
        let moveit = CGAffineTransform(translationX: xPos, y: yPos)
        answerPath.apply(moveit)
        return answerPath.cgPath
        
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.move(to: CGPoint(x: 20, y: 30))
        context.addLine(to: CGPoint(x: 20 + exampleLineWidth, y: 30))
        context.setLineWidth(2.8)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.strokePath()
        
    }
    
    
    func drawShape(selectedShape: Shape) {
        currentShape = selectedShape
        setNeedsDisplay()
    }
    
    func randomiseExampleLine() {
        exampleLineWidth = CGFloat.random(in: 100...(bounds.width - 40)).rounded(.toNearestOrAwayFromZero)
        exampleLineWidth = exampleLineWidth - exampleLineWidth.remainder(dividingBy: 16)
        
        
        var answerLength = exampleLineWidth + CGFloat.random(in: -100...100).rounded(.toNearestOrAwayFromZero)
        answerLength = answerLength - answerLength.remainder(dividingBy: 16)
        
        answerX1 = answerLength / -2
        answerX2 = answerLength / 2
        
        answerAngle = CGFloat.random(in: -180...0)
        answerLayer.path = buidAnswerPath(reposition: true)
        setNeedsDisplay()
    }

    
    func getRandomColor() -> UIColor {
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        return UIColor(red: Double(randomRed), green: Double(randomGreen), blue: Double(randomBlue), alpha: 1.0)
    }
    
    
    private func drawCirclet(using context: CGContext, isFilled: Bool) {
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        context.addArc(center: centerPoint, radius: 150, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        context.setLineWidth(3.0)
        
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
        context.setLineWidth(3.0)
        
        if isFilled {
            context.setFillColor(UIColor.purple.cgColor)
            context.fillPath()
        } else {
            context.setStrokeColor(UIColor.red.cgColor)
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        tickleStartLocation = touch.location(in: self)
        //        print(tickleStartLocation)
        
        //        let inside = bezierPath.contains(tickleStartLocation)
        //        print(inside)
        
        
        let backpoint = CGPoint(x: tickleStartLocation.x, y: tickleStartLocation.y)
        let movedback = backpoint.applying(CGAffineTransform(translationX: -xPos, y: -yPos))
        let rotateback = movedback.applying(CGAffineTransform(rotationAngle: -answerAngle.degreesToRadians))
        
        
        tickleStartLocationInitialSpace = rotateback
        
        startAnswerX1 = answerX1
        startAnswerX2 = answerX2
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let tickleLocation = touch.location(in: self)
        
        let horizontalDiff = tickleLocation.x - tickleStartLocation.x
        let verticalDiff = tickleLocation.y - tickleStartLocation.y
        
        //        print("xdiff \(horizontalDiff) ydiff \(verticalDiff)")
        
        let backpoint = CGPoint(x: tickleLocation.x, y: tickleLocation.y)
        let movedback = backpoint.applying(CGAffineTransform(translationX: -xPos, y: -yPos))
        let rotateback = movedback.applying(CGAffineTransform(rotationAngle: -answerAngle.degreesToRadians))
        
        var dx =  rotateback.x - tickleStartLocationInitialSpace.x
        
        
        if (tickleStartLocationInitialSpace.x > 0 && rotateback.x < 0) ||
           (tickleStartLocationInitialSpace.x < 0 && rotateback.x > 0)
        {
            return
        }
        
//        print("started at = \(tickleStartLocationInitialSpace.x)")
//        print("dx = \(dx)")
        
        dx = dx - dx.remainder(dividingBy: 8)
        
        if tickleStartLocationInitialSpace.x > 0 {
            answerX2 = (startAnswerX2 + dx).rounded(.toNearestOrAwayFromZero)
        } else {
            answerX1 = (startAnswerX1 + dx).rounded(.toNearestOrAwayFromZero)
        }
            
        answerLayer.path = buidAnswerPath(reposition: false)
        setNeedsDisplay()
        
    }
    
    func decrement() {
        answerX1 += 8
        answerLayer.path = buidAnswerPath(reposition: false)
        setNeedsDisplay()
    }
    
    func increment() {
        answerX1 -= 8
        answerLayer.path = buidAnswerPath(reposition: false)
        setNeedsDisplay()
    }

    
}
