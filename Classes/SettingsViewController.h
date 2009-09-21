//
//  SettingsViewController.h
//  uTorrentView
//
//  Created by Mike Godenzi on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsCell;
@class TorrentNetworkManager;
@class UserAccount;

@interface SettingsViewController : UITableViewController<UITextFieldDelegate> {
	@private
	UserAccount * userAccount;
	TorrentNetworkManager * tnm;
	
	IBOutlet SettingsCell * cell;
}

@property(nonatomic, retain) IBOutlet SettingsCell * cell;
@property(nonatomic, retain) TorrentNetworkManager * tnm;
@property(nonatomic, retain) UserAccount * userAccount;

- (id)initWithAccount:(UserAccount *)uAccount;

@end
