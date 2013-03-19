//
//  SSToolBarCell.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
    subclass this for each different tool item
 */

@interface SSToolBarCell : UITableViewCell
{
    NSNotificationCenter* center;
}
@property (retain) UIImage* iconImage;
@property (assign) CGRect ExpandedBounds;
@property (retain) UIView* otherView;
@property (assign) BOOL isExpanded;
@property (retain) NSArray* objects;
//@property (retain) UIImage* buttonEffect;
//@property (retain) UIImage* recessedButtonEffect;
-(void) deSelected: (id) object;

@end
