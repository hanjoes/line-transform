//
//  CanvasView.swift
//  lines
//
//  Created by Hanzhou Shi on 3/11/16.
//  Copyright © 2016 Hanzhou Shi. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    private struct Constants {
        static let Padding: CGFloat = 5
        static let BackgroundColor = UIColor.blueColor()
        static let PointRadius: CGFloat = 10
    }
    
    // MARK: Initializers
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = Constants.BackgroundColor
        
        let tmpLayer = CAShapeLayer()
        layer.addSublayer(tmpLayer)
        canvasLayer = tmpLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    weak var pointA: CAShapeLayer!
    weak var pointB: CAShapeLayer!
    
    weak var canvasLayer: CAShapeLayer! {
        didSet {
            updateCanvasLayer()
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateCanvasLayer()
        }
    }
    
    
    // MARK: Methods
    
    private func updateCanvasLayer() {
        guard canvasLayer != nil else { return }
        
        let padding = Constants.Padding,
        size = CGSizeMake(frame.width - padding, frame.width - padding),
        boundRect = CGRect(origin: CGPoint.zero, size: size),
        pos = convertPoint(center, fromView: superview)
        
        canvasLayer.bounds = boundRect
        canvasLayer.position = pos
        canvasLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        initializeAnchors()
    }
    
    private func initializeAnchors() {
        // now that we have correctly setup the canvas we need to initialize
        // the sublayers that contains the anchors.
        let r = Constants.PointRadius
        let viewSize = CGSizeMake(2 * r, 2 * r)
        let layerBounds = canvasLayer.bounds
        if pointA == nil {
            let xa = layerBounds.minX,
            ya = layerBounds.maxY - 2 * r,
            originA = CGPointMake(xa, ya),
            boundsA = CGRect(origin: originA, size: viewSize)
            
            let pathA = UIBezierPath(ovalInRect: boundsA)
            
            let layerA = CAShapeLayer()
            layerA.bounds = boundsA
            layerA.position = CGPointMake(xa + r, ya + r)
            layerA.path = pathA.CGPath
            layerA.strokeColor = UIColor.blackColor().CGColor
            layerA.opacity = 0.5
            canvasLayer.addSublayer(layerA)
            
            pointA = layerA
        }
        
        if pointB == nil {
            let xb = layerBounds.maxX - 2 * r,
            yb = layerBounds.minY,
            originB = CGPointMake(xb, yb),
            boundsB = CGRect(origin: originB, size: viewSize)
            
            let pathB = UIBezierPath(ovalInRect: boundsB)
            
            let layerB = CAShapeLayer()
            layerB.bounds = boundsB
            layerB.position = CGPointMake(xb + r, yb + r)
            layerB.path = pathB.CGPath
            layerB.strokeColor = UIColor.blackColor().CGColor
            layerB.opacity = 0.5
            canvasLayer.addSublayer(layerB)
            
            pointA = layerB
        }
    }
    
}
