//
//  TorrentBrowserCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TorrentFromSearch;

@interface TorrentBrowserCell : UITableViewCell {
	@private
	IBOutlet UILabel * torrentName;
	IBOutlet UILabel * torrentRatio;
	IBOutlet UILabel * torrentSize;
	TorrentFromSearch * torrent;
}

@property(nonatomic, retain) IBOutlet UILabel * torrentName;
@property(nonatomic, retain) IBOutlet UILabel * torrentRatio;
@property(nonatomic, retain) IBOutlet UILabel * torrentSize;
@property(nonatomic, retain) TorrentFromSearch * torrent;

@end
