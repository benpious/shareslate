//
//  SSVersionInfoView.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/16/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVersionInfoView.h"

@implementation SSVersionInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *background = [[UIView alloc] initWithFrame:self.bounds];
        [background setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBackground"]]];
        [self addSubview:background];
        [background release];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
