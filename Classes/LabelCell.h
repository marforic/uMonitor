//
//  LabelCell.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelCell : UITableViewCell {
	IBOutlet UILabel * labelLabel;
	IBOutlet UIImageView * labelImage;
}

- (void)setCellDataWithLabelString:(NSString *)label withNumber:(NSDecimalNumber *)count colorString:(UIColor *)color;

@end
