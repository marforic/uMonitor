//
//  LabelSlidersView.h
//  uTorrentView
//
//  Created by Claudio Marforio on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelSlidersView : UIView {
	IBOutlet UISlider * hue;
	IBOutlet UISlider * brightness;
}

@property (nonatomic,retain) IBOutlet UISlider * hue;
@property (nonatomic,retain) IBOutlet UISlider * brightness;

@end
