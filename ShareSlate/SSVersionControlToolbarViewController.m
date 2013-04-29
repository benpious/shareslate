//
//  SSVersionControlToolbarViewController.m
//  ShareSlate
//
//  Created by Benjamin Pious on 4/29/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVersionControlToolbarViewController.h"

@interface SSVersionControlToolbarViewController ()

@end

@implementation SSVersionControlToolbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"saveVersion" object:nil]];
}

-(IBAction)versionsButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"historySelected" object:nil]];

}

@end
