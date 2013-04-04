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
        
    }
    
    return self;
    
}



- (void) makeToolBar

{
    
    SegmentImageArray_ = [NSArray arrayWithObjects:
                          
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"brush_alt_32x32.png"],
                          [UIImage imageNamed:@"erase.png"],
                          [UIImage imageNamed:@"camera_32x32.png"],
                          [UIImage imageNamed:@"new_window_32x32"],
                          [UIImage imageNamed:@"cog_32x32.png"],         nil];
    
    SegmentedControl_ = [[UISegmentedControl alloc]                                               initWithItems:SegmentImageArray_];
    
    SegmentedControl_.frame = CGRectMake(0, 15, 748, 40);
    
    SegmentedControl_.segmentedControlStyle =                                                          UISegmentedControlStyleBezeled;
    
    SegmentedControl_.momentary = 0;
    
    [SegmentedControl_ addTarget:self                                                        action:@selector(SegmentControlAction:)
     
                forControlEvents:UIControlEventValueChanged];
    
    
    
    // This is where you set your toolbar control
    
    
    
    CGAffineTransform SegmentTransform =
    
    CGAffineTransformMake(0, 1, -1, 0, -348, 349);
    
    SegmentedControl_.transform = SegmentTransform;
    
    [self addSubview:SegmentedControl_];
    
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
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            
            //Action for first toolbar item
            
            break;
            
        }
            
        case 1:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            //Action for Second toolbar item
            
            break;
            
        }
            
        case 2:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            //Action for third toolbar item
            
            break;
            
        }
            
        case 3:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            //Action for fourth toolbar item;
            
            break;
            
        }
            
        case 4:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            //Action for fifth toolbar item
            
            break;
            
        }
            
        case 5:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];

            //Action for sixth toolbar item
            
            break;
            
        }
            
        case 6:
            
        {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"colorChanged" object: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];

            //Action for seventh toolbar item
            
            break;
            
        }
            
        case 7:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"imageSelected" object:nil]];

            //Action for eight toolbar item
            
            break;
            
        }
            
        case 8:
            
        {
            [center postNotification: [NSNotification notificationWithName:@"historySelected" object:nil]];
            //Action for ninth toolbar item;
            
            break;
            
        }
            
        case 9:
            
        {
            
            //Action for tenth toolbar item
            
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