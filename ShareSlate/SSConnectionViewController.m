//
//  SSConnectionViewController.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/2/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSConnectionViewController.h"

@interface SSConnectionViewController ()

@end

@implementation SSConnectionViewController

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
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

        DVSlideViewController *controller = (DVSlideViewController*)segue.destinationViewController;
        ((SSViewController*)[controller.viewControllers objectAtIndex:0]).ip = [self.ipAddress text];
        ((SSViewController*)[controller.viewControllers objectAtIndex:0]).port = [[self.port text] intValue];
}

-(void)dismissKeyboard {
    [self.ipAddress resignFirstResponder];
    [self.port resignFirstResponder];
}



@end
