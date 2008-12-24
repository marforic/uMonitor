//
//  LabelsViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TorrentNetworkManager.h"
#import "TorrentListener.h"
#import "uTorrentViewAppDelegate.h"

@interface LabelsViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * labelsTable;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
}

@property (nonatomic,retain) IBOutlet UITableView *labelsTable;
@property (nonatomic,retain) uTorrentViewAppDelegate * mainAppDelegate;

@end
