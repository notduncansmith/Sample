//
//  ViewController.h
//  ColorMatcher
//
//  Created by Eric Stroh on 7/12/14.
//  Copyright (c) 2014 Eric Stroh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerDelegate <NSObject>

@required
- (void)pauseTimer;
- (void)restartTimer;

@end

@interface ViewController : UIViewController
@property(weak, nonatomic) id <ControllerDelegate>delegate;
@end

