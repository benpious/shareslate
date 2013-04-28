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
#import <MobileCoreServices/UTCoreTypes.h>
#import "SSToolBarContainer.h"
#import "SSEraserPreviewView.h"
#import "SSVersionHistoryViewController.h"
#import "SSSettingsViewController.h"

@interface SSViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSNotificationCenter* notificationCenter;
    SSNetworkingEngine* networkingEngine;
}

@property (retain) PaintingView* paintView;
@property (retain) NSString* ip;
@property (assign) int port;
@property (retain) IBOutlet UIView* canvasView;
@property (retain) IBOutlet SSToolBarContainer* container;
@property (retain) SSVersionHistoryViewController* historyController;
@property (retain) SSEraserPreviewView* brushSizePreview;
@property (retain) SSSettingsViewController* settingsController;

-(void) propogatePaint: (NSNotification*) note;
-(void) imageSelected: (NSNotification*) note;
-(void) brushSelected: (NSNotification*) note;
-(void) colorChanged: (NSNotification*) note;
-(void) setBrushSize: (NSNotification*) note;
-(void) brushSizeChangesEnded: (NSNotification*) note;
-(void) versionSelected: (NSNotification*) note;
-(void) settingsSelected: (NSNotification*) note;
-(void) settingsDismissed: (NSNotification*) note;
@end
