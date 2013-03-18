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
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO]; //deprecated
	// Do any additional setup after loading the view, typically from a nib.
    networkingEngine = [[SSNetworkingEngine alloc] initWithHostName:self.ip port:self.port];
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"propogatePaint:") name:@"serverData" object:nil];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"sendPaint:") name:@"drawingEvent" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"versionControlOpened:") name:@"versionControlEvent" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"imageSelected:") name:@"imageSelected" object:nil];



}

-(void)viewDidAppear:(BOOL)animated
{
    self.slideController = [[DVSlideViewController alloc] init];
    [self.canvasView addSubview:self.slideController.view];
    [self.canvasView bringSubviewToFront:self.slideController.view];
    //[self.slideController.view setBounds:self.canvasView.bounds];
    //[self.slideController.view setFrame:self.canvasView.frame];
    [self.slideController setUp];
    self.paintView = (PaintingView*)((UIViewController*)[self.slideController.viewControllers objectAtIndex:self.slideController.selectedIndex]).view;
    [self.paintView setBrushColorWithRed:0.1f green:0.1f blue:0.1f];

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

-(void) versionControlEvent: (NSNotification*) note
{
    self.slideController.isActive = !(self.slideController.isActive);
}

#pragma mark camera methods

-(void) imageSelected: (NSNotification*) note
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}


- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: mediaUI];
    [popOverController presentPopoverFromRect: CGRectMake(100, (768/4) *3, 50, 50)  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    return YES;
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
        
        self.paintView.imageToDraw = imageToUse;
    }
    
    
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:NULL];
    [picker release];
}



@end
