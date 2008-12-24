//
//  DetailedViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailedViewController : UITableViewController {
	@private
	NSArray * torrent;
	IBOutlet UIView * customFooter;
	IBOutlet UIButton * startButton;
	IBOutlet UIButton * deleteButton;
}

@property (nonatomic, retain) NSArray * torrent;
@property (nonatomic, retain) IBOutlet UIView * customFooter;
@property (nonatomic, retain) IBOutlet UIButton * startButton;
@property (nonatomic, retain) IBOutlet UIButton * deleteButton;

- (id)initWithTorrent:(NSArray *)selectedTorrent;


@end
