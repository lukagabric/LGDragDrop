//
//  ViewController.m
//  LGDragDrop
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import "ViewController.h"
#import "LGDragDropViewController.h"

@implementation ViewController

- (IBAction)showDragDropView:(id)sender {
    LGDragDropViewController *dragDropViewController = [LGDragDropViewController new];
    __weak id weakSelf = self;
    dragDropViewController.gestureCompletion = ^{
        ViewController *strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:dragDropViewController animated:YES completion:nil];
}

@end
