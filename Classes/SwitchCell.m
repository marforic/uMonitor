//
//  SwitchCell.m
//  QGet-Remote
//
//  Created by Sylver Bruneau on 13/06/10.
//  Copyright 2010 Sylver Bruneau. All rights reserved.
//

#import "SwitchCell.h"


@implementation SwitchCell

@synthesize label;
@synthesize switchButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(30,11,97,21)];
		
		[self addSubview:label];
		[self.label release];
		self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin ;
		
		self.switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(135,8,0,0)];
		
		//Set properties
		self.switchButton.userInteractionEnabled = YES;
		self.switchButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		
		[self addSubview:switchButton];
		[self.switchButton release];
    }
    return self;
}

- (void)setCellDataWithLabelString:(NSString *)labelText 
						 withState:(BOOL)state
							andTag:(NSInteger)fieldTag {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.label.text = labelText;
	[self.switchButton setOn:state animated:NO];
	self.switchButton.tag = fieldTag;
}

@end
