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
	IBOutlet UILabel * colorLabel;
}

- (void)setCellDataWithLabelString:(NSString *)label colorString:(UIColor *)color;

@end