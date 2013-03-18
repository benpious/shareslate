//
//  SSVersionInfoView.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/16/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVersionInfoView.h"

@implementation SSVersionInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *background = [[UIView alloc] initWithFrame:self.bounds];
        [background setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBackground"]]];
        [self addSubview:background];
        [background release];
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 222.0f, 40.0f)];
        self.versions = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 40.0f, 222.0f, 768.0f-40.0f)];
        [self addSubview:self.searchBar];
        [self addSubview:self.versions];
        [self.versions setOpaque:NO];

    }
    return self;
}

@end
