//
//  SSVerticalToolBar.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSToolBarCell.h"
@interface SSVerticalToolBar : UITableView <UITableViewDataSource>
{
    UIImageView *backImage;
}
@property (retain) NSMutableArray* items;
@property (retain) UIImage* backgroundImage;


@end
