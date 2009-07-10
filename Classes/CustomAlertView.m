//
//  CustomActionSheet.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"

#import "Utilities.h"


@implementation CustomAlertView

@synthesize hueSlider;
@synthesize brightnessSlider;
@synthesize plainThumbImage;

/*
 *	Initialize view with maximum of two buttons
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle
			  otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		self.plainThumbImage = [UIImage imageNamed:@"ring.png"];
		CGRect frame = CGRectMake(40, 35, 200.0, 7.0);
		hueSlider = [[[UISlider alloc] initWithFrame:frame] retain];
		hueSlider.minimumValue = 0.01;
		UIImage * stetchLeftTrack = [UIImage imageNamed:@"hue.png"];
		[hueSlider setThumbImage:self.plainThumbImage forState:UIControlStateNormal];
		//[hueSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
		//[hueSlider setMaximumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
		[hueSlider addTarget:self action:@selector(updateHueSlider) forControlEvents:UIControlEventValueChanged];
		[hueSlider addTarget:self action:@selector(updateBrightnessSlider) forControlEvents:UIControlEventValueChanged];
		frame = CGRectMake(110, 90, 200.0, 20.0);
		UILabel * brightness = [[[UILabel alloc] initWithFrame:frame] retain];
		brightness.backgroundColor = [UIColor clearColor];
		brightness.font = [UIFont systemFontOfSize:15];
		brightness.shadowColor = [UIColor blackColor];
		brightness.textColor = [UIColor whiteColor];
		brightness.text = @"Brightness";
		frame = CGRectMake(40, 85, 200.0, 7.0);
		brightnessSlider = [[[UISlider alloc] initWithFrame:frame] retain];
		stetchLeftTrack = [UIImage imageNamed:@"brightness.png"];
		[brightnessSlider setThumbImage:self.plainThumbImage forState:UIControlStateNormal];
		[brightnessSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
		[brightnessSlider setMaximumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
		[brightnessSlider addTarget:self action:@selector(updateBrightnessSlider) forControlEvents:UIControlEventValueChanged];
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

- (void) updateHueSlider {
	UIColor * color = [[UIColor alloc] initWithHue:self.hueSlider.value 
								saturation:1.0 
								brightness:1.0
									 alpha:1.0];
	UIImage * tmpImage = [Utilities colorizeImage:self.plainThumbImage 
											color:color];
	[color release];
	[hueSlider setThumbImage:tmpImage forState:UIControlStateNormal];
}

- (void) updateBrightnessSlider {
	UIColor * color = [[UIColor alloc] initWithHue:self.hueSlider.value 
										saturation: 1.0 
										brightness: self.brightnessSlider.value 
											 alpha:1.0];
	UIImage * tmpImage = [Utilities colorizeImage:self.plainThumbImage 
											color:color];
	[color release];
	[brightnessSlider setThumbImage:tmpImage forState:UIControlStateNormal];
}


/*
 *	Show alert view and update thumb for hue
 */
- (void) show {
	[super show];
	[self updateHueSlider];
	[self updateBrightnessSlider];
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