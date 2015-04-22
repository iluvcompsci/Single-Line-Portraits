//
//  PlotPointsView.swift
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/22/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

import UIKit

class PlotPointsView: UIView {
    var points : [Node]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
//        plotPoints()
    }
    
    func plotPoints(){
        if(points != nil){
            for i  in 0..<points!.count {
                var ctx = UIGraphicsGetCurrentContext()
                CGContextAddEllipseInRect(ctx, CGRectMake(CGFloat(points![i].xCoordinate), CGFloat(points![i].yCoordinate), 5.0, 5.0))
                CGContextSetFillColor(ctx, CGColorGetComponents(UIColor.blueColor().CGColor))
                CGContextFillPath(ctx)
            }
        }
    }
}
