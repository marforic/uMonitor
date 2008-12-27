//
//  LabelCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LabelCell.h"
#import "BlueBadge.h"


@implementation LabelCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
	return self;
}

- (void)setCellDataWithLabelString:(NSString *)label withNumber:(NSDecimalNumber *)count colorString:(UIColor *)color {
	labelLabel.text = label;
	colorLabel.backgroundColor = color;
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame = CGRectMake(boundsX + 250, 12, 40, 40);
	BlueBadge *blueBadge = [[BlueBadge alloc] initWithFrame:frame];
	[blueBadge drawWithCount:[count intValue]];
	[self.contentView addSubview:blueBadge];
	[blueBadge release];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
