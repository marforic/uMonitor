//
//  DetailsViewController.h
//  uTorrentView
//
//  Created by Mike Godenzi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailsViewController : UIViewController {
	@private
	NSArray * torrent;
	UIButton * actionButton;
	UILabel * torrentTitle;
	UILabel * statusLabel;
	UILabel * torrentStatus;
	UILabel * torrentSize;
	UILabel * torrentProgress;
	UILabel * torrentDownloaded;
	UILabel * torrentUploaded;
	UILabel * torrentRatio;
	UILabel * torrentUspeed;
	UILabel * torrentDspeed;
	UILabel * torrentEta;
	UILabel * torrentPeers;
	UILabel * torrentSeeds;
	UILabel * torrentAvail;
	UILabel * torrentRem;
}

@property (nonatomic, retain) NSArray * torrent;
@property (nonatomic, retain) UIButton * actionButton;
@property (nonatomic, retain) UILabel * torrentTitle;
@property (nonatomic, retain) UILabel * statusLabel;
@property (nonatomic, retain) UILabel * torrentStatus;
@property (nonatomic, retain) UILabel * torrentSize;
@property (nonatomic, retain) UILabel * torrentProgress;
@property (nonatomic, retain) UILabel * torrentDownloaded;
@property (nonatomic, retain) UILabel * torrentUploaded;
@property (nonatomic, retain) UILabel * torrentRatio;
@property (nonatomic, retain) UILabel * torrentUspeed;
@property (nonatomic, retain) UILabel * torrentDspeed;
@property (nonatomic, retain) UILabel * torrentEta;
@property (nonatomic, retain) UILabel * torrentPeers;
@property (nonatomic, retain) UILabel * torrentSeeds;
@property (nonatomic, retain) UILabel * torrentAvail;
@property (nonatomic, retain) UILabel * torrentRem;

-(id) initWithTorrent:(NSArray *)selectedTorrent;
@end
