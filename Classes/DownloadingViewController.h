//
//  DownloadingViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TorrentListener.h"
#import "TorrentCell.h"
#import "uTorrentViewAppDelegate.h";
#import "TorrentNetworkManager.h";


@interface DownloadingViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet TorrentCell * cell;
	IBOutlet UITableView * torrentsTable;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSMutableArray * downloadingTorrents;
}

@property (nonatomic, retain) NSMutableArray * downloadingTorrents;

- (void)gatherDownloadingTorrents;
- (void)networkRequest;

@end
