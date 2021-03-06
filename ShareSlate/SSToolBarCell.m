//
//  SSToolBarCell.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSToolBarCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSToolBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:40.0];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:NSSelectorFromString(@"deSelected:") name:@"rowDeselected" object:nil];
        //NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"buttonEffect.png" ofType: nil];
        //self.buttonEffect = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        //otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"recessedButtonEffect.png" ofType: nil];
        //self.recessedButtonEffect = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];


    }
    return self;
}

-(void) deSelected: (id) object {
    
    self.isExpanded = NO;
    [self.otherView removeFromSuperview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height*2);
}


-(void) drawRect:(CGRect)rect
{

    if (self.isExpanded) {
        [self addSubview:self.otherView];
        [self bringSubviewToFront:self.otherView];
        [self.otherView setNeedsDisplay];
        
        
        CGRect bounds = self.bounds;

        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // flip the coordinates system
        CGContextTranslateCTM(context, 0.0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);

        //CGContextDrawImage(context, self.bounds, self.recessedButtonEffect.CGImage);

    }
    
    else {
        
        CGRect bounds = self.bounds;
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // flip the coordinates system
        CGContextTranslateCTM(context, 0.0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawImage(context, self.bounds, self.iconImage.CGImage);
        
        // draw an image in the center of the cell
        CGSize imageSize = self.buttonImage.size;
        CGRect imageRect = CGRectMake(floorf(((bounds.size.width-imageSize.width*2)/2.0)),
                                      floorf(((bounds.size.height-imageSize.height*2)/2.0)+15),
                                      imageSize.width*2,
                                      imageSize.height*2);
        
        
        CGContextDrawImage(context, imageRect, self.buttonImage.CGImage);

    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textLabelFrame = CGRectMake(0,
                                       NAN,
                                       self.bounds.size.width,
                                       self.textLabel.font.lineHeight);
    textLabelFrame.origin.y = self.bounds.size.height-textLabelFrame.size.height - 15;
    self.textLabel.frame = textLabelFrame;
}


@end
