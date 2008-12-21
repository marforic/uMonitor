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
	UILabel * sizeLabel;
	UILabel * torrentSize;
	UILabel * progressLabel;
	UILabel * torrentProgress;
	UILabel * downloadedLabel;
	UILabel * torrentDownloaded;
	UILabel * uploadedLabel;
	UILabel * torrentUploaded;
	UILabel * ratioLabel;
	UILabel * torrentRatio;
	UILabel * uspeedLabel;
	UILabel * torrentUspeed;
	UILabel * dspeedLabel;
	UILabel * torrentDspeed;
	UILabel * etaLabel;
	UILabel * torrentEta;
	UILabel * peersLabel;
	UILabel * torrentPeers;
	UILabel * seedsLabel;
	UILabel * torrentSeeds;
	UILabel * availLabel;
	UILabel * torrentAvail;
	UILabel * remLabel;
	UILabel * torrentRem;
}

@property (nonatomic, retain) NSArray * torrent;
@property (nonatomic, retain) UIButton * actionButton;
@property (nonatomic, retain) UILabel * torrentTitle;
@property (nonatomic, retain) UILabel * statusLabel;
@property (nonatomic, retain) UILabel * torrentStatus;
@property (nonatomic, retain) UILabel * sizeLabel;
@property (nonatomic, retain) UILabel * torrentSize;
@property (nonatomic, retain) UILabel * progressLabel;
@property (nonatomic, retain) UILabel * torrentProgress;
@property (nonatomic, retain) UILabel * downloadedLabel;
@property (nonatomic, retain) UILabel * torrentDownloaded;
@property (nonatomic, retain) UILabel * uploadedLabel;
@property (nonatomic, retain) UILabel * torrentUploaded;
@property (nonatomic, retain) UILabel * ratioLabel;
@property (nonatomic, retain) UILabel * torrentRatio;
@property (nonatomic, retain) UILabel * uspeedLabel;
@property (nonatomic, retain) UILabel * torrentUspeed;
@property (nonatomic, retain) UILabel * dspeedLabel;
@property (nonatomic, retain) UILabel * torrentDspeed;
@property (nonatomic, retain) UILabel * etaLabel;
@property (nonatomic, retain) UILabel * torrentEta;
@property (nonatomic, retain) UILabel * peersLabel;
@property (nonatomic, retain) UILabel * torrentPeers;
@property (nonatomic, retain) UILabel * seedsLabel;
@property (nonatomic, retain) UILabel * torrentSeeds;
@property (nonatomic, retain) UILabel * availLabel;
@property (nonatomic, retain) UILabel * torrentAvail;
@property (nonatomic, retain) UILabel * remLabel;
@property (nonatomic, retain) UILabel * torrentRem;

- (id)initWithTorrent:(NSArray *)selectedTorrent;
- (void)updateLabels;
@end
