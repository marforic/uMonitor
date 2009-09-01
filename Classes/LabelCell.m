//
//  LabelCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LabelCell.h"
#import "BlueBadge.h"
#import "Utilities.h"
//#import "CustomAlertView.h"


@implementation LabelCell

@synthesize labelColor;
@synthesize colorizedImage;
@synthesize labelImage;
@synthesize labelLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
	return self;
}

- (void)setCellDataWithLabelString:(NSString *)label withNumber:(NSDecimalNumber *)count colorString:(UIColor *)color {
	
	self.labelColor = color;
	labelLabel.text = label;

	self.colorizedImage = [Utilities colorizeImage:labelImage.image color:color];
	UIImage * tmpImage = labelImage.image;
	labelImage.image = colorizedImage;
	self.colorizedImage = tmpImage;
	
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame = CGRectMake(boundsX + 250, 12, 40, 40);
	BlueBadge *blueBadge = [[BlueBadge alloc] initWithFrame:frame];
	[blueBadge drawWithCount:[count intValue]];
	[self.contentView addSubview:blueBadge];
	[blueBadge release];
}

- (void)dealloc {
	[labelLabel release];
	[labelImage release];
	[colorizedImage release];
	[labelColor release];
    [super dealloc];
}


@end
