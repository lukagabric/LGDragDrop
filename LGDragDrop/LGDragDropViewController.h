//
//  LGDragDropViewController.m
//  LGDragDrop
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)();

@interface LGDragDropViewController : UIViewController

@property (copy, nonatomic) CompletionBlock gestureCompletion;

@end
