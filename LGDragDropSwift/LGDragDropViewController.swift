//
//  LGDragDropViewController.swift
//  LGDragDrop
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

import UIKit

class LGDragDropViewController: UIViewController {
    
    // MARK: Vars
    
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var dragHereLabel: UILabel!
    @IBOutlet weak var dragViewX: NSLayoutConstraint!
    @IBOutlet weak var dragViewY: NSLayoutConstraint!
    @IBOutlet weak var arrowCenterY: NSLayoutConstraint!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    var initialDragViewY: CGFloat = 0.0
    var isGoalReached: Bool {
        get {
            let distanceFromGoal: CGFloat = sqrt(pow(self.dragView.center.x - self.goalView.center.x, 2) + pow(self.dragView.center.y - self.goalView.center.y, 2))
            return distanceFromGoal < self.dragView.bounds.size.width / 2
        }
    }
    let dragAreaPadding = 5
    var lastBounds = CGRectZero
    
    var completion: (() -> ())?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lastBounds = self.view.bounds
        
        self.dragView.layer.cornerRadius = self.dragView.bounds.size.height / 2
        
        self.goalView.layer.cornerRadius = self.goalView.bounds.size.height / 2
        self.goalView.layer.borderWidth = 4
        
        self.initialDragViewY = self.dragViewY.constant;
        
        self.updateGoalView();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !CGRectEqualToRect(self.view.bounds, self.lastBounds) {
            self.boundsChanged()
            self.lastBounds = self.view.bounds
        }
    }
    
    func boundsChanged() {
        self.returnToStartLocationAnimated(false)
        
        self.dragAreaView.bringSubviewToFront(self.dragView)
        self.dragAreaView.bringSubviewToFront(self.goalView)
        
        self.view.layoutIfNeeded()
        self.arrowCenterY.constant = (CGRectGetMinY(self.goalView.frame) + CGRectGetMaxY(self.dragView.frame)) / 2
    }
    
    // MARK: Actions
    
    @IBAction func dismissAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func panAction() {
        if self.panGesture.state == .Changed {
            self.moveObject();
        }
        else if self.panGesture.state == .Ended {
            if self.isGoalReached {
                if let completion = self.completion {
                    completion()
                }
            }
            else {
                self.returnToStartLocationAnimated(true)
            }
        }
    }
    
    // MARK: UI Updates

    func moveObject() {
        let minX = CGFloat(self.dragAreaPadding)
        let maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - minX
        
        let minY = CGFloat(self.dragAreaPadding)
        let maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - minY
        
        var translation =  self.panGesture.translationInView(self.dragAreaView)
        
        var dragViewX = self.dragViewX.constant + translation.x
        var dragViewY = self.dragViewY.constant + translation.y
        
        if dragViewX < minX {
            dragViewX = minX
            translation.x += self.dragViewX.constant - minX
        }
        else if dragViewX > maxX {
            dragViewX = maxX
            translation.x += self.dragViewX.constant - maxX
        }
        else {
            translation.x = 0
        }
        
        if dragViewY < minY {
            dragViewY = minY
            translation.y += self.dragViewY.constant - minY
        }
        else if dragViewY > maxY {
            dragViewY = maxY
            translation.y += self.dragViewY.constant - maxY
        }
        else {
            translation.y = 0
        }
        
        self.dragViewX.constant = dragViewX
        self.dragViewY.constant = dragViewY
        
        self.panGesture.setTranslation(translation, inView: self.dragAreaView)
        
        UIView.animateWithDuration(
            0.05,
            delay: 0,
            options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            },
            completion: nil)
        
        self.updateGoalView();
    }
    
    func updateGoalView() {
        let goalColor = self.isGoalReached ? UIColor.whiteColor() : UIColor(red: 174/255.0, green: 0, blue: 0, alpha: 1)
        
        self.goalView.layer.borderColor = goalColor.CGColor
        
        self.dragHereLabel.textColor = goalColor
        self.dragHereLabel.text = self.isGoalReached ? "Drop!" : "Drag here!"
    }
    
    func returnToStartLocationAnimated(animated: Bool) {
        self.dragViewX.constant = (self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width) / 2
        self.dragViewY.constant = self.initialDragViewY
        
        if (animated) {
            UIView.animateWithDuration(
                0.3,
                delay: 0,
                options: .BeginFromCurrentState,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                },
                completion: nil)
        }
    }
    
}
