//
//  SSVerticalToolBar.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVerticalToolBar.h"
#import <QuartzCore/QuartzCore.h>


@implementation SSVerticalToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        
        //set selected row to an invalid row so nothing starts out as selected
        selectedRow = -1;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBackground"]]];
        numItems = 4;
        
        //magic number -- at this point the view doesn't have a height, so need to specify this
        //obviously this is kind of awful, at some point I'll look into fixing it
        self.rowHeight = 768.0f/numItems;
        items = malloc(sizeof(toolBarItem) * numItems);
        
        
        
        //create the brush tool
        toolBarItem brush = items[0];
        brush.label = @"Brush";
        brush.expandedViewController = [[UIViewController alloc] initWithNibName:@"brushToolBarPalette" bundle:nil];
        brush.expandedHeight = [[brush.expandedViewController view] frame].size.height;
        
        NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        brush.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        items[0] = brush;
        
        //create the eraser tool
        
        toolBarItem eraser = items[1];
        eraser.label = @"Eraser";
        eraser.expandedViewController = [[UIViewController alloc] initWithNibName:@"EraserToolBarPalette" bundle:nil];
        eraser.expandedHeight = [[eraser.expandedViewController view] frame].size.height;
        
        otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        eraser.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        items[1] = eraser;
        
        
        //create the shape tool
        
        toolBarItem shape = items[2];
        shape.label = @"Image";
        shape.expandedViewController = [[UIViewController alloc] initWithNibName:@"ShapeToolBarPalette" bundle:nil];
        otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        shape.expandedHeight = [[shape.expandedViewController view] frame].size.height;
        shape.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        items[2] = shape;
        
        //create the chat tool
        
        toolBarItem chat = items[3];
        chat.label = @"History";
        chat.expandedViewController = [[UIViewController alloc] initWithNibName:@"VersionControlPalette" bundle:nil];
        chat.expandedHeight = [[chat.expandedViewController view] frame].size.height;
        otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
        chat.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
        items[3] = chat;
        
        
        center = [NSNotificationCenter defaultCenter];

    }
    return self;
}


-(void) awakeFromNib
{
    // Initialization code
    self.dataSource = self;
    self.delegate = self;
    
    //set selected row to an invalid row so nothing starts out as selected
    selectedRow = -1;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBackground"]]];
    numItems = 4;
    
    //magic number -- at this point the view doesn't have a height, so need to specify this
    //obviously this is kind of awful, at some point I'll look into fixing it
    self.rowHeight = 768.0f/numItems;
    items = malloc(sizeof(toolBarItem) * numItems);
    
    
    
    //create the brush tool
    toolBarItem brush = items[0];
    brush.label = @"Brush";
    brush.expandedViewController = [[UIViewController alloc] initWithNibName:@"brushToolBarPalette" bundle:nil];
    brush.expandedHeight = [[brush.expandedViewController view] frame].size.height;

    NSString* otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
    brush.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
    items[0] = brush;
    
    //create the eraser tool
    
    toolBarItem eraser = items[1];
    eraser.label = @"Eraser";
    eraser.expandedViewController = [[UIViewController alloc] initWithNibName:@"EraserToolBarPalette" bundle:nil];
    eraser.expandedHeight = [[eraser.expandedViewController view] frame].size.height;

    otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
    eraser.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
    items[1] = eraser;

    
    //create the shape tool
    
    toolBarItem shape = items[2];
    shape.label = @"Shape";
    shape.expandedViewController = [[UIViewController alloc] initWithNibName:@"ShapeToolBarPalette" bundle:nil];
    otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
    shape.expandedHeight = [[shape.expandedViewController view] frame].size.height;
    shape.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
    items[2] = shape;

    //create the chat tool
    
    toolBarItem chat = items[3];
    chat.label = @"History";
    chat.expandedViewController = [[UIViewController alloc] initWithNibName:@"VersionControlPalette" bundle:nil];
    chat.expandedHeight = [[chat.expandedViewController view] frame].size.height;
    otherImageNameFullPath = [[NSBundle mainBundle] pathForResource:@"gplaypattern_@2X.png" ofType: nil];
    chat.backGroundImage = [[UIImage alloc] initWithContentsOfFile: otherImageNameFullPath];
    items[3] = chat;

    
    center = [NSNotificationCenter defaultCenter];
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];

    
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
    
    //hardcoded selection of brush
    if (indexPath.row == 0 && selectedRow != 0) {
        [center postNotification: [NSNotification notificationWithName:@"brushSelected" object:nil]];
    }
    
    //hard coded selection of image
    if (indexPath.row == 2 && selectedRow !=2 ) {
        
        [center postNotification: [NSNotification notificationWithName:@"imageSelected" object:nil]];
    }
    
    //hard coded selection of history
    if (indexPath.row == 3) {
        
        [center postNotification: [NSNotification notificationWithName:@"historySelected" object:nil]];
        return  indexPath;
    }
    
    if (selectedRow != indexPath.row) {
        selectedRow = indexPath.row;

    }
    else {
        
        selectedRow = -1;
        
    }
    
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
        cell.textLabel.text = nil;
    }
    
    else {
        
        cell.textLabel.text = item.label;
        cell.iconImage = item.backGroundImage;

    }
    
    return cell;

}

@end
