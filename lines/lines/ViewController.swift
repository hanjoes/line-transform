//
//  ViewController.swift
//  lines
//
//  Created by Hanzhou Shi on 3/11/16.
//  Copyright © 2016 Hanzhou Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private struct Constants {
        static let CanvasViewSize = CGSizeMake(200, 200)
    }
    
    // MARK: Outlets/Actions
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
            backView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(backView)
        switch gesture.state {
        case .Began, .Changed:
            canvasView.translateAnchorPoint(byTranslation: translation)
        default: break
        }
    }
    
    weak var canvasView: CanvasView!
    
    // MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        guard canvasView == nil else { return }
        
        let tmpView = CanvasView()
        backView.addSubview(tmpView)
        canvasView = tmpView
    }
    
    override func viewDidLayoutSubviews() {
        let size = Constants.CanvasViewSize,
        c = backView.convertPoint(backView.center, fromView: view),
        origin = CGPointMake(c.x - size.width / 2, c.y - size.height / 2),
        canvasFrame = CGRect(origin: origin, size: size)
        canvasView.frame = canvasFrame
    }
    
    // MARK: Properties
    
    // MARK: Methods

}
