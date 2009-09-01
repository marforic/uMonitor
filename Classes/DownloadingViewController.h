//
//  DownloadingViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentListener.h"

@class TorrentCell;
@class uTorrentViewAppDelegate;
@class TorrentNetworkManager;

@interface DownloadingViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet TorrentCell * cell;
	IBOutlet UITableView * torrentsTable;
	
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSMutableArray * downloadingTorrents;
}

@property(nonatomic, retain) IBOutlet TorrentCell * cell;
@property(nonatomic, retain) IBOutlet UITableView * torrentsTable;

@property(nonatomic, retain) NSMutableArray * downloadingTorrents;
@property(nonatomic, retain) TorrentNetworkManager * tnm;
@property(nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;

- (void)gatherDownloadingTorrents;
- (void)networkRequest;

@end
