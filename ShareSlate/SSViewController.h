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
#import "SSVerticalToolBar.h"
#import "DVSlideViewController.h"

@interface SSViewController : UIViewController
{
    NSNotificationCenter* notificationCenter;
    SSNetworkingEngine* networkingEngine;
}

@property (retain) PaintingView* paintView;
@property (retain) NSString* ip;
@property (assign) int port;
@property (retain) IBOutlet UIView* canvasView;
@property (retain) IBOutlet SSVerticalToolBar* tools;
@property (retain) DVSlideViewController* slideController;

-(void) propogatePaint: (NSNotification*) note;
-(void) versionControlEvent: (NSNotification*) note;

@end
