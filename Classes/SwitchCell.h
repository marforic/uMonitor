//
//  SwitchCell.h
//  QGet-Remote
//
//  Created by Sylver Bruneau on 13/06/10.
//  Copyright 2010 Sylver Bruneau. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchCell : UITableViewCell {
	UILabel *label;
	UISwitch *switchButton;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UISwitch *switchButton;

- (void)setCellDataWithLabelString:(NSString *)labelText 
						 withState:(BOOL)state
							andTag:(NSInteger)fieldTag;

@end
