//
//  SettingsCell.h
//  uTorrentView
//
//  Created by Mike Godenzi on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell {
	@private
	IBOutlet UILabel * label;
	IBOutlet UITextField * textField;
}

@property(nonatomic, retain) IBOutlet UILabel * label;
@property(nonatomic, retain) IBOutlet UITextField * textField;

- (void)setCellDataWithLabelString:(NSString *)labelText 
						  withText:(NSString *)text 
						  isSecure:(BOOL)secure 
				  withKeyboardType:(UIKeyboardType)type 
							andTag:(NSInteger)fieldTag;

@end
