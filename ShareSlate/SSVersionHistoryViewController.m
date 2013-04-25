//
//  SSVersionHistoryViewController.m
//  ShareSlate
//
//  Created by Benjamin Pious on 4/25/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSVersionHistoryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SSVersionHistoryViewController ()

@property (retain) NSArray* viewControllers;
@property (assign) int selectedIndex;
@property (assign) CGPoint lastTouch;
@property (assign) NSNotificationCenter* center;

@end

@implementation SSVersionHistoryViewController

-(id) initWithArray: (NSArray*) viewControllerArray
{
    if (self = [super init]) {
        self.viewControllers = viewControllerArray;
        self.selectedIndex = 0;
        self.center = [NSNotificationCenter defaultCenter];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self setUpViewControllers];
}

-(void) setUpViewControllers
{
    for (UIViewController* currController in self.viewControllers) {
        [currController.view setFrame: self.view.frame];
        [self.view addSubview:currController.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) historySelected
{
    CGRect bounds = [self.view bounds];
    
    [UIView animateWithDuration:2.0 animations:^{
        
        for (UIViewController* currViewController in self.viewControllers) {
            CGAffineTransform scale =  CGAffineTransformMakeScale(.8, .8);
            CGAffineTransformTranslate(scale, bounds.size.width/2, 0.0);
        }
        
    } completion:^(BOOL completed) {
        
        [UIView animateWithDuration: 2.0 animations:^{
            
            CGFloat xOffset = bounds.size.width/[self.viewControllers count];
            CGFloat yOffset = bounds.size.height/[self.viewControllers count];
            
            int i = 0;
            for (UIViewController* currViewController in self.viewControllers) {
                currViewController.view.transform = CGAffineTransformTranslate(currViewController.view.transform, xOffset*i, yOffset*i);
                
                //rotate 45 degrees
                if (i != 0) {
                    if (i < self.selectedIndex) {
                        currViewController.view.layer.transform = CATransform3DMakeRotation(-0.785 , 1.0, 0.0, 0.0);
                    }
                    else {
                        
                    currViewController.view.layer.transform = CATransform3DMakeRotation(0.785 , 1.0, 0.0, 0.0);
                    }
                }
                i++;
            }
        }];
    }];
}

-(void) moveToIndex: (int) index
{
    CGRect bounds = [self.view bounds];
    
    [UIView animateWithDuration: 2.0 animations:^{
        
        CGFloat xOffset = bounds.size.width/[self.viewControllers count];
        CGFloat yOffset = bounds.size.height/[self.viewControllers count];
        
        int i = 0;
        for (UIViewController* currViewController in self.viewControllers) {
            currViewController.view.transform = CGAffineTransformTranslate(currViewController.view.transform, xOffset*(i - self.selectedIndex), yOffset*(i-self.selectedIndex));
            //rotate 45 degrees
            if (i != self.selectedIndex) {
                currViewController.view.layer.transform = CATransform3DMakeRotation(0.785 , 1.0, 0.0, 0.0);
            }
            
            else {
                currViewController.view.layer.transform = CATransform3DMakeRotation(0.0, 1.0, 0.0, 0.0);
            }
            
            i++;
        }
    }];
    
}

-(void)selectCurrViewController
{
    [UIView animateWithDuration:2.0 animations:^{
        int i = 0;
        for (UIViewController* currController in self.viewControllers) {
            
            if (i != self.selectedIndex) {
                [currController.view.layer setOpacity:0.0];
            }
            else {
                currController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }
    }
                     completion:^(BOOL complete) {
                         
                         [self.center postNotificationName:@"viewSelected" object: [NSNumber numberWithInt:self.selectedIndex]];
                     }];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int i = 0;
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];
    
    if ([((UIViewController*)[self.viewControllers objectAtIndex:self.selectedIndex]).view pointInside:loc withEvent:event]   ) {
        [self selectCurrViewController];
    }
    
    for (UIViewController* currController in self.viewControllers) {
        
        if ([currController.view pointInside:loc withEvent:event]) {
            self.selectedIndex = i;
            [self moveToIndex: i];
            return;
        }
        
        i++;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    self.lastTouch = [aTouch locationInView:nil];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];
    float movement = loc.x - self.lastTouch.x;
    
    //this is wrong, just for testing
    self.selectedIndex+= movement/self.view.bounds.size.width/[self.viewControllers count];
    
    if(self.selectedIndex > [self.viewControllers count])
        self.selectedIndex = [self.viewControllers count];
    if(self.selectedIndex < 0)
        self.selectedIndex = 0;
    
    [self moveToIndex:self.selectedIndex];
    
}

-(void) dealloc
{
    [self.viewControllers release];
    [super dealloc];
}
@end
