//
//  DVSlideViewController.m
//  DVSlideViewController
//
//  Created by Dick Verbunt on 6/11/12.
//  Copyright (c) 2012 Dickverbunt. All rights reserved.
//

#import "DVSlideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface DVSlideViewController ()
{
	UIScrollView *viewsContainer;
}
@end

@implementation DVSlideViewController

@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize scaleFactor = _scaleFactor;

- (id)init
{
	self = [super init];
	if (self)
	{
        self.isActive = NO;
        _selectedIndex = 0;
        _scaleFactor = 0.8;
        
        self.viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
        

	}
	
	return self;
}

-(id) initWithArray: (NSMutableArray*) array
{
    self = [super init];
	if (self)
	{
        self.isActive = NO;
        _selectedIndex = 0;
        _scaleFactor = 0.8;
        
        self.viewControllers = array;
        
        
	}
	
	return self;

}

-(void) setUp
{
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:NSSelectorFromString(@"historySelected:") name:@"historySelected" object:nil];
    
    [self setupViews];
    [self setupViewControllers];
}

- (void)setupViews
{
	UIView *background = [[UIView alloc] initWithFrame:self.view.bounds];
	[background setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	[background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grayBackground"]]];
	[self.view addSubview:background];
	[background release];
	
	viewsContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	viewsContainer.delegate = self;
	viewsContainer.showsHorizontalScrollIndicator = FALSE;
	viewsContainer.pagingEnabled = TRUE;
	[viewsContainer setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	[self.view addSubview:viewsContainer];
    
}

- (void)setupViewControllers
{
	NSUInteger i = 0;
	for (UIViewController *viewController in self.viewControllers) {
		[self addViewController:viewController atIndex:i];
		i++;
	}
}

- (void)setViewControllers:(NSMutableArray *)controllers
{
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController.view removeFromSuperview];
	}
	
	[_viewControllers autorelease];
	_viewControllers = [controllers retain];
	_selectedIndex = 0;
	
	
	if (self.isViewLoaded)
	{
		[self setupViewControllers];
	}
}

- (void)addViewController:(UIViewController *)viewController atIndex:(int)index;
{

    viewController.view.frame = CGRectMake((1024-172) * index, 0, (1024-172), 768);
	[viewsContainer addSubview:viewController.view];
	if ([viewController respondsToSelector:@selector(setSlideViewController:)]) {
		[viewController performSelector:@selector(setSlideViewController:) withObject:self];
	}
}

- (void)changeViewController:(UISwipeGestureRecognizer *)gesture
{
	NSUInteger nextIndex = _selectedIndex;
	
	if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
		nextIndex++;
	else if (gesture.direction ==  UISwipeGestureRecognizerDirectionRight)
		nextIndex--;
	
	if (nextIndex >= _viewControllers.count || nextIndex == -1)
		return;
	
	[self slideToViewControllerAtIndex:nextIndex];
}

//i added this method
-(void) selectViewController: (UITapGestureRecognizer *) gesture
{
    if (!self.isActive) {
        return;
    }
    
    if (_selectedIndex != 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Revert to this version?"
                                                        message:@"Reverting will propogate changes to all other users."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: @"Cancel" , nil];
        [alert show];
        [alert release];
    }
    
    else
    {

        
        [UIView animateWithDuration:0.25
                              delay:0.75
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL completed){
                             //currentViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             
                             //remove shadow next view controller
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.masksToBounds = YES;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowRadius = 0.0;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowOpacity = 0.0;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowPath = [UIBezierPath bezierPathWithRect:((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.bounds].CGPath;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                             
                             [((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]) viewDidAppear:YES];
                         }];
        
        self.isActive = NO;
        //post notification that version has been selected
        [center postNotification: [NSNotification notificationWithName:@"viewSelected" object: [NSNumber numberWithInt: _selectedIndex ]]];
        [self.view removeGestureRecognizer:tap];
        [self.view removeGestureRecognizer:swipeLeft];
        [self.view removeGestureRecognizer:swipeRight];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [UIView animateWithDuration:0.25
                              delay:0.75
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                         completion:^(BOOL completed){
                             //currentViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             
                             //remove shadow next view controller
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.masksToBounds = YES;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowRadius = 0.0;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowOpacity = 0.0;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowPath = [UIBezierPath bezierPathWithRect:((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.bounds].CGPath;
                             ((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]).view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                             
                             [((UIViewController*)[_viewControllers  objectAtIndex:_selectedIndex]) viewDidAppear:YES];
                         }];
        
        self.isActive = NO;
        //post notification that version has been selected
        [center postNotification: [NSNotification notificationWithName:@"viewSelected" object: [NSNumber numberWithInt: _selectedIndex ]]];
        [self.view removeGestureRecognizer:tap];
        [self.view removeGestureRecognizer:swipeLeft];
        [self.view removeGestureRecognizer:swipeRight];
        
    }
}

- (UIViewController *)viewControllerWithIndex:(NSUInteger)index
{
	UIViewController *viewController = nil;
	
	if (_viewControllers.count > index) 
	{
		viewController = [_viewControllers objectAtIndex:index];
	}
	
	return viewController;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (int i = 0; i < _viewControllers.count; i++)
	{
		UIViewController *viewController = [_viewControllers objectAtIndex:i];
		viewController.view.frame = CGRectMake(self.view.bounds.size.width * i,
										  0,
										  self.view.bounds.size.width,
										  self.view.bounds.size.height);
		
		//Recalulate shadow
		viewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.bounds].CGPath;
	}
	
	viewsContainer.contentOffset = CGPointMake(_selectedIndex * self.view.bounds.size.width, viewsContainer.contentOffset.y);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Animations

- (void)slideToViewControllerAtIndex:(NSUInteger)toIndex
{
    
    if (!self.isActive) {
        return;
    }
     
	UIViewController *currentViewController = [self viewControllerWithIndex:_selectedIndex];
	UIViewController *nextViewController = [self viewControllerWithIndex:toIndex];
	
	if (nextViewController == nil)
		return;
	
	CGPoint toPoint = viewsContainer.contentOffset;
	toPoint.x = toIndex * viewsContainer.bounds.size.width;
	//Start positions
	nextViewController.view.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
	
	currentViewController.view.layer.masksToBounds = NO;
	currentViewController.view.layer.shadowRadius = 10;
	currentViewController.view.layer.shadowOpacity = 0.5;
	currentViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentViewController.view.bounds].CGPath;
	currentViewController.view.layer.shadowOffset = CGSizeMake(5.0, 5.0);
	
	[currentViewController viewWillDisappear:YES];
	
    
    UIViewController *nextnextViewController = [self viewControllerWithIndex:_selectedIndex+2];
    nextnextViewController.view.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
	
	//Slide animation
	[UIView animateWithDuration:0.5
						  delay:0.25
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [viewsContainer setContentOffset:toPoint];
					 }
					 completion:^(BOOL completed){
						 
						 //remove current view controller
						 currentViewController.view.layer.masksToBounds = YES;
						 currentViewController.view.layer.shadowRadius = 10;
						 currentViewController.view.layer.shadowOpacity = 0.0;
						 currentViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:currentViewController.view.bounds].CGPath;
						 currentViewController.view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
						 
						 [self calculateSelectedIndex];
						 
						 [currentViewController viewDidDisappear:YES];
					 }];
    
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self calculateSelectedIndex];
}

- (void)calculateSelectedIndex
{
	_selectedIndex = floor((viewsContainer.contentOffset.x - self.view.bounds.size.width / 2) / self.view.bounds.size.width) + 1;
}

#pragma mark - Controller methods

- (void)nextViewController
{
	[self slideToViewControllerAtIndex:_selectedIndex + 1];
}

- (void)prevViewController
{
	[self slideToViewControllerAtIndex:_selectedIndex - 1];
}

-(void) historySelected: (NSNotification*) note
{
    UIViewController *currentViewController = [self viewControllerWithIndex:_selectedIndex];

    [UIView animateWithDuration:0.25
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 currentViewController.view.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
					 }
					 completion:NULL
					 ];
    
    self.isActive = YES;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewController:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
	swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewController:)];
	[swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self.view addGestureRecognizer:swipeLeft];
	[swipeLeft release];
	
	swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewController:)];
	[swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.view addGestureRecognizer:swipeRight];
	[swipeRight release];
    
    UIViewController *nextViewController = [self viewControllerWithIndex:_selectedIndex+1];

    
    [UIView animateWithDuration:0.25
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 nextViewController.view.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
					 }
					 completion:nil];
}

@end


#pragma mark - UViewController+DVSlideViewController

@implementation UIViewController (DVSlideViewController)

NSString const * kSlideViewController = @"slideViewController";

- (DVSlideViewController *)slideViewController {
    return (DVSlideViewController *)objc_getAssociatedObject(self, kSlideViewController);
}

- (void)setSlideViewController:(DVSlideViewController *)slideViewController {
    objc_setAssociatedObject(self, kSlideViewController, slideViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end