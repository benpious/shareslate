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
#import "SSVersionControlToolbarViewController.h"

@interface ToolBar : UIView

{
    
    CGPoint    origin_;
    
    UIToolbar*    Toolbar_;
    UIBarButtonItem *brushButton;
    
    UIViewController** PopupArray_;
    
    size_t prevSelectedIndex;
    
}



- (id) initWithOrigin:(CGPoint) origin;
- (void) selectBrush;
- (void) makeToolBar;
-(void) brushColorChanged: (NSNotification*) note;
-(void)revertToPreviousSelection: (NSNotification*) note;
-(void) historySelected: (NSNotification*)note;

@property(retain) UIPopoverController* versionControlPopOver;


@end