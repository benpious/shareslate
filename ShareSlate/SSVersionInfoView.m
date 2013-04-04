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
        self.versions = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 80.0f, 222.0f, 768.0f-80.0f)];
        self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.saveButton setFrame:CGRectMake(222/2-111, 40, 222, 40)];
        [self.saveButton setTitle:@"Save Version" forState:UIControlStateNormal];
        
        [self addSubview:self.saveButton];
        [self addSubview:self.searchBar];
        [self addSubview:self.versions];
        [self.versions setOpaque:NO];
        
        self.versionData = [[NSMutableArray alloc] initWithCapacity:5];
        [self.versionData addObject:@"Autosave 11/16/12"];
        [self.versionData addObject:@"Autosave 11/30/12"];
        [self.versionData addObject:@"Milestone"];
        [self.versionData addObject:@"Autosave 12/01/12"];
        [self.versionData addObject:@"Autosave 11/14/12"];

        self.versions.delegate = self;
        self.versions.dataSource = self;

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.versionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    
    // Configure the cell...
    
    [cell.textLabel setText: [self.versionData objectAtIndex: indexPath.row ]];
    
    
    return cell;
}


@end
