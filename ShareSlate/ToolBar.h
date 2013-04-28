//
//  ToolBar.h
//  ShareSlate
//
//  Created by Won Gu Kang on 4/3/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPViewController.h"
#import "SSEraserViewController.h"

@interface ToolBar : UIView

{
    
    CGPoint    origin_;
    
    UISegmentedControl*    SegmentedControl_;
    
    NSArray*    SegmentImageArray_;
    
    UIViewController** SegmentPopupArray_;
    
    size_t prevSelectedIndex;
    
}



- (id) initWithOrigin:(CGPoint) origin;

- (void) makeToolBar;
-(void)revertToPreviousSelection: (NSNotification*) note;


@end