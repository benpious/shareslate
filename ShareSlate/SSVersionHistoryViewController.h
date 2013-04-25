//
//  SSVersionHistoryViewController.h
//  ShareSlate
//
//  Created by Benjamin Pious on 4/25/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSVersionHistoryViewController : UIViewController
-(id) initWithArray: (NSArray*) viewControllerArray;
-(void) historySelected;
-(void) setUpViewControllers;

@end
