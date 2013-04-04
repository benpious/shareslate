//
//  SSToolBarContainer.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/16/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSToolBarContainer.h"

@implementation SSToolBarContainer

-(void) awakeFromNib
{
    //self.toolBar = [[SSVerticalToolBar alloc] initWithFrame: CGRectMake(0.0, 0.0, 222.0f, 768.f)];
    self.toolBar = [[ToolBar alloc] initWithOrigin: CGPointMake(0, 20)];
    [self addSubview:self.toolBar];
    [self bringSubviewToFront:self.toolBar];
    self.versionView = [[SSVersionInfoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 222.0f, 768.f)];
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:NSSelectorFromString(@"historySelected:") name:@"historySelected" object:nil];
    [center addObserver:self selector:NSSelectorFromString(@"historySelected:") name:@"viewSelected" object:nil];
    
}

-(void) historySelected: (NSNotification*) note
{
    [self flipViews];
}

-(void)flipViews
{
    if ([self.toolBar superview])
    {
        [UIView transitionFromView:self.toolBar toView:self.versionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    }
    else
    {
        [UIView transitionFromView:self.versionView toView:self.toolBar duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    }
    
    [UIView commitAnimations];
}



@end
