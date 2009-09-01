//
//  RootViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentListener.h"
#import "TorrentOrganizer.h"

@class TorrentNetworkManager;
@class uTorrentViewAppDelegate;
@class TorrentCell;

@interface RootViewController : UITableViewController<TorrentListener> {
	@private
	NSUInteger currentOrganizer;
	IBOutlet UITableView * torrentsTable;
	IBOutlet TorrentCell * cell;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSArray * organizers;
}

@property(nonatomic, retain) IBOutlet UITableView *torrentsTable;
@property(nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;
@property(nonatomic, retain) NSArray * organizers;

- (void)networkRequest;
- (void)toggleOrganizer;

@end
