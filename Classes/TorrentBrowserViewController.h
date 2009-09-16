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
@class Torrent;
@class TorrentLinkCell;

@interface TorrentBrowserViewController : UITableViewController<UISearchBarDelegate, TorrentWebParserDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
	@private
	IBOutlet UISearchBar * torrentSearchBar;
	NSMutableArray * searchResult;
	TorrentNetworkManager * tnm;
	TorrentWebParser * twp;
	IBOutlet TorrentBrowserCell * cell;
	IBOutlet TorrentLinkCell * firstCell;
	IBOutlet UITextField * torrentURLTextField;
	Torrent * selectedTorrent;
	UIImageView * selectedCellImage;
}

@property(nonatomic, retain) IBOutlet UISearchBar * torrentSearchBar;
@property(nonatomic, retain) IBOutlet TorrentBrowserCell * cell;
@property(nonatomic, retain) IBOutlet TorrentLinkCell * firstCell;
@property(nonatomic, retain) IBOutlet UITextField * torrentURLTextField;
@property(nonatomic, retain) NSMutableArray * searchResult;
@property(nonatomic, retain) Torrent * selectedTorrent;
@property(nonatomic, retain) UIImageView * selectedCellImage;

@end
