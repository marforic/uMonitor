//
//  SettingsCell.m
//  uTorrentView
//
//  Created by Mike Godenzi on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsCell.h"


@implementation SettingsCell

@synthesize label, textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithLabelString:(NSString *)labelText withText:(NSString *)fieldText isSecure:(BOOL)secure withKeyboardType:(UIKeyboardType)type  andTag:(NSInteger)fieldTag{
	self.label.text = labelText;
	self.textField.text = fieldText;
	[self.textField setSecureTextEntry:secure];
	[self.textField setKeyboardType:type];
	self.textField.clearsOnBeginEditing = NO;
	self.textField.tag = fieldTag;
}


- (void)dealloc {
    [super dealloc];
}


@end
