//
//  RootViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentNetworkManager.h"
#import "TorrentListener.h"
#import "uTorrentViewAppDelegate.h"

#import "TorrentCell.h"

@interface RootViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * torrentsTable;
	IBOutlet TorrentCell * cell;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSArray * organizedTorrents;
}

@property (nonatomic,retain) IBOutlet UITableView *torrentsTable;
@property (nonatomic,retain) uTorrentViewAppDelegate * mainAppDelegate;
@property (nonatomic, retain) NSArray * organizedTorrents;

- (void)networkRequest;
- (void)showLoadingCursor;
- (int)getSectionFromStatus:(int)status;
- (void)organize;

@end
