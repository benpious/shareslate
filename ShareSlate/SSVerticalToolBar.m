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
    self.rowHeight = 100;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString* imageNameFullPath = [[NSBundle mainBundle] pathForResource:@"ios-linen.png" ofType: nil];
    self.backgroundImage = [[UIImage alloc] initWithContentsOfFile:imageNameFullPath];
    backImage = [[UIImageView alloc] initWithImage: self.backgroundImage];
    [self addSubview: backImage];
    [self sendSubviewToBack: backImage];
    self.items = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i =0; i<4; i++) {
        UITabBarItem* curr = [[UITabBarItem alloc] init];
        curr.title = @"xyz";
        curr.image = [[UIImage alloc] initWithContentsOfFile:imageNameFullPath];
        [self.items addObject:curr];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [backImage setNeedsDisplay];
    
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
    cell.iconImage = item.image;
    
    return cell;

}

@end
