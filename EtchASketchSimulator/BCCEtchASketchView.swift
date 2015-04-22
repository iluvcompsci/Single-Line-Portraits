//
//  BCCEtchASketchView.swift
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/20/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

import UIKit
import CoreGraphics

class BCCEtchASketchView: UIView {
    
    var context : CGContext?
    var counter = 0
    var knobs : BCCEtchASketchViewController?
    var points : [Node]? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    
    override func drawRect(rect: CGRect) {
        if points != nil && counter + 1 < points!.count{
            context = UIGraphicsGetCurrentContext()
//            plotPoints(context!)
            CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor().CGColor)
            var from : Node = points![counter]
            var to : Node = points![++counter]
            animateLine(CGPointMake(CGFloat(from.xCoordinate), CGFloat(from.yCoordinate)), toPoint:CGPointMake(CGFloat(to.xCoordinate), CGFloat(to.yCoordinate)), context: context!)
        }
    }
    
    func calculateDuration(fromPoint: CGPoint, toPoint: CGPoint) -> NSTimeInterval{
        let euclidianDistance = sqrt(pow(fromPoint.x - toPoint.x, 2) + pow(fromPoint.y - toPoint.y, 2))
        return NSTimeInterval(euclidianDistance/90.0)
        
    }
    
    func animateLine(fromPoint: CGPoint, toPoint: CGPoint, context:CGContext){
        knobs!.rotateKnobs(fromPoint, toPoint: toPoint, duration: calculateDuration(fromPoint, toPoint: toPoint))
        
        let linePath : UIBezierPath = UIBezierPath()
        linePath.moveToPoint(fromPoint)
        linePath.addLineToPoint(toPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.CGPath
        lineLayer.strokeEnd = 0.0
        lineLayer.strokeColor = UIColor.darkGrayColor().CGColor
        lineLayer.lineWidth = 1.0
        layer.addSublayer(lineLayer)
        
//        println("counter: \(counter) drawing from \(fromPoint.x), \(fromPoint.y) to \(toPoint.x), \(toPoint.y)")
        
        // We want to animate the strokeEnd property of the layer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = calculateDuration(fromPoint, toPoint: toPoint)
        animation.beginTime = 0
        
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        lineLayer.strokeEnd = 1.0
        
        lineLayer.addAnimation(animation, forKey: "animateLine")
        
    }
    

    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if counter + 1 < points!.count {
            var from : Node = points![counter]
            var to : Node = points![++counter]
            animateLine(CGPointMake(CGFloat(from.xCoordinate), CGFloat(from.yCoordinate)), toPoint:CGPointMake(CGFloat(to.xCoordinate), CGFloat(to.yCoordinate)), context: context!)

//            animateLine(points[counter], toPoint: points[++counter], context: context!)
        }
    }
    

    
}
