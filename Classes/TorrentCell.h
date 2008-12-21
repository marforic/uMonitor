//
//  TorrentCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TorrentCell : UITableViewCell {
	@private
	UILabel * titleLabel;
	UILabel * statusLabel;
	UILabel * sizeLabel;
	UILabel * doneLabel;
	UILabel * DLLabel;
	UILabel * ULLabel;
	UILabel * ETALabel;
	UILabel * PeersLabel;
	UILabel * SeedsLabel;
}

@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * statusLabel;
@property (nonatomic, retain) UILabel * sizeLabel;
@property (nonatomic, retain) UILabel * doneLabel;
@property (nonatomic, retain) UILabel * DLLabel;
@property (nonatomic, retain) UILabel * ULLabel;
@property (nonatomic, retain) UILabel * ETALabel;
@property (nonatomic, retain) UILabel * PeersLabel;
@property (nonatomic, retain) UILabel * SeedsLabel;

- (void)setData:(NSArray *)data;
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
-(NSString *)getSizeReadable:(NSDecimalNumber *)size;
-(NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress;

@end
