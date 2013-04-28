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
    networkingEngine = [[SSNetworkingEngine alloc] initWithHostName:self.ip port:self.port];
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"propogatePaint:") name:@"serverData" object:nil];
    [notificationCenter addObserver:self selector: NSSelectorFromString(@"sendPaint:") name:@"drawingEvent" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"sendImage:") name:@"imageDrawingEvent" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"versionSelected:") name:@"viewSelected" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"versionControlOpened:") name:@"historySelected" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"imageSelected:") name:@"imageSelected" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"brushSelected:") name:@"brushSelected" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"colorChanged:") name:@"colorChanged" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"setBrushSize:") name:@"brushSizeChanged" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"brushSizeChangesEnded:") name:@"brushSizeChangesEnded" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"settingsSelected:") name:@"settingsSelected" object:nil];
    [notificationCenter addObserver:self selector:NSSelectorFromString(@"settingsDismissed:") name:@"settingsDismissed" object:nil];



}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.paintView = [[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 1024-50, 768)];
    [self.canvasView addSubview: self.paintView];
    [self.paintView setBrushColorWithRed:0.0f green:0.0f blue:0.0f];
    self.brushSizePreview = [[SSEraserPreviewView alloc] initWithFrame: self.view.bounds];
    [self.view addSubview: self.brushSizePreview];
    self.settingsController = [[SSSettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendPaint: (NSNotification*) note
{
    //NSString* coordData = [note object];
    //NSLog(@"sendpaint called");
    //placeholders for color and linesize
    NSDictionary* brushData = @{@"type": @"brushStroke", @"color" : @0.0, @"positions" : [note object], @"lineSize" : @0.0};
    NSDictionary* toSend = @{@"type": @"add", @"data": @[brushData]};
    
    [networkingEngine sendMessage: toSend];
}

#pragma mark notification center methods

-(void) colorChanged: (NSNotification*) note
{
    UIColor* color = (UIColor*)(note.object);
    const float* colors = CGColorGetComponents( color.CGColor );
    [self.paintView setBrushColorWithRed:colors[0] green:colors[1] blue:colors[2]];
}

-(void) propogatePaint: (NSNotification*) note
{
    NSLog(@"propogate paint");
    /*
    NSString* coordData = [note object];
    NSArray* strokes = [coordData componentsSeparatedByString:@"C"];
    
    for (NSString* stroke in strokes) {

        NSArray* coords = [stroke componentsSeparatedByString:@":"];
        
        if ([coords count] < 1) {
            return;
        }
        
        if ([[coords objectAtIndex:0] isEqual: @"b"]) {
            //NSLog(@"(%@,%@,%@,%@)",[coords objectAtIndex:0],[coords objectAtIndex:1],[coords objectAtIndex:2],[coords objectAtIndex:3] );
            [self.paintView renderLineFromPoint: CGPointMake([[coords objectAtIndex:1] floatValue], [[coords objectAtIndex:2] floatValue]) toPoint: CGPointMake([[coords objectAtIndex:3] floatValue], [[coords objectAtIndex:4] floatValue])];
        }
        
        if ([[coords objectAtIndex:0] isEqual: @"i"]) {
            [self.paintView renderImageFrom:CGPointMake([[coords objectAtIndex:1] floatValue], [[coords objectAtIndex:2] floatValue])];
        }
        
    }
     */
    
    NSDictionary* data = [note object];
    NSString* type = [data objectForKey:@"type"];
    
    if ([type isEqual: @"add"]) {
        NSArray* shapeData = [data objectForKey:@"data"];
        for (NSDictionary* currShape in shapeData) {
            if ([[currShape objectForKey:@"type"] isEqual:@"brushStroke"]) {
                NSArray* coords = [currShape objectForKey: @"positions"];
                [self.paintView renderLineFromPoint: CGPointMake([[coords objectAtIndex:1] floatValue], [[coords objectAtIndex:2] floatValue]) toPoint: CGPointMake([[coords objectAtIndex:3] floatValue], [[coords objectAtIndex:4] floatValue])];
            }
        }
    }
    
}

-(void) setBrushSize: (NSNotification*) note
{
    [self.paintView setPointSize:[(NSNumber*)(note.object) floatValue]*300];
    
    self.brushSizePreview.rectToDraw = CGRectMake(self.view.frame.size.width/2 + [(NSNumber*)(note.object) floatValue]*50, self.view.frame.size.height/2 -[(NSNumber*)(note.object) floatValue]*50, [(NSNumber*)(note.object) floatValue]*100, [(NSNumber*)(note.object) floatValue]*100);
    self.brushSizePreview.willDraw = YES;
    [self.brushSizePreview setNeedsDisplay];
    
}

-(void) sendImage: (NSNotification*) note
{
    //NSString* coordData = [note object];
    //[networkingEngine sendMessage: coordData];
}


-(void) brushSelected:(NSNotification *)note
{
    self.paintView.drawingImages = NO;
}

-(void) versionSelected: (NSNotification*) note
{
    [self.paintView revertToIndex: (NSNumber*)note.object];
    [self.historyController removeFromParentViewController];
    [self.canvasView addSubview:self.paintView];
    [self.canvasView bringSubviewToFront:self.paintView];
    self.paintView.isActive = YES;
    [self.historyController release];
    [notificationCenter postNotification: [NSNotification notificationWithName:@"revertToOldSelection" object:nil]];
}

-(void) brushSizeChangesEnded: (NSNotification*) note
{
    self.brushSizePreview.willDraw = NO;
}

-(void) versionControlOpened: (NSNotification*) note
{
    NSMutableArray* versionPreviews =  [self.paintView makeVersionPreviews];
    self.historyController = [[SSVersionHistoryViewController alloc] initWithArray:versionPreviews];
    [self.historyController.view setFrame:CGRectMake(172, 0, 1024-172, 768)];
    [self.historyController setUpViewControllers];
    [self.paintView removeFromSuperview];
    [self.canvasView addSubview:self.historyController.view];
    [self.canvasView bringSubviewToFront:self.historyController.view];
    [self.historyController historySelected];
}

-(void) settingsSelected: (NSNotification*) note
{
    [self.view addSubview: self.settingsController.view];
    [self.view bringSubviewToFront:self.settingsController.view];
    [self.settingsController expand];
}

-(void) settingsDismissed: (NSNotification*) note
{
    [self.settingsController.view removeFromSuperview];
    [notificationCenter postNotification: [NSNotification notificationWithName:@"revertToOldSelection" object:nil]];

}

#pragma mark camera methods

-(void) imageSelected: (NSNotification*) note
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
    self.paintView.drawingImages = YES;
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
    
    [popOverController presentPopoverFromRect: CGRectMake(0, (750/11)*8+10, 50, 50)  inView: self.container permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
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
    
    
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:NULL];
    [picker release];
}


@end
