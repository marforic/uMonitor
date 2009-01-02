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
#import "TorrentOrganizer.h"

#import "TorrentCell.h"

@interface RootViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * torrentsTable;
	IBOutlet TorrentCell * cell;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSArray * organizers;
	NSUInteger currentOrganizer;
}

@property (nonatomic, retain) IBOutlet UITableView *torrentsTable;
@property (nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;
@property (nonatomic, retain) NSArray * organizers;

- (void)networkRequest;
- (void)toggleOrganizer;

@end
