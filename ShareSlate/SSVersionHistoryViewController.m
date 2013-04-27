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
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
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

#pragma mark animations

-(void) historySelected
{
    CGRect bounds = [self.view bounds];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.layer.sublayerTransform = [self get3DTransform];
        
        for (UIViewController* currViewController in self.viewControllers) {
            //CGAffineTransform scale =  CGAffineTransformMakeScale(.7, .7);
            //currViewController.view.transform = CGAffineTransformTranslate(scale, -bounds.size.width/4, 0.0);
            
            currViewController.view.layer.transform = CATransform3DTranslate(currViewController.view.layer.transform, -bounds.size.width/4, 0.0, -700.0);
            
            currViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            currViewController.view.layer.shadowOffset = CGSizeMake(0,10);
            currViewController.view.layer.shadowOpacity = .55;
        }
        
    } completion:^(BOOL completed) {
        
        [UIView animateWithDuration: 1.0 animations:^{
            
            CGFloat xOffset = bounds.size.width/[self.viewControllers count];
            
            int i = 0;
            for (UIViewController* currViewController in self.viewControllers) {
                //rotate 45 degrees, then translate
                if (i != self.selectedIndex) {
                    if (i < self.selectedIndex) {
                        currViewController.view.layer.transform = CATransform3DTranslate(CATransform3DMakeRotation(-0.34 , 0.0, 1.0, 0.0), -xOffset*(i-self.selectedIndex) -bounds.size.width/4, 0.0, - 200 * fabs(i - self.selectedIndex) - 700);
                    }
                    else {
                        currViewController.view.layer.transform = CATransform3DTranslate(CATransform3DMakeRotation(0.34 , 0.0, 1.0, 0.0), -xOffset*(i-self.selectedIndex) -bounds.size.width/4, 0.0, -200 * fabs(i - self.selectedIndex) - 700);
                    }
                }
                i++;
            }
        }];
    }];
}

-(void) moveToIndex: (int) index
{
    
    if(index > [self.viewControllers count]-1) {
        return;
    }
    
    if(index < 0) {
        return;
    }
    
    CGRect bounds = [self.view bounds];
    
    [UIView animateWithDuration: 1.0 animations:^{
        
        CGFloat xOffset = bounds.size.width/[self.viewControllers count];

        int i = 0;
        for (UIViewController* currViewController in self.viewControllers) {
                        
            //rotate 45 degrees
            if (i != index) {
                
                if (i < index) {
                    
                    currViewController.view.layer.transform = CATransform3DTranslate(CATransform3DMakeRotation(-0.34, 0.0, 1.0, 0.0), -xOffset*(i - index) - bounds.size.width/4, 0.0, -200 * fabs(i-index) -700.0);
                    
                }
                else {
                    
                    currViewController.view.layer.transform = CATransform3DTranslate(CATransform3DMakeRotation(0.34, 0.0, 1.0, 0.0), -xOffset*(i - index) - bounds.size.width/4, 0.0, -200 * fabs(i-index) -700.0);
                }
            }
            
            else {
                currViewController.view.layer.transform =  CATransform3DMakeTranslation(- bounds.size.width/4, 0.0, -700);
            }
            
            i++;
        }
    }];
    
    self.selectedIndex = index;
    
}

-(void)selectCurrViewController
{
    CGRect bounds = [self.view bounds];

    [UIView animateWithDuration:1.0 animations:^{
        int i = 0;
        for (UIViewController* currController in self.viewControllers) {
            
            if (i != self.selectedIndex) {
                [currController.view.layer setOpacity:0.0];
            }
            else {
                currController.view.layer.transform =  CATransform3DTranslate(CATransform3DMakeScale(1.0, 1.0, 1.0), -bounds.size.width/4, 0.0, 0.0);
            }
            
            i++;
        }
    }
                     completion:^(BOOL complete) {
                         
                         [self.center postNotificationName:@"viewSelected" object: [NSNumber numberWithInt:self.selectedIndex]];
                     }];
}

- (CATransform3D) get3DTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -2000;
    return transform;
}


#pragma mark touch event handling

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];
    float movement = loc.y - self.lastTouch.y;
    
    if (fabs(movement) < 10) {
        
        int i = 0;
        
        if ([((UIViewController*)[self.viewControllers objectAtIndex:self.selectedIndex]).view pointInside:loc withEvent:event]) {
            [self selectCurrViewController];
            return;
        }
        
        for (UIViewController* currController in self.viewControllers) {
            
            if ([currController.view pointInside:loc withEvent:event]) {
                [self moveToIndex: i];
                [self selectCurrViewController];
                return;
            }
            
            i++;
        }
        
    }
    
    int index = self.selectedIndex;
    
    if (movement > 0) {
        index-= 1;
    }
    
    else {
        
        index+= 1;
    }
    
    [self moveToIndex: index];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    self.lastTouch = [aTouch locationInView:nil];
}

-(void) dealloc
{
    [self.viewControllers release];
    [super dealloc];
}
@end
