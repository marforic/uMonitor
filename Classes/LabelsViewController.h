//
//  LabelsViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TorrentNetworkManager.h"
#import "TorrentListener.h"
#import "uTorrentViewAppDelegate.h"

#import "LabelSlidersView.h"
#import "LabelCell.h"

@interface LabelsViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * labelsTable;
	IBOutlet LabelCell * cell;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	
	LabelCell * currentlyEditingCell;
	IBOutlet UIView * fakeView;
	IBOutlet LabelSlidersView * sliderView;
	UIImage * plainThumbImage;
}

@property (nonatomic,retain) IBOutlet UITableView *labelsTable;
@property (nonatomic,retain) IBOutlet LabelCell * cell;
@property (nonatomic,retain) uTorrentViewAppDelegate * mainAppDelegate;

@property (nonatomic,retain) IBOutlet UIView * fakeView;
@property (nonatomic,retain) IBOutlet LabelSlidersView * sliderView;
@property (nonatomic,retain) LabelCell * currentlyEditingCell;
@property (nonatomic,retain) UIImage * plainThumbImage;

- (void)networkRequest;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;
- (void) updateHueSlider;
- (void) updateBrightnessSlider;

@end
