//
//  SSEraserView.m
//  ShareSlate
//
//  Created by Benjamin Pious on 4/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSEraserViewController.h"

@implementation SSEraserViewController


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        //self.previewView = [[SSEraserPreviewView alloc] initWithFrame:self.view.bounds];
        //[self.view addSubview:self.previewView];
        //[self.view sendSubviewToBack:self.previewView];
        self.center = [NSNotificationCenter defaultCenter];

        
    }
    
    return self;
}
-(IBAction)eraserSizeChanged:(id)sender
{
    
    //CGRect trackRect =  [self.eraserSize thumbRectForBounds:[self.view bounds] trackRect:[self.eraserSize trackRectForBounds:[self.view bounds] ] value:self.eraserSize.value];
    
    //CGRect trackRect =  CGRectMake(1146/2, 764/2, self.eraserSize.value*100 , self.eraserSize.value*100);
    
    //trackRect.size.height = self.eraserSize.value * 100;
    //trackRect.size.width = self.eraserSize.value * 100;
    //trackRect.origin.x -= trackRect.size.width/2;
    //trackRect.origin.y -= trackRect.size.height/2;

    
    //self.previewView.rectToDraw = trackRect;
    //[self.previewView setNeedsDisplay];
    
    [self.center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: [NSNumber numberWithFloat: self.eraserSize.value]]];
    
}

-(IBAction)editingStopped:(id)sender
{
    [self.center postNotification: [NSNotification notificationWithName:@"brushSizeChangesEnded" object: nil]];

}

@end
