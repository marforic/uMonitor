//
//  TorrentBrowserCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TorrentBrowserCell : UITableViewCell {
	@private
	IBOutlet UILabel * torrentName;
	IBOutlet UILabel * torrentSeeds;
	IBOutlet UILabel * torrentLeechers;
	IBOutlet UILabel * torrentSize;
	IBOutlet UILabel * torrentCategory;
	IBOutlet UIImageView * torrentSite;
}

@property(nonatomic, retain) IBOutlet UILabel * torrentName;
@property(nonatomic, retain) IBOutlet UILabel * torrentSeeds;
@property(nonatomic, retain) IBOutlet UILabel * torrentSize;
@property(nonatomic, retain) IBOutlet UILabel * torrentLeechers;
@property(nonatomic, retain) IBOutlet UILabel * torrentCategory;
@property(nonatomic, retain) IBOutlet UIImageView * torrentSite;

@end
