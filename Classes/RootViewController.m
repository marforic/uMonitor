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
#import "LabelOrganizer.h"

@implementation RootViewController

@synthesize torrentsTable, mainAppDelegate, organizers, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	tnm = [[mainAppDelegate getTNM] retain];
	[tnm addListener:self];
	
	// set the title
	self.navigationItem.title = @"Torrents";
	
	// set the refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest)];
	[Utilities showLoadingCursorForViewController:self];
	StatusOrganizer * so = [[StatusOrganizer alloc] initWithTNM:tnm];
	NameOrganizer * no = [[NameOrganizer alloc] initWithTNM:tnm];
	LabelOrganizer * lo = [[LabelOrganizer alloc] initWithTNM:tnm];
	NSArray * tmp = [[NSArray alloc] initWithObjects:so, no, lo, nil];
	self.organizers = tmp;
	[tmp release];
	currentOrganizer = 0;
	
	// search bar	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm) {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }
	
	[self networkRequest];
}

- (void)networkRequest {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	[self.navigationItem.leftBarButtonItem release];
	[Utilities showLoadingCursorForViewController:self];
	// create the request
	[tnm requestList];
}

- (void)viewDidUnload {
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredListContent = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.torrentsTable reloadData];
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

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Update the filtered array based on the search text and scope.
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	// Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	NSArray * allTorrents = tnm.torrentsData;
	for (NSArray * torrentData in allTorrents) {
		NSRange searchRange = [[torrentData objectAtIndex:NAME] rangeOfString:searchText
																	  options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
		if (searchRange.length != 0) {
			[self.filteredListContent addObject:torrentData];
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	} else {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		return [organizer getSectionNumber];
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredListContent count];
    } else {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		return [organizer getRowNumberInSection:section];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString * CellIdentifier = @"TorrentCell";//[torrentData objectAtIndex:HASH];
	cell = (TorrentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//NSLog(@"cell created! %@", CellIdentifier);
		[[NSBundle mainBundle] loadNibNamed:@"TorrentCell" owner:self options:nil];
    }
	
	NSArray * torrentData = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        torrentData = [self.filteredListContent objectAtIndex:indexPath.row];
    } else {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		torrentData = [organizer getItemInPath:indexPath];
	}

	[cell setData:torrentData];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	DetailedViewController * detailsViewController = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        detailsViewController = [[DetailedViewController alloc] initWithTorrent:[self.filteredListContent objectAtIndex:indexPath.row]];
    } else {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		detailsViewController = [[DetailedViewController alloc] initWithTorrent:[organizer getItemInPath:indexPath]];
	}
	
	[self.navigationController pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    return 80.0; //returns floating point which will be used for a cell row height at specified row index  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		return [organizer getTitleForSection:section];
	}
}

- (void)update:(NSUInteger)type {
	if (type == T_NETWORK_PROBLEM) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.navigationItem.leftBarButtonItem release];
		self.navigationItem.leftBarButtonItem = nil;
	} else if (type == T_LIST) {
		id<TorrentOrganizer> organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:currentOrganizer];
		[organizer organize];
		self.filteredListContent = [NSMutableArray arrayWithCapacity:[tnm.torrentsData count]];
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
	[filteredListContent release];
	[torrentsTable release];
	[cell release];
	[organizers release];
	[tnm release];
	[super dealloc];
}


@end

