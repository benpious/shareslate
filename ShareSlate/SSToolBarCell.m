//
//  SSToolBarCell.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSToolBarCell.h"

@implementation SSToolBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
        
        self.otherView = [[[[NSBundle mainBundle] loadNibNamed:@"testToolBarPalette" owner:self options:nil] objectAtIndex:0] retain];
        self.objects = [[NSBundle mainBundle] loadNibNamed:@"testToolBarPalette" owner:self options:nil];
        self.isExpanded = NO;

        if (self.otherView) {
            // Initialization code
            self.otherView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 200);
            
            
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
-(void) drawRect:(CGRect)rect
{

    CGRect bounds = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip the coordinates system
    CGContextTranslateCTM(context, 0.0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // draw an image in the center of the cell
    CGSize imageSize = self.iconImage.size;
    CGRect imageRect = CGRectMake(floorf(((bounds.size.width-imageSize.width)/2.0)),
                                  floorf(((bounds.size.height-imageSize.height)/2.0)+15),
                                  imageSize.width,
                                  imageSize.height);

    //CGContextDrawImage(context, imageRect , self.iconImage.CGImage);
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
*/

@end
