//
//  SSSettingsViewController.h
//  ShareSlate
//
//  Created by Benjamin Pious on 4/28/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSettingsViewController : UIViewController
-(void) expand;
-(IBAction)donePressed:(id)sender;
@property (assign) NSNotificationCenter* center;
@end
