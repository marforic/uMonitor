//
//  LabelsViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelsViewController : UITableViewController {
	@private
	IBOutlet UITableView * labelsTable;
}

@property (nonatomic,retain) IBOutlet UITableView *labelsTable;

@end
