//
//  TorrentCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class uTorrentViewAppDelegate;

@interface TorrentCell : UITableViewCell {
	@private
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * sizeLabel;
	IBOutlet UILabel * doneLabel;
	IBOutlet UILabel * uploadLabel;
	IBOutlet UILabel * downloadLabel;
	IBOutlet UILabel * downloadPercentageLabel;
	IBOutlet UIImageView * statusImage;
	IBOutlet UIImageView * labelImage;
	IBOutlet UIProgressView * progressView;
	UIImage * nonColoredImage;
}

@property(nonatomic, retain) IBOutlet UILabel * nameLabel;
@property(nonatomic, retain) IBOutlet UILabel * sizeLabel;
@property(nonatomic, retain) IBOutlet UILabel * doneLabel;
@property(nonatomic, retain) IBOutlet UILabel * uploadLabel;
@property(nonatomic, retain) IBOutlet UILabel * downloadLabel;
@property(nonatomic, retain) IBOutlet UILabel * downloadPercentageLabel;
@property(nonatomic, retain) IBOutlet UIImageView * statusImage;
@property(nonatomic, retain) IBOutlet UIImageView * labelImage;
@property(nonatomic, retain) IBOutlet UIProgressView * progressView;

- (void)setData:(NSArray *)data;
- (float)getProgressForBar:(NSDecimalNumber *)progress;

@end
