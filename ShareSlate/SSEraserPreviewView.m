//
//  SSEraserPreviewView.m
//  ShareSlate
//
//  Created by Benjamin Pious on 4/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSEraserPreviewView.h"

@implementation SSEraserPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.rectToDraw = CGRectMake(0.0, 0.0, 0.0, 0.0);
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.willDraw) {
        return;
    }
    
    // Drawing code
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //CGContextBeginPath(ref);
    
    //CGMutablePathRef pathRef = CGPathCreateMutable();
    //CGPathAddEllipseInRect(pathRef, NULL, trackRect);
    CGFloat len = 1.0;
    CGContextSetLineDash(ref, .5, &len , 0);
    CGContextStrokeEllipseInRect(ref, self.rectToDraw);
}


@end
