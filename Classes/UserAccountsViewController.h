//
//  UserAccountsViewController.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TorrentNetworkManager;

@interface UserAccountsViewController : UITableViewController<UITextFieldDelegate> {
	@private
	NSMutableArray * accounts;
	UIBarButtonItem * editButton;
	NSInteger selectedAccountIndex;
	TorrentNetworkManager * tnm;
	UITableViewCell * cell;
	BOOL needToSave;
}

@property(nonatomic, retain) NSMutableArray * accounts;
@property(nonatomic, retain)  UITableViewCell * cell;

@end
