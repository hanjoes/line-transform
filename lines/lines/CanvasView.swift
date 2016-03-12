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
    weak var segment: CAShapeLayer!
    
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
    
    func translateAnchorPoint(byTranslation translation: CGPoint) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // transform anchor and segment separately, seems very redundent.
        // translate point
        let affineTransform = CGAffineTransformMakeTranslation(translation.x, translation.y)
        let layerTransform = CATransform3DMakeAffineTransform(affineTransform)
        pointB.transform = layerTransform
        
        // translate segment
        segment.anchorPoint = CGPointMake(0, 1)
        segment.position = pointA.position
        // get rotation
        let originalAngle = pointB.position.angle(toPoint: pointA.position)
        let transformedPointB = CGPointMake(pointB.position.x + translation.x, pointB.position.y + translation.y),
        transformedAngle = transformedPointB.angle(toPoint: pointA.position)
        
        let rotateAffineTransform = CGAffineTransformMakeRotation(transformedAngle - originalAngle)
        
        // get scale
        let originalLen = pointB.position.distance(toPoint: pointA.position),
        transformedLen = transformedPointB.distance(toPoint: pointA.position),
        scale = transformedLen / originalLen
        
        let scaleAffineTransform = CGAffineTransformMakeScale(scale, scale)
        
        // combine two transforms
        let combinedAffineTransform = CGAffineTransformConcat(rotateAffineTransform, scaleAffineTransform),
        segmentTransform = CATransform3DMakeAffineTransform(combinedAffineTransform)
        segment.transform = segmentTransform
        
        CATransaction.commit()
    }
    
    private func updateCanvasLayer() {
        guard canvasLayer != nil else { return }
        
        let padding = Constants.Padding,
        size = CGSizeMake(frame.width - padding, frame.width - padding),
        boundRect = CGRect(origin: CGPoint.zero, size: size),
        pos = convertPoint(center, fromView: superview)
        
        canvasLayer.bounds = boundRect
        canvasLayer.position = pos
        canvasLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        initializeSegment()
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
            layerB.strokeColor = UIColor.greenColor().CGColor
            canvasLayer.addSublayer(layerB)
            
            pointB = layerB
        }
    }
    
    private func initializeSegment() {
        // draw a segment from pointA's center to pointB's center
        let r = Constants.PointRadius
        let layerBounds = canvasLayer.bounds
        
        let bezierPath = UIBezierPath()
        let xa = layerBounds.minX,
        ya = layerBounds.maxY - 2 * r,
        originA = CGPointMake(xa, ya)
        bezierPath.moveToPoint(originA)
        
        let xb = layerBounds.maxX - 2 * r,
        yb = layerBounds.minY,
        originB = CGPointMake(xb, yb)
        bezierPath.addLineToPoint(originB)
        
        let boundingBox = CGPathGetBoundingBox(bezierPath.CGPath)
        
        let segmentLayer = CAShapeLayer()
        segmentLayer.bounds = boundingBox
        segmentLayer.position = CGPointMake(canvasLayer.bounds.midX, canvasLayer.bounds.midY)
        segmentLayer.path = bezierPath.CGPath
        segmentLayer.strokeColor = UIColor.redColor().CGColor
        segmentLayer.backgroundColor = UIColor.yellowColor().CGColor
        segmentLayer.opacity = 0.3
        canvasLayer.addSublayer(segmentLayer)
        
        segment = segmentLayer
    }
    
}

extension CGPoint {
    func distance(toPoint point: CGPoint) -> CGFloat {
        return sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y))
    }
    
    func angle(toPoint point: CGPoint) -> CGFloat {
        let sinVal = (y - point.y) / distance(toPoint: point)
        
        return asin(sinVal)
    }
}