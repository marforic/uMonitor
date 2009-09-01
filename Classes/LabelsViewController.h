//
//  LabelsViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentListener.h"

@class TorrentNetworkManager;
@class uTorrentViewAppDelegate;
@class LabelSlidersView;
@class LabelCell;

@interface LabelsViewController : UITableViewController<TorrentListener> {
	@private
	IBOutlet UITableView * labelsTable;
	IBOutlet LabelCell * cell;
	IBOutlet UIView * fakeView;
	IBOutlet LabelSlidersView * sliderView;
	
	UIImage * plainThumbImage;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	LabelCell * currentlyEditingCell;
}


@property(nonatomic,retain) IBOutlet UITableView *labelsTable;
@property(nonatomic,retain) IBOutlet LabelCell * cell;
@property(nonatomic,retain) IBOutlet UIView * fakeView;
@property(nonatomic,retain) IBOutlet LabelSlidersView * sliderView;

@property(nonatomic,retain) uTorrentViewAppDelegate * mainAppDelegate;
@property(nonatomic,retain) LabelCell * currentlyEditingCell;
@property(nonatomic,retain) UIImage * plainThumbImage;
@property(nonatomic,retain) TorrentNetworkManager * tnm;

- (void)networkRequest;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;
- (void) updateHueSlider;
- (void) updateBrightnessSlider;

@end
