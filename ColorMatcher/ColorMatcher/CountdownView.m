//
//  CountdownView.m
//  ColorMatcher
//
//  Created by Eric Stroh on 7/12/14.
//  Copyright (c) 2014 Eric Stroh. All rights reserved.
//

#import "CountdownView.h"


@implementation CountdownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeLabel =[[UILabel alloc] initWithFrame:self.frame];
        [self addSubview:_timeLabel];
    }
    return self;
}



@end
