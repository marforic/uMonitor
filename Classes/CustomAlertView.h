//
//  CustomActionSheet.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kUITextFieldHeight 30.0
#define kUITextFieldXPadding 12.0
#define kUITextFieldYPadding 10.0
#define kUIAlertOffset 100.0

@interface CustomAlertView : UIAlertView {
	@private
	BOOL layoutDone;
	
	UISlider * hueSlider;
	UISlider * brightnessSlider;
	UIImage * plainThumbImage;
}

@property(nonatomic, retain) UISlider * hueSlider;
@property(nonatomic, retain) UISlider * brightnessSlider;
@property(nonatomic, retain) UIImage * plainThumbImage;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void) updateBrightnessSlider;
- (void) updateHueSlider;

@end
