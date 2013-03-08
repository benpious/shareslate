//
//  SSVerticalToolBar.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVerticalToolBar.h"

@implementation SSVerticalToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     

    }
    return self;
}


-(void) awakeFromNib
{
    // Initialization code
    self.dataSource = self;
    self.rowHeight = 80;
    //self.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString* imageNameFullPath = [[NSBundle mainBundle] pathForResource:@"ios-linen.png" ofType: nil];
    self.backgroundImage = [[UIImage alloc] initWithContentsOfFile:imageNameFullPath];
    backImage = [[UIImageView alloc] initWithImage: self.backgroundImage];
    [self addSubview: backImage];
    [self sendSubviewToBack: backImage];
    self.items = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 1; i++) {
        UITabBarItem* curr = [[UITabBarItem alloc] init];
        curr.title = @"Tool";
        NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        curr.image = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        [self.items addObject:curr];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollEnabled = (self.rowHeight * [self.items count]) > self.bounds.size.height;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vtbci = @"vtbci";
    SSToolBarCell *cell = [tableView dequeueReusableCellWithIdentifier:vtbci];
    if (cell == nil)
    {
        cell = [[SSToolBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vtbci];
    }
        
    UITabBarItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    //cell.iconImage = item.image;
    NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];

    [cell.contentView addSubview: [[UIImageView alloc] initWithImage: image] ];

    
    return cell;

}

@end
