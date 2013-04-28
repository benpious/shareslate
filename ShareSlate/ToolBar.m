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
    UIImage* brush = [self imageWithImage: [UIImage imageNamed:@"brush-icon.png"] scaledToSize:CGSizeMake(32, 32)];
    UIImage* eraser = [self imageWithImage: [UIImage imageNamed:@"eraser-icon.png"] scaledToSize:CGSizeMake(32, 32)];
    UIImage* text = [self imageWithImage: [UIImage imageNamed:@"text-icon.png"] scaledToSize:CGSizeMake(32, 32)];
    UIImage* image = [self imageWithImage: [UIImage imageNamed:@"image-upload-icon-black.png"] scaledToSize:CGSizeMake(32, 32)];
    UIImage* history = [self imageWithImage: [UIImage imageNamed:@"history-icon.png"] scaledToSize:CGSizeMake(32, 32)];
    UIImage* settings = [self imageWithImage: [UIImage imageNamed:@"settings-icon.png"] scaledToSize:CGSizeMake(32, 32)];

    
    
    SegmentImageArray_ = [NSArray arrayWithObjects:
                          
                          brush,
                          brush,
                          brush,
                          brush,
                          brush,
                          brush,
                          eraser,
                          text,
                          image,
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
    SegmentPopupArray_ = malloc(sizeof(UIViewController*) * 7);
    
    SegmentPopupArray_[0] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[1] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[2] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[3] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[4] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[5] = [[NPViewController alloc] initWithNibName:@"NPViewController" bundle:nil];
    SegmentPopupArray_[6] = [[SSEraserViewController alloc] initWithNibName:@"EraserToolBarPalette" bundle:nil];
    
    
    [SegmentPopupArray_[0] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[1] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[2] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[3] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[4] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[5] setContentSizeForViewInPopover:CGSizeMake(225, 400)];
    [SegmentPopupArray_[6] setContentSizeForViewInPopover:CGSizeMake(225, 100)];

    
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
            
        {
            [self selectBrush : SegmentPopupArray_[0] location: CGRectMake(50, 10, 0, 0)];
            break;
            
        }
            
        case 1:
            
        {
            [self selectBrush : SegmentPopupArray_[1] location: CGRectMake(50, (750/11)*1+45, 0, 0)];
            
            break;
            
        }
            
        case 2:
            
        {
            [self selectBrush : SegmentPopupArray_[2] location: CGRectMake(50, (750/11)*2+45, 0, 0)];
            
            break;
            
        }
            
        case 3:
            
        {
            [self selectBrush : SegmentPopupArray_[3] location: CGRectMake(50, (750/11)*3+45, 0, 0)];
            
            break;
            
        }
            
        case 4:
            
        {
            [self selectBrush : SegmentPopupArray_[4] location: CGRectMake(50, (750/11)*4+45, 0, 0)];
            
            break;
            
        }
            
        case 5:
            
        {
            [self selectBrush : SegmentPopupArray_[5] location: CGRectMake(50, (750/11)*5+45, 0, 0)];
            
            break;
            
        }
            
        case 6:
            
        {
            NSNumber* size = [NSNumber numberWithFloat: ((SSEraserViewController*) SegmentPopupArray_[6]).eraserSize.value];
            
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];
            [center postNotification: [NSNotification notificationWithName:@"brushSizeChanged" object: size]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];
            
            UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController: SegmentPopupArray_[6]];
            [popOverController presentPopoverFromRect: CGRectMake(50, (750/11)*6+45, 0, 0)  inView: self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
            //Action for seventh toolbar item
            
            break;
            
        }
            
        case 8:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"imageSelected" object:nil]];

            //Action for eight toolbar item
            
            break;
            
        }
            
        case 9:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"historySelected" object:nil]];
            //Action for ninth toolbar item;
            
            break;
            
        }
            
        case 10:
            
        {
            
            //Action for tenth toolbar item
            [center postNotification: [NSNotification notificationWithName:@"settingsSelected" object:nil]];
            
            break;
            
        }
            
        default:
            
            break;
            
    }
    
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