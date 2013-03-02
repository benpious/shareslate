//
//  SSViewController.h
//  ShareSlate
//
//  Created by Benjamin Pious on 2/27/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintingView.h"
#import "SSNetworkingEngine.h"

@interface SSViewController : UIViewController
{
    NSNotificationCenter* notificationCenter;
    SSNetworkingEngine* networkingEngine;
}

@property  (retain) IBOutlet PaintingView* paintView;
@property (retain) NSString* ip;
@property (assign) int port;
-(void) propogatePaint: (NSNotification*) note;

@end
