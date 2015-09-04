//
//  LGDragDropViewController.swift
//  LGDragDrop
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

import UIKit

class LGDragDropViewController: UIViewController {
    
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var dragHereLabel: UILabel!
    @IBOutlet weak var dragViewX: NSLayoutConstraint!
    @IBOutlet weak var dragViewY: NSLayoutConstraint!
    @IBOutlet weak var arrowCenterY: NSLayoutConstraint!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var initialDragViewY = 0.0
    var isGoalReached = false
    var lastBounds = CGRectZero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
