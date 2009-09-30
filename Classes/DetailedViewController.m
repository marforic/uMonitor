//
//  DetailedViewController.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailedViewController.h"

#import "uTorrentConstants.h"
#import "Utilities.h"
#import "TorrentNetworkManager.h"
#import "uTorrentViewAppDelegate.h"

@implementation DetailedViewController

@synthesize torrent, customFooter, startButton, deleteButton, tnm, mainAppDelegate;

- (id)initWithTorrent:(NSArray *)selectedTorrent {
	if (self = [super initWithStyle:UITableViewStyleGrouped])
		self.torrent = selectedTorrent;
	self.mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	tnm = [mainAppDelegate getTNM];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Torrent details";
}

- (void)viewDidAppear:(BOOL)animated {
	[tnm addListener:self];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[tnm removeListener:self];
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Buttons methods

- (void)startButtonAction {
	[tnm actionStartForTorrent:[self.torrent objectAtIndex:HASH]];
	//NSLog(@"Start Button");
}

- (void)stopButtonAction {
	[tnm actionStopForTorrent:[self.torrent objectAtIndex:HASH]];
	NSLog(@"Stop Button");
}

- (void)deleteButtonAction {
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete Torrent"
															 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
													otherButtonTitles:@"Cancel", @"Delete .torrent", @"Delete .torrent and data", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch(buttonIndex) {
		case 0: // cancel
			break;
		case 1: // delete .torrent only
			[tnm actionDeleteForTorrent:[self.torrent objectAtIndex:HASH]];
			//NSLog(@".torrent deleted");
			break;
		case 2: // delete .torrent and data
			[Utilities alertOKCancelAction:@"Confirm data deletion" 
								andMessage:@"You are going to destroy data that has been downloaded, are you sure?" 
							  withDelegate:self];
			break;
		default:
			break;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1: // OK
			[tnm actionDeleteData:[self.torrent objectAtIndex:HASH]];
			//NSLog(@"Doom be upon you, you are deleting everything!");
			break;
		default:
			break;
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString * title = nil;
	switch (section) {
		case 0:
			title = [self.torrent objectAtIndex:NAME];
			break;
		default:
			title = @"";
	}
	return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 80.0;
}


- (UIView *)tableView: (UITableView *)tableView viewForFooterInSection: (NSInteger)section {
	[[NSBundle mainBundle] loadNibNamed:@"CustomFooterView"	owner:self options:nil];
	
	// action for delete button
	[self.deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchDown];
	
	// action for start button
	[self.startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchDown];
	
	// check if the torrent is running or not to set the start/stop button accordingly
	int torrentStatus = [Utilities getStatusProgrammable:[self.torrent objectAtIndex:STATUS]
											 forProgress:[self.torrent objectAtIndex:PERCENT_PROGRESS]];
	if (torrentStatus == SEEDING || torrentStatus == LEECHING || torrentStatus == QUEUED) {
		[self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
		[self.startButton setTitle:@"Stop" forState:UIControlStateHighlighted];
		[self.startButton removeTarget:self	action:@selector(startButtonAction) forControlEvents:UIControlEventTouchDown];
		[self.startButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchDown];
	}
	else if (torrentStatus == CHECKING || torrentStatus == ERROR)
		self.startButton.enabled = NO;
	
	return self.customFooter;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 13; // we do not report everything, otherwise uncomment below and comment this
    //return [self.torrent count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSString * cellContent = [NSString alloc];
	int index;
	switch (index = [indexPath indexAtPosition:1]) {
		case 0:
			cellContent = @"Size: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSizeReadable:[self.torrent objectAtIndex:SIZE]]];
			break;
		case 1:
			cellContent = @"Done: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSizeReadable:[self.torrent objectAtIndex:DOWNLOADED]]];
			break;
		case 2:
			cellContent = @"Remaining: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSizeReadable:[self.torrent objectAtIndex:REMAINING]]];
			break;
		case 3:
			cellContent = @"Status: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getStatusReadable:[self.torrent objectAtIndex:STATUS]
																				forProgress:[self.torrent objectAtIndex:PERCENT_PROGRESS]]];
			break;
		case 4:
			cellContent = @"Downloaded: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSizeReadable:[self.torrent objectAtIndex:DOWNLOADED]]];
			break;
		case 5:
			cellContent = @"Uploaded: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSizeReadable:[self.torrent objectAtIndex:UPLOADED]]];
			break;
		case 6:
			cellContent = @"Ratio: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getRatioReadable:[self.torrent objectAtIndex:RATIO]]];
			break;
		case 7:
			cellContent = @"Upload Speed: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSpeedReadable:[self.torrent objectAtIndex:UPLOAD_SPEED]]];
			break;
		case 8:
			cellContent = @"Download Speed: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getSpeedReadable:[self.torrent objectAtIndex:DOWNLOAD_SPEED]]];
			break;
		case 9:
			cellContent = @"ETA: ";
			cellContent = [cellContent stringByAppendingString:[Utilities getETAReadable:[self.torrent objectAtIndex:ETA]]];
			break;
		case 10:
			cellContent = @"Label: ";
			cellContent = [cellContent stringByAppendingString:([[self.torrent objectAtIndex:LABEL] length] != 0) ? [self.torrent objectAtIndex:LABEL] : @"No Label"];
			break;
		case 11:
			cellContent = @"Availability ";
			cellContent = [cellContent stringByAppendingString:[Utilities getAvailabilityReadable:[self.torrent objectAtIndex:AVAILABILITY]]];
			break;
		case 12:
			cellContent = @"Queue Order: ";
			cellContent = ([[self.torrent objectAtIndex:TORRENT_QUEUE_ORDER] intValue] == -1) ?
								[cellContent stringByAppendingString:@"*"] :
								[cellContent stringByAppendingString:[[self.torrent objectAtIndex:TORRENT_QUEUE_ORDER] stringValue]];
			break;
		default:
			cellContent = @"";
			break;
	}
	
	cell.text = cellContent;
    return cell;
}

- (void)update:(NSUInteger)type {
	//NSLog(@"I should have reloaded my data!");
	for (NSArray * t in tnm.torrentsData) {
		if ([[t objectAtIndex:HASH] isEqual:[self.torrent objectAtIndex:HASH]]) {
			self.torrent = t;
			break;
		}
	}
	[self.tableView reloadData];
	// TODO: make this happen only after a delete
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[tnm removeListener:self];
	[customFooter release];
	[startButton release];
	[deleteButton release];
	[torrent release];
	[tnm release];
	[mainAppDelegate release];
    [super dealloc];
}

@end

