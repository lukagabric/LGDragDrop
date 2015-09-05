//
//  LGDragDropViewController.m
//  LGDragDrop
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import "LGDragDropViewController.h"

#define DRAG_AREA_PADDING 5

@interface LGDragDropViewController ()

@property (weak, nonatomic) IBOutlet UIView *dragAreaView;
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UIView *goalView;
@property (weak, nonatomic) IBOutlet UILabel *dragHereLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dragViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dragViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowCenterY;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) CGFloat initialDragViewY;
@property (readonly, nonatomic) BOOL isGoalReached;
@property (assign, nonatomic) CGRect lastBounds;

@end

@implementation LGDragDropViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastBounds = self.view.bounds;
    
    self.dragView.layer.cornerRadius = self.dragView.bounds.size.height / 2;

    self.goalView.layer.cornerRadius = self.goalView.bounds.size.height / 2;
    self.goalView.layer.borderWidth = 4;
    
    self.initialDragViewY = self.dragViewY.constant;
    
    [self updateGoalView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.view.bounds, self.lastBounds)) {
        [self boundsChanged];
        self.lastBounds = self.view.bounds;
    }
}

- (void)boundsChanged {
    [self returnToStartLocationAnimated:NO];
    
    [self.dragAreaView bringSubviewToFront:self.dragView];
    [self.dragAreaView bringSubviewToFront:self.goalView];
    
    [self.view layoutIfNeeded];
    self.arrowCenterY.constant = (CGRectGetMinY(self.goalView.frame) + CGRectGetMaxY(self.dragView.frame)) / 2;
}

#pragma mark - Actions

- (IBAction)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)panAction {
    if (self.panGesture.state == UIGestureRecognizerStateChanged) {
        [self moveObject];
    }
    else if (self.panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.isGoalReached) {
            if (self.completion) {
                self.completion();
            }
        }
        else {
            [self returnToStartLocationAnimated:YES];
        }
    }
}

#pragma mark - UI updates

- (void)moveObject {
    CGFloat minX = DRAG_AREA_PADDING;
    CGFloat maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - DRAG_AREA_PADDING;
    
    CGFloat minY = DRAG_AREA_PADDING;
    CGFloat maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - DRAG_AREA_PADDING;
    
    CGPoint translation = [self.panGesture translationInView:self.dragAreaView];
    
    CGFloat dragViewX = self.dragViewX.constant + translation.x;
    CGFloat dragViewY = self.dragViewY.constant + translation.y;
    
    if (dragViewX < minX) {
        dragViewX = minX;
        translation.x += self.dragViewX.constant - minX;
    }
    else if (dragViewX > maxX) {
        dragViewX = maxX;
        translation.x += self.dragViewX.constant - maxX;
    }
    else {
        translation.x = 0;
    }
    
    if (dragViewY < minY) {
        dragViewY = minY;
        translation.y += self.dragViewY.constant - minY;
    }
    else if (dragViewY > maxY) {
        dragViewY = maxY;
        translation.y += self.dragViewY.constant - maxY;
    }
    else {
        translation.y = 0;
    }
    
    self.dragViewX.constant = dragViewX;
    self.dragViewY.constant = dragViewY;
    
    [self.panGesture setTranslation:translation inView:self.dragAreaView];
    
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self updateGoalView];
}

- (void)updateGoalView {
    UIColor *goalColor = self.isGoalReached ? [UIColor whiteColor] : [UIColor colorWithRed:174/255.0 green:0 blue:0 alpha:1];
    
    self.goalView.layer.borderColor = goalColor.CGColor;
    
    self.dragHereLabel.textColor = goalColor;
    self.dragHereLabel.text = self.isGoalReached ? @"Drop!" : @"Drag here!";
}

- (void)returnToStartLocationAnimated:(BOOL)animated {
    self.dragViewX.constant = (self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width) / 2;
    self.dragViewY.constant = self.initialDragViewY;

    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

#pragma mark - Getters

- (BOOL)isGoalReached {
    CGFloat distanceFromGoal = sqrt(pow(self.dragView.center.x - self.goalView.center.x, 2) + pow(self.dragView.center.y - self.goalView.center.y, 2));
    return distanceFromGoal < self.dragView.bounds.size.width / 2;
}

#pragma mark -

@end
