//
//  DetailedViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentListener.h"

@class uTorrentViewAppDelegate;
@class TorrentNetworkManager;

@interface DetailedViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, TorrentListener> {
	@private
	IBOutlet UIView * customFooter;
	IBOutlet UIButton * startButton;
	IBOutlet UIButton * deleteButton;
	
	NSArray * torrent;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
}

@property(nonatomic, retain) IBOutlet UIView * customFooter;
@property(nonatomic, retain) IBOutlet UIButton * startButton;
@property(nonatomic, retain) IBOutlet UIButton * deleteButton;

@property(nonatomic, retain) TorrentNetworkManager * tnm;
@property(nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;
@property(nonatomic, retain) NSArray * torrent;

- (id)initWithTorrent:(NSArray *)selectedTorrent;
- (void)startButtonAction;
- (void)stopButtonAction;
- (void)deleteButtonAction;

@end
