//
//  SSVerticalToolBar.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSToolBarCell.h"


typedef struct {
    CGFloat expandedHeight;
    UIViewController* expandedViewController;
    NSString* label;
    UIImage* backGroundImage;
    
} toolBarItem;

@interface SSVerticalToolBar : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *backImage;
    NSString* textLabel;
    int numItems;
    int selectedRow;
    toolBarItem* items;
    NSNotificationCenter* center;
    NSNotification* deselected;
    NSNotification* historySelected;
}

@property (retain) UIImage* backgroundImage;
@property (retain) UIImage* currImageToDraw;



@end
