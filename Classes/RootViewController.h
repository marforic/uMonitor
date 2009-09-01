//
//  RootViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentListener.h"
#import "TorrentOrganizer.h"

@class TorrentNetworkManager;
@class uTorrentViewAppDelegate;
@class TorrentCell;

@interface RootViewController : UITableViewController<TorrentListener, UISearchDisplayDelegate, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
	@private
	NSUInteger currentOrganizer;
	NSInteger savedScopeButtonIndex;
	NSInteger selectedSorting;
	BOOL searchWasActive;
	IBOutlet UITableView * torrentsTable;
	IBOutlet TorrentCell * cell;
	IBOutlet UIPickerView * pickerView;
	IBOutlet UIView * allPickerView;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSArray * organizers;
	NSMutableArray * filteredListContent;
	NSString * savedSearchTerm;
}

@property(nonatomic, retain) IBOutlet UITableView *torrentsTable;
@property(nonatomic, retain) IBOutlet UIPickerView * pickerView;
@property(nonatomic, retain) IBOutlet UIView * allPickerView;
@property(nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;
@property(nonatomic, retain) NSArray * organizers;

@property(nonatomic, retain) NSMutableArray * filteredListContent;
@property(nonatomic, copy) NSString * savedSearchTerm;
@property(nonatomic) NSInteger savedScopeButtonIndex;
@property(nonatomic) BOOL searchWasActive;

- (void)networkRequest;
- (void)toggleOrganizer;

@end
