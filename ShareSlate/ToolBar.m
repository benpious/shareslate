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
        
        self.frame = CGRectMake(origin_.x, origin_.y, 40, 748);
        
        // this will create the toolbar
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"revertToPreviousSelection:") name:@"revertToOldSelection" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"historySelected:") name:@"historySelected" object:nil];
        
        [self  makeToolBar];
        [self makePopups];
        
    }
    
    return self;
    
}

- (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    
    SegmentImageArray_ = [NSArray arrayWithObjects:
                          brush,
                          eraser,
                          image,
                          undo,
                          redo,
                          history,
                          settings, nil];
    
    SegmentedControl_ = [[UISegmentedControl alloc]initWithItems:SegmentImageArray_];
    
    SegmentedControl_.frame = CGRectMake(0, 15, 748, 40);
    
    SegmentedControl_.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    SegmentedControl_.momentary = 0;
    
    [SegmentedControl_ addTarget:self action:@selector(SegmentControlAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    // This is where you set your toolbar control
    
    
    
    CGAffineTransform SegmentTransform =
    
    CGAffineTransformMake(0, 1, -1, 0, -348, 349);
    
    SegmentedControl_.transform = SegmentTransform;
    
    [self addSubview:SegmentedControl_];
    
}

- (void) makePopups
{
    SegmentPopupArray_ = malloc(sizeof(UIViewController*) * 3);
    
    SegmentPopupArray_[0] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[1] = [[SSEraserViewController alloc] initWithNibName:@"EraserToolBarPalette" bundle:nil];
    SegmentPopupArray_[2] = [[SSVersionControlToolbarViewController alloc] initWithNibName:@"SSVersionControlToolbarViewController" bundle:nil];

    
    [SegmentPopupArray_[0] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[1] setContentSizeForViewInPopover:CGSizeMake(225, 100)];
    [SegmentPopupArray_[2] setContentSizeForViewInPopover:CGSizeMake(300, 100)];

    
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
        [center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: size]];
        [center postNotification: [NSNotification notificationWithName:@"brushSizeChangesEnded" object: nil]];
    } else {
        //DEFAULT
        [center postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]]];
        [center postNotification:[NSNotification notificationWithName:@"brushSizeChanged" object: [NSNumber numberWithFloat: 0.25]]];
        [center postNotification: [NSNotification notificationWithName:@"brushSizeChangesEnded" object: nil]];
    }
    
    UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: palette];
    [popOverController presentPopoverFromRect: location  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}


- (void) SegmentControlAction:(id) sender

{
    
    UISegmentedControl *segmentedControl =
    
    (UISegmentedControl *)sender;
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    
    switch ([segmentedControl selectedSegmentIndex])
    
    {
            
        case 0:
        //Brush
        {
            [self selectBrush : SegmentPopupArray_[0] location: CGRectMake(50, 10, 0, 0)];
            prevSelectedIndex = [segmentedControl selectedSegmentIndex];

            break;
            
        }
        case 1:
        //Eraser
        {
            NSNumber* size = [NSNumber numberWithFloat: ((SSEraserViewController*) SegmentPopupArray_[1]).eraserSize.value];
            
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];
            [center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: size]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];
            
            UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: SegmentPopupArray_[1]];
            [popOverController presentPopoverFromRect: CGRectMake(50, (750/7)*1+60, 0, 0)  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
            //Action for seventh toolbar item
            prevSelectedIndex = [segmentedControl selectedSegmentIndex];

            break;
            
        }
            
        case 2:
        //Image
        {
            [center postNotification: [NSNotification notificationWithName:@"imageSelected" object:nil]];

            //Action for eight toolbar item

            break;
            
        }
            
        case 3:
        // Undo
        {
            [center postNotification: [NSNotification notificationWithName:@"undoSelected" object:nil]];

            break;
        }
        case 4:
        // Redo
        {
            [center postNotification: [NSNotification notificationWithName:@"redoSelected" object:nil]];

            break;
        }
        case 5:
        //Version Control
        {
            //[center postNotification: [NSNotification notificationWithName:@"historySelected" object:nil]];
            self.versionControlPopOver = [[UIPopoverController alloc] initWithContentViewController: SegmentPopupArray_[2]];
            [self.versionControlPopOver presentPopoverFromRect: CGRectMake(50, (750/7)*5+60, 0, 0)  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

            //Action for ninth toolbar item;
            break;
            
        }
            
        case 6:
        //Settings
        {
            
            //Action for tenth toolbar item
            [center postNotification: [NSNotification notificationWithName:@"settingsSelected" object:nil]];
            
            break;
            
        }
            
        default:
            
            break;
            
    }
    
}

-(void) historySelected: (NSNotification*)note
{
    [self.versionControlPopOver dismissPopoverAnimated:NO];
    [self.versionControlPopOver release];
}

-(void)revertToPreviousSelection: (NSNotification*) note
{
    SegmentedControl_.selectedSegmentIndex = prevSelectedIndex;
}

- (void)dealloc 

{
    
    [SegmentedControl_ release];
    
    SegmentedControl_ = nil;
    
    [SegmentImageArray_ release];
    
    SegmentImageArray_ = nil;
    
    [super dealloc];
    
}

@end