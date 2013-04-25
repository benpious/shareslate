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
    
    [UIView animateWithDuration:1.0 animations:^{
        
        for (UIViewController* currViewController in self.viewControllers) {
            CGAffineTransform scale =  CGAffineTransformMakeScale(.8, .8);
            currViewController.view.transform = CGAffineTransformTranslate(scale, -bounds.size.width/4, 0.0);
            
            //currViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            //currViewController.view.layer.shadowOffset = CGSizeMake(0,10);
            //currViewController.view.layer.shadowOpacity = .75;
        }
        
    } completion:^(BOOL completed) {
        
        [UIView animateWithDuration: 1.0 animations:^{
            
            CGFloat xOffset = bounds.size.width/[self.viewControllers count]/10.0;
            //CGFloat yOffset = bounds.size.height/[self.viewControllers count];
            
            int i = 0;
            for (UIViewController* currViewController in self.viewControllers) {
                //rotate 45 degrees, then translate
                if (i != self.selectedIndex) {
                    if (i < self.selectedIndex) {
                        currViewController.view.layer.transform = CATransform3DRotate(currViewController.view.layer.transform, 0.34 , 0.0, 1.0, 0.0);
                        currViewController.view.layer.transform = CATransform3DTranslate(currViewController.view.layer.transform, xOffset*i, 0.0, -1);
                    }
                    else {
                        currViewController.view.layer.transform = CATransform3DRotate(currViewController.view.layer.transform,-0.34 , 0.0, 1.0, 0.0);
                        currViewController.view.layer.transform = CATransform3DTranslate(currViewController.view.layer.transform, -xOffset*i, 0.0, -1);
                    }
                    
                }
                i++;
            }
            
        }];
    }];
}

-(void) moveToIndex: (int) index
{
    NSLog(@"movetoIndex");
    CGRect bounds = [self.view bounds];
    
    [UIView animateWithDuration: 1.0 animations:^{
        
        CGFloat xOffset = bounds.size.width/[self.viewControllers count];
        //CGFloat yOffset = bounds.size.height/[self.viewControllers count];
        
        int i = 0;
        for (UIViewController* currViewController in self.viewControllers) {
            float currentXOffset = [[currViewController.view.layer valueForKeyPath:@"transform.translation.x"] floatValue];
            currViewController.view.layer.transform =  CATransform3DTranslate(currViewController.view.layer.transform, xOffset*(i - self.selectedIndex) - currentXOffset, 0 , 0);
            
            //reset the rotation
            float currentAngle = [[currViewController.view.layer valueForKeyPath:@"transform.rotation.y"] floatValue];
            
            //rotate 45 degrees
            if (i != self.selectedIndex) {
                if (i < self.selectedIndex) {
                    currViewController.view.layer.transform = CATransform3DRotate(currViewController.view.layer.transform, 0.34 - currentAngle , 0.0, 1.0, 0.0);
                    
                }
                else {
                    currViewController.view.layer.transform = CATransform3DRotate(currViewController.view.layer.transform, -0.34 - currentAngle, 0.0, 1.0, 0.0);
                }
            }
            else {
                currViewController.view.layer.transform = CATransform3DRotate(currViewController.view.layer.transform, -currentAngle, 0.0, 1.0, 0.0);

            }
            i++;
        }
    }];
    
}

-(void)selectCurrViewController
{
    NSLog(@"selectcurrviewcontroller");
    [UIView animateWithDuration:1.0 animations:^{
        int i = 0;
        for (UIViewController* currController in self.viewControllers) {
            
            if (i != self.selectedIndex) {
                [currController.view.layer setOpacity:0.0];
            }
            else {
                currController.view.layer.transform =  CATransform3DMakeScale(1.0, 1.0, 1.0);
            }
        }
    }
                     completion:^(BOOL complete) {
                         
                         [self.center postNotificationName:@"viewSelected" object: [NSNumber numberWithInt:self.selectedIndex]];
                     }];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];
    float movement = loc.x - self.lastTouch.x;
    
    if (fabs(loc.y - self.lastTouch.y) < 10) {
        NSLog(@"selecting index");
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
    
    //this is wrong, just for testing
    self.selectedIndex+= (movement/self.view.bounds.size.width)*[self.viewControllers count];
    
    if(self.selectedIndex > [self.viewControllers count])
        self.selectedIndex = [self.viewControllers count];
    if(self.selectedIndex < 0)
        self.selectedIndex = 0;
    
    [self moveToIndex:self.selectedIndex];
    
    
    
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
