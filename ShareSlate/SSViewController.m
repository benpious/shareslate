//
//  SSViewController.m
//  ShareSlate
//
//  Created by Benjamin Pious on 2/27/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()
#define kPaletteSize			5

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdid load for ssviewcontroller");
	// Do any additional setup after loading the view, typically from a nib.
    networkingEngine = [[SSNetworkingEngine alloc] initWithHostName:self.ip port:self.port];
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"propogatePaint:") name:@"serverData" object:nil];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"sendPaint:") name:@"drawingEvent" object:nil];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.slideController = [[DVSlideViewController alloc] init];
    [self.canvasView addSubview:self.slideController.view];
    [self.canvasView bringSubviewToFront:self.slideController.view];
    //[self.slideController.view setBounds:self.canvasView.bounds];
    //[self.slideController.view setFrame:self.canvasView.frame];
    [self.slideController setUp];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendPaint: (NSNotification*) note
{
    NSString* coordData = [note object];
    [networkingEngine sendMessage:coordData];
}

-(void) propogatePaint: (NSNotification*) note
{
    NSLog(@"paint method entered");
    
    NSString* coordData = [note object];
    NSArray* strokes = [coordData componentsSeparatedByString:@"b:"];
    
    for (NSString* stroke in strokes) {

        NSArray* coords = [stroke componentsSeparatedByString:@":"];
        if ([coords count]<4) {
            continue;
        }
        
        NSLog(@"(%@,%@,%@,%@)",[coords objectAtIndex:0],[coords objectAtIndex:1],[coords objectAtIndex:2],[coords objectAtIndex:3] );
        [self.paintView renderLineFromPoint: CGPointMake([[coords objectAtIndex:0] floatValue], [[coords objectAtIndex:1] floatValue]) toPoint: CGPointMake([[coords objectAtIndex:2] floatValue], [[coords objectAtIndex:3] floatValue])];


    }
}



@end
