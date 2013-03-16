//
//  SSToolBarContainer.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/16/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSVerticalToolBar.h"
#import "SSVersionInfoView.h"

@interface SSToolBarContainer : UIView
{
    NSNotificationCenter* center;
}
@property (retain) SSVerticalToolBar* toolBar;
@property (retain) SSVersionInfoView* versionView;
-(void) historySelected: (NSNotification*) note;

@end
