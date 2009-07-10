//
//  LabelCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uTorrentViewAppDelegate.h"

//#define kMyAlert	1337

@interface LabelCell : UITableViewCell {
	IBOutlet UILabel * labelLabel;
	IBOutlet UIImageView * labelImage;
	IBOutlet UIImage * colorizedImage;
	UIColor * labelColor;
}

@property (nonatomic,retain) UIColor * labelColor;
@property (nonatomic,retain) UIImage * colorizedImage;
@property (nonatomic,retain) IBOutlet UIImageView * labelImage;
@property (nonatomic,retain) IBOutlet UILabel * labelLabel;

- (void)setCellDataWithLabelString:(NSString *)label withNumber:(NSDecimalNumber *)count colorString:(UIColor *)color;
//- (void)colorChangedAction;


@end
