//
//  SSSettingsViewController.m
//  ShareSlate
//
//  Created by Benjamin Pious on 4/28/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SSSettingsViewController ()

@end

@implementation SSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(50, 50, 1024-100, 768-100);
        self.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [self.view.layer setCornerRadius:30.0f];
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeMake(0,10);
        self.view.layer.shadowOpacity = .55;
        self.center = [NSNotificationCenter defaultCenter];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void)expand
{
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];

}

-(IBAction)donePressed:(id)sender
{
    [self contract];
}

-(void) contract
{
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
    } completion:^(BOOL completion) {
    
        [self.center postNotification:[NSNotification notificationWithName:@"settingsDismissed" object:nil]];
        
    } ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
