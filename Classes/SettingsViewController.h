//
//  SettingsViewController.h
//  uTorrentView
//
//  Created by Mike Godenzi on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCell.h"
#import "TorrentNetworkManager.h"

@interface SettingsViewController : UITableViewController<UITextFieldDelegate> {
	@private
	NSString *stringAddress;
	NSString *stringPort;
	NSString *stringUname;
	NSString *stringPassword;
	TorrentNetworkManager *tnm;
	
	IBOutlet SettingsCell *cell;
}

@property (nonatomic, retain) NSString * stringAddress;
@property (nonatomic, retain) NSString * stringPort;
@property (nonatomic, retain) NSString * stringUname;
@property (nonatomic, retain) NSString * stringPassword;
@property (nonatomic, retain) IBOutlet SettingsCell *cell;
@property (nonatomic, retain) TorrentNetworkManager *tnm;

@end
