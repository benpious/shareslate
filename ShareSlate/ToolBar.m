//
//  ToolBar.m
//  ShareSlate
//
//  Created by Won Gu Kang on 4/3/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "ToolBar.h"

@implementation ToolBar



- (id) initWithOrigin:(CGPoint) origin

{
    
    self = [super init];
    
    if (self)
        
    {
        
        // This set the position where you want to display the toolbar
        
        origin = origin;
        
        self.frame = CGRectMake(0, 0, 40, 768);
        
        // this will create the toolbar
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"revertToPreviousSelection:") name:@"revertToOldSelection" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"historySelected:") name:@"historySelected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"brushColorChanged:") name:@"brushColorChanged" object:nil];

        
        [self  makeToolBar];
        [self makePopups];
        
    }
    
    return self;
    
}

- (void) makeToolBar

{
    UIImage* brush = [UIImage imageNamed:@"187-pencil.png"];
    UIImage* eraser = [UIImage imageNamed:@"eraser.png"];
    UIImage* image = [UIImage imageNamed:@"121-landscape.png"];
    UIImage* history = [UIImage imageNamed:@"78-stopwatch.png"];
    UIImage* settings = [UIImage imageNamed:@"20-gear2.png"];
    UIImage* undo = [UIImage imageNamed:@"arrow-small-17.png"];
    UIImage* redo = [UIImage imageNamed:@"arrow-small-18.png"];
    
    Toolbar_ = [[UIToolbar alloc]init];
    Toolbar_.barStyle = UIBarStyleBlack;
    Toolbar_.translucent = true;
        
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
    brushButton = [[UIBarButtonItem alloc]
                   initWithImage:brush
                   style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(selectBrush)];
    
    brushButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *eraserButton = [[UIBarButtonItem alloc]
                                     initWithImage:eraser
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(selectEraser)];
    
    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc]
                                    initWithImage:image
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(selectImage)];
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]
                                   initWithImage:undo
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(selectUndo)];
    
    UIBarButtonItem *redoButton = [[UIBarButtonItem alloc]
                                   initWithImage:redo
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(selectRedo)];
    
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc]
                                      initWithImage:history
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(selectHistory)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                       initWithImage:settings
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(selectSettings)];
    
    
    
    [Toolbar_ setItems:[NSArray arrayWithObjects:
                        flexibleSpace,
                        brushButton,
                        flexibleSpace,
                        eraserButton,
                        flexibleSpace,
                        imageButton,
                        flexibleSpace,
                        undoButton,
                        flexibleSpace,
                        redoButton,
                        flexibleSpace,
                        historyButton,
                        flexibleSpace,
                        settingsButton,
                        flexibleSpace,
                        nil]
              animated:YES];
    
    Toolbar_.frame = CGRectMake(0, 0, 768, 50);
    
    //Rotate toolbar
    CGAffineTransform SegmentTransform = CGAffineTransformMake(0, 1, -1, 0, -360, 359);
    Toolbar_.transform = SegmentTransform;

    [self addSubview:Toolbar_];
}


- (void) makePopups
{
    PopupArray_ = malloc(sizeof(UIViewController*) * 3);
    
    PopupArray_[0] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    PopupArray_[1] = [[SSEraserViewController alloc] initWithNibName:@"EraserToolBarPalette" bundle:nil];
    PopupArray_[2] = [[SSVersionControlToolbarViewController alloc] initWithNibName:@"SSVersionControlToolbarViewController" bundle:nil];
    
    
    [PopupArray_[0] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [PopupArray_[1] setContentSizeForViewInPopover:CGSizeMake(225, 100)];
    [PopupArray_[2] setContentSizeForViewInPopover:CGSizeMake(300, 100)];
}

- (void) selectBrush
{
    [self selectBrush : PopupArray_[0] location: CGRectMake(50, 85, 0, 0)];
    prevSelectedIndex = 0;
}

- (void) selectEraser
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    NSNumber* size = [NSNumber numberWithFloat: ((SSEraserViewController*) PopupArray_[1]).eraserSize.value];
    
    [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];
    //[center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: size]];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];
    
    UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: PopupArray_[1]];
    [popOverController presentPopoverFromRect: CGRectMake(50, (768/7)*1+75, 0, 0)  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void) selectImage
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    [center postNotification: [NSNotification notificationWithName:@"imageSelected" object:nil]];
}

- (void) selectUndo
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    [center postNotification: [NSNotification notificationWithName:@"undoSelected" object:nil]];
}

- (void) selectRedo
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    [center postNotification: [NSNotification notificationWithName:@"redoSelected" object:nil]];
}

- (void) selectHistory
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    self.versionControlPopOver = [[UIPopoverController alloc] initWithContentViewController: PopupArray_[2]];
    [self.versionControlPopOver presentPopoverFromRect: CGRectMake(50, (768/7)*5+35, 0, 0)  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    [center postNotification: [NSNotification notificationWithName:@"disableBrush" object:nil]];
}

- (void) selectSettings
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    [center postNotification: [NSNotification notificationWithName:@"settingsSelected" object:nil]];
}


-(void) selectBrush: (UIViewController*) palette
           location: (CGRect) location
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    UIColor* color = ((NPViewController *)palette).colorPickerView.color;
    NSNumber* size = [NSNumber numberWithFloat: ((NPViewController*) palette).slider.value];

    //NSLog(@"ASSASDASD");
    
    [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];
    
    if(color != NULL){
        [center postNotification:[NSNotification notificationWithName:@"colorChanged" object: color]];
        //[center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: size]];
        [center postNotification: [NSNotification notificationWithName:@"brushSizeChangesEnded" object: nil]];
    } else {
        //DEFAULT
        [center postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]]];
        //[center postNotification:[NSNotification notificationWithName:@"brushSizeChanged" object: [NSNumber numberWithFloat: 0.25]]];
        [center postNotification: [NSNotification notificationWithName:@"brushSizeChangesEnded" object: nil]];
    }
    
    UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: palette];
    [popOverController presentPopoverFromRect: location  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

- (UIColor *)lightenColor:(UIColor *)oldColor byPercentage:(float)amount
{
    float percentage      = amount / 100.0;
    int   totalComponents = CGColorGetNumberOfComponents(oldColor.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(oldColor.CGColor);
    CGFloat newComponents[4];
    
    // FIXME: Clean this SHITE up
    if (isGreyscale) {
        newComponents[0] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[1] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[2] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[3] = oldComponents[0]*percentage + oldComponents[1] > 1.0 ? 1.0 : oldComponents[1]*percentage + oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]*percentage + oldComponents[0] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[0];
        newComponents[1] = oldComponents[1]*percentage + oldComponents[1] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[1];
        newComponents[2] = oldComponents[2]*percentage + oldComponents[2] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[2];
        newComponents[3] = oldComponents[3]*percentage + oldComponents[3] > 1.0 ? 1.0 : oldComponents[0]*percentage + oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
    return retColor;
}

-(void) brushColorChanged: (NSNotification*) note
{
    UIColor* color = (UIColor*)(note.object);
    brushButton.tintColor = [self lightenColor:color byPercentage:50];
}

-(void) historySelected: (NSNotification*)note
{
    [self.versionControlPopOver dismissPopoverAnimated:NO];
    [self.versionControlPopOver release];
}

-(void)revertToPreviousSelection: (NSNotification*) note
{
    //SegmentedControl_.selectedSegmentIndex = prevSelectedIndex;
}

- (void)dealloc 

{
    
    [Toolbar_ release];
    
    Toolbar_ = nil;
        
    [super dealloc];
    
}

@end