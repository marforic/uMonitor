/*
CustomAlertView.m
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
		frame = CGRectMake(110, 90, 200.0, 20.0);
		UILabel * brightness = [[[UILabel alloc] initWithFrame:frame] retain];
		brightness.backgroundColor = [UIColor clearColor];
		brightness.font = [UIFont systemFontOfSize:15];
		brightness.shadowColor = [UIColor blackColor];
		brightness.textColor = [UIColor whiteColor];
		brightness.text = @"Brightness";
		frame = CGRectMake(40, 85, 200.0, 7.0);
		brightnessSlider = [[[UISlider alloc] initWithFrame:frame] retain];
		BOOL inserted = NO;
		for( UIView *view in self.subviews ){
			if(!inserted && ![view isKindOfClass:[UILabel class]]) {
				[self insertSubview:hueSlider aboveSubview:view];
				[self insertSubview:brightness aboveSubview:view];
				[self insertSubview:brightnessSlider aboveSubview:view];
			}
		}
		
		// ensure that layout for views is done once
		layoutDone = NO;
		
		// add a transform to move the UIAlertView above the keyboard
		//CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, kUIAlertOffset);
		//[self setTransform:myTransform];
	}
	return self;
}

- (void)updateHueSlider {
	UIColor * color = [[UIColor alloc] initWithHue:self.hueSlider.value 
								saturation:1.0 
								brightness:1.0
									 alpha:1.0];
	UIImage * tmpImage = [Utilities colorizeImage:self.plainThumbImage 
											color:color];
	[color release];
	[hueSlider setThumbImage:tmpImage forState:UIControlStateNormal];
}

- (void)updateBrightnessSlider {
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
- (void)show {
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

- (void)dealloc {
	[hueSlider release];
	[brightnessSlider release];
	[plainThumbImage release];
	[super dealloc];
}

@end