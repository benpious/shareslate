//
//  SSEraserView.h
//  ShareSlate
//
//  Created by Benjamin Pious on 4/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSEraserPreviewView.h"

@interface SSEraserViewController : UIViewController
@property (retain) IBOutlet UISlider* eraserSize;
@property (assign) NSNotificationCenter* center;
@property (retain) SSEraserPreviewView* previewView;
-(IBAction)eraserSizeChanged:(id)sender;
-(IBAction)editingStopped:(id)sender;
@end
