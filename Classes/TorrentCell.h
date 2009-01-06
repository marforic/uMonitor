//
//  TorrentCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "uTorrentViewAppDelegate.h"


@interface TorrentCell : UITableViewCell {
	@private
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * sizeLabel;
	IBOutlet UILabel * doneLabel;
	IBOutlet UILabel * uploadLabel;
	IBOutlet UILabel * downloadLabel;
	IBOutlet UIImageView * statusImage;
	IBOutlet UIImageView * labelImage;
	IBOutlet UIProgressView * progressView;
	UIImage * cachedLabel;
	UIImage * cachedStatus;
	UIImage * nonColoredImage;
	//uTorrentViewAppDelegate * mainAppDelegate;
}

- (void)setData:(NSArray *)data;
- (float)getProgressForBar:(NSDecimalNumber *)progress;

@end
