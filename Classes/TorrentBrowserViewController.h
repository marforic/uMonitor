//
//  TorrentBrowser.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentWebParserDelegate.h"
@class TorrentNetworkManager;
@class TorrentWebParser;
@class TorrentBrowserCell;

@interface TorrentBrowserViewController : UITableViewController<UISearchBarDelegate, TorrentWebParserDelegate> {
	@private
	IBOutlet UISearchBar * torrentSearchBar;
	NSMutableArray * searchResult;
	TorrentNetworkManager * tnm;
	TorrentWebParser * twp;
	IBOutlet TorrentBrowserCell * cell;
}

@property(nonatomic, retain) IBOutlet UISearchBar * torrentSearchBar;
@property(nonatomic, retain) IBOutlet TorrentBrowserCell * cell;
@property(nonatomic, retain) NSMutableArray * searchResult;

@end
