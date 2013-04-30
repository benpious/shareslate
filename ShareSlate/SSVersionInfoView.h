//
//  SSVersionInfoView.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/16/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSVersionInfoView : UIView <UITableViewDelegate, UITableViewDataSource>
@property(retain) UISearchBar* searchBar;
@property (retain) UITableView* versions;
@property (retain) UIButton* saveButton;
@property (retain) NSMutableArray* versionData;
-(void)addVersion: (NSNotification*) version;

@end
