//
//  RootViewController.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "uTorrentViewAppDelegate.h"
#import "uTorrentConstants.h"
#import "Utilities.h"
#import "TorrentCell.h"
#import "DetailedViewController.h"
#import "StatusOrganizer.h"
#import "NameOrganizer.h"
#import "TorrentNetworkManager.h"

@implementation RootViewController

@synthesize torrentsTable, mainAppDelegate, organizers;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	tnm = [[mainAppDelegate getTNM] retain];
	[tnm addListener:self];
	
	// set the title
	self.navigationItem.title = @"Torrents";
	
	// set the refresh buttoni
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest)];
	[Utilities showLoadingCursorForViewController:self];
	self.organizers = [NSArray arrayWithObjects:[[StatusOrganizer alloc] initWithTNM:tnm], [[NameOrganizer alloc] initWithTNM:tnm], nil];
	currentOrganizer = 0;
	[self networkRequest];
}

- (void)networkRequest {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	[self.navigationItem.leftBarButtonItem release];
	[Utilities showLoadingCursorForViewController:self];
	// create the request
	[tnm requestList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.torrentsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
    return [organizer getSectionNumber];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
	return [organizer getRowNumberInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
	NSArray * torrentData = [organizer getItemInPath:indexPath];
	NSString * CellIdentifier = @"TorrentCell";//[torrentData objectAtIndex:HASH];
	cell = (TorrentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//NSLog(@"cell created! %@", CellIdentifier);
		[[NSBundle mainBundle] loadNibNamed:@"TorrentCell" owner:self options:nil];
    }
	[cell setData:torrentData];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
	DetailedViewController * detailsViewController = [[DetailedViewController alloc] initWithTorrent:[organizer getItemInPath:indexPath]];
	[self.navigationController pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    return 80.0; //returns floating point which will be used for a cell row height at specified row index  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
	return [organizer getTitleForSection:section];
}

- (void)update:(NSUInteger)type {
	if (type == T_NETWORK_PROBLEM) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.navigationItem.leftBarButtonItem release];
		self.navigationItem.leftBarButtonItem = nil;
	} else if (type == T_LIST) {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		[organizer organize];
		[torrentsTable reloadData];
		organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:((currentOrganizer + 1) % [self.organizers count])];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.navigationItem.leftBarButtonItem release];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[organizer getLabelText] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleOrganizer)];
		self.navigationItem.leftBarButtonItem.enabled = TRUE;
	}
}

- (void)toggleOrganizer {
	currentOrganizer = ((currentOrganizer + 1) % [self.organizers count]);
	[self update:T_LIST];
}

- (void)dealloc {
	
	[torrentsTable release];
	[cell release];
	[organizers release];
	[tnm release];
	[super dealloc];
}


@end

