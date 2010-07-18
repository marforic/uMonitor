//
//  CustomTabBarController.m
//  QGet-Remote
//
//  Created by Sylver Bruneau on 02/07/10.
//  Copyright 2010 Sylver Bruneau. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
		(interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
		(interfaceOrientation == UIInterfaceOrientationPortrait)) {
		return YES;
	} else {
		return NO;
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
		(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    } else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation { 
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
	
	UIView *mainView = [self.view.subviews objectAtIndex:0];
	
	if(toOrientation == UIInterfaceOrientationLandscapeLeft || toOrientation == UIInterfaceOrientationLandscapeRight) {                                     
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.2];
		
		[self.tabBar setAlpha:0.0];
		mainView.frame = CGRectMake(0, 0, 480, 320 );
		
        [UIView commitAnimations];
 	} else {                               
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.2];
		
		[self.tabBar setAlpha:1.0];
		mainView.frame = CGRectMake(0, 0, 320, 431 );         
		
        [UIView commitAnimations];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
