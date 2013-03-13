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
    self.delegate = self;

    selectedRow = -1;
    //self.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString* imageNameFullPath = [[NSBundle mainBundle] pathForResource:@"ios-linen.png" ofType: nil];
    self.backgroundImage = [[UIImage alloc] initWithContentsOfFile:imageNameFullPath];
    backImage = [[UIImageView alloc] initWithImage: self.backgroundImage];
    numItems = 4;
    self.rowHeight = 704.0f/numItems;
    //[self addSubview: backImage];
    //[self sendSubviewToBack: backImage];
    items = malloc(sizeof(toolBarItem) * numItems);
    
    for (int i = 0; i < numItems; i++) {
        toolBarItem curr = items[i];
        curr.label = @"Brush";
        curr.expandedHeight = 60.0f;
        curr.expandedViewController = [[UIViewController alloc] initWithNibName:@"testToolBarPalette" bundle:nil];
        NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        curr.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        items[i] = curr;
    }
    
    center = [NSNotificationCenter defaultCenter];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numItems;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollEnabled = (self.rowHeight * numItems) > self.bounds.size.height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [center postNotification:[NSNotification notificationWithName:@"rowDeselected" object:nil]];
    selectedRow = indexPath.row;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self reloadData];
}


//implement to get a size from each member of the array

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (selectedRow == indexPath.row) {
        
        return items[indexPath.row].expandedHeight;
    }
    
    else {
        return self.rowHeight;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"id";
    SSToolBarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[SSToolBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    toolBarItem item = items[indexPath.row];

    
    if (indexPath.row == selectedRow) {
        cell.otherView = [item.expandedViewController view];
        cell.isExpanded = YES;
    }
    
    else {
        
        cell.textLabel.text = item.label;
        cell.iconImage = item.backGroundImage;

    }
    
    return cell;

}

@end
