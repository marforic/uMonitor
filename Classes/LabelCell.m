//
//  LabelCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LabelCell.h"


@implementation LabelCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setCellDataWithLabelString:(NSString *)label colorString:(UIColor *)color {
	labelLabel.text = label;
	colorLabel.backgroundColor = color;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
