//
//  DownloadingViewController.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DownloadingViewController.h"
#import "Utilities.h"
#import "uTorrentConstants.h"
#import "DetailedViewController.h"
#import "TorrentCell.h"
#import "uTorrentViewAppDelegate.h"

@implementation DownloadingViewController

@synthesize downloadingTorrents, cell, torrentsTable, tnm, mainAppDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

	self.mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.tnm = [mainAppDelegate getTNM];
	[tnm addListener:self];
	
	self.downloadingTorrents = [[NSMutableArray alloc] init];
	
	// set the title
	self.navigationItem.title = @"Downloading";
	// set the refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest)];
	
	[self update:T_LIST];
}


- (void)networkRequest {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	[Utilities showLoadingCursorForViewController:self];
	// create the request
	[tnm requestList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[torrentsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)gatherDownloadingTorrents {
	[downloadingTorrents removeAllObjects];
	for (NSArray* t in [tnm torrentsData]) {
		NSDecimalNumber * tStatus = [t objectAtIndex:STATUS];
		NSDecimalNumber * tProgress = [t objectAtIndex:PERCENT_PROGRESS];
		if ([Utilities getStatusProgrammable:tStatus forProgress:tProgress] == LEECHING) {
			[downloadingTorrents addObject:t];
		}
	}
}

- (void)update:(NSUInteger)type {
	[self gatherDownloadingTorrents];
	[torrentsTable reloadData];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.navigationItem.leftBarButtonItem release];
	self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [downloadingTorrents count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DownloadingTorrentsCell";
    self.cell = (TorrentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TorrentCell" owner:self options:nil];
		NSArray *itemAtIndex = (NSArray *)[downloadingTorrents objectAtIndex:indexPath.row];
		[cell setData:itemAtIndex];
    }	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    return 80.0; //returns floating point which will be used for a cell row height at specified row index  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray * itemAtIndex = (NSArray *)[downloadingTorrents objectAtIndex:indexPath.row];
	DetailedViewController * detailsViewController = [[DetailedViewController alloc] initWithTorrent:itemAtIndex];
	[self.navigationController pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}

- (void)dealloc {
	[cell release];
	[torrentsTable release];
	[tnm release];
	[mainAppDelegate release];
	[downloadingTorrents release];
    [super dealloc];
}

@end