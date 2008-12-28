//
//  CustomActionSheet.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CustomActionSheet.h"


@implementation CustomActionSheet

@synthesize hueSlider;
@synthesize brightnessSlider;

/*
 *	Initialize view with maximum of two buttons
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle
			  otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		CGRect frame = CGRectMake(40, 35, 200.0, 7.0);
		hueSlider = [[[UISlider alloc] initWithFrame:frame] retain];
		frame = CGRectMake(110, 90, 200.0, 20.0);
		UILabel * brightness = [[[UILabel alloc] initWithFrame:frame] retain];
		brightness.backgroundColor = [UIColor clearColor];
		brightness.font = [UIFont systemFontOfSize:15];
		brightness.shadowColor = [UIColor blackColor];
		brightness.textColor = [UIColor whiteColor];
		brightness.text = @"Brightness";
		frame = CGRectMake(40, 85, 200.0, 7.0);
		brightnessSlider = [[[UISlider alloc] initWithFrame:frame] retain];
		// insert UITextField before first button
		BOOL inserted = NO;
		for( UIView *view in self.subviews ){
			if(!inserted && ![view isKindOfClass:[UILabel class]]) {
				[self insertSubview:hueSlider aboveSubview:view];
				[self insertSubview:brightness aboveSubview:view];
				[self insertSubview:brightnessSlider aboveSubview:view];
			}
		}
		
		//[self addSubview:myTextField];
		// ensure that layout for views is done once
		layoutDone = NO;
		
		// add a transform to move the UIAlertView above the keyboard
		//CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, kUIAlertOffset);
		//[self setTransform:myTransform];
	}
	return self;
}

/*
 *	Show alert view and make keyboard visible
 */
- (void) show {
	[super show];
	//[[self textField] becomeFirstResponder];
}

/*
 *	Override layoutSubviews to correctly handle the UITextField
 */
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect frame = [self frame];
	
	// Perform layout of subviews just once
	if(!layoutDone) {
		for(UIView *view in self.subviews){
			if ([view isKindOfClass:[UISlider class]]) {
				CGRect viewFrame = [view frame];
				viewFrame.origin.y += kUITextFieldHeight;
				[view setFrame:viewFrame];
			}
			else if(![view isKindOfClass:[UILabel class]]) {
				CGRect viewFrame = [view frame];
				viewFrame.origin.y += kUITextFieldHeight + 40;
				[view setFrame:viewFrame];
			}
		}
		
		// size UIAlertView frame height
		frame.size.height += kUITextFieldHeight + 2.0 + 50;
		[self setFrame:frame];
		layoutDone = YES;
	} else {
		// do nothing?
	}
}

@end