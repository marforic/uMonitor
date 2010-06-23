/*
RootViewController.m
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
#import "ParameterOrganizer.h"

@implementation RootViewController

@synthesize torrentsTable, mainAppDelegate, organizers, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize pickerView, allPickerView;

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
	ParameterOrganizer * sio = [[ParameterOrganizer alloc] initWithTNM:tnm parameter:SIZE andLabel:@"Sort By Size"];
	ParameterOrganizer * pio = [[ParameterOrganizer alloc] initWithTNM:tnm parameter:PERCENT_PROGRESS andLabel:@"Sort By Progress"];
	NSArray * tmp = [[NSArray alloc] initWithObjects:so, no, lo, sio, pio, nil];
	self.organizers = tmp;
	[so release];
	[no release];
	[lo release];
	[sio release];
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
	
	// sorting options
	allPickerView.frame = CGRectMake(0, 63, 320, 417);
	allPickerView.hidden = YES;
	pickerView.alpha = 0.0;
	[mainAppDelegate.window addSubview:allPickerView];
	//NSLog(@"getting token");
	[tnm getToken];
	//[self networkRequest];
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
	[self networkRequest];
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
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [organizers count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[organizers objectAtIndex:row] getLabelText];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selectedSorting = row - 1 % [organizers count];
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
		//organizer = (id<TorrentOrganizer>)[self.organizers objectAtIndex:((currentOrganizer + 1) % [self.organizers count])];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self.navigationItem.leftBarButtonItem release];
		//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[organizer getLabelText] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleOrganizer)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sorting" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleOrganizer)];
		self.navigationItem.leftBarButtonItem.enabled = TRUE;
	}
}

- (void)toggleOrganizer {
	allPickerView.hidden = !allPickerView.hidden;
	if (allPickerView.hidden) {
		pickerView.alpha = 0.0;
		currentOrganizer = ((selectedSorting + 1) % [self.organizers count]);
		[self update:T_LIST];
	} else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		pickerView.alpha = 1.0;
		[UIView commitAnimations];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleOrganizer)];
	}
}

- (void)dealloc {
	[filteredListContent release];
	[torrentsTable release];
	[cell release];
	[organizers release];
	[tnm release];
	[pickerView release];
	[allPickerView release];
	[super dealloc];
}


@end

