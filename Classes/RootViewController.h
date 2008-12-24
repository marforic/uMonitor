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

@interface RootViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * torrentsTable;
	TorrentNetworkManager * tnm;
}

@property (nonatomic,retain) IBOutlet UITableView *torrentsTable;

- (void)networkRequest;
- (void)showLoadingCursor;

@end
