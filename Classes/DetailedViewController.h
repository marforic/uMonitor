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
}

@property (nonatomic, retain) NSArray * torrent;

- (id)initWithTorrent:(NSArray *)selectedTorrent;

@end
