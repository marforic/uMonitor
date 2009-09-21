//
//  TorrentBrowser.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TorrentBrowserViewController.h"
#import "TorrentNetworkManager.h"
#import "uTorrentViewAppDelegate.h"
#import "TorrentWebParser.h"
#import "TorrentBrowserCell.h"
#import "TorrentLinkCell.h"
#import "Torrent.h"
#import "Utilities.h"

@implementation TorrentBrowserViewController

@synthesize torrentSearchBar, cell, searchResult, selectedTorrent, selectedCellImage, firstCell, torrentURLTextField;

- (id)initWithCoder:(NSCoder *)coder {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithCoder:coder]) {
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	uTorrentViewAppDelegate * appDel = [[UIApplication sharedApplication] delegate];
	tnm = [[appDel getTNM] retain];
	twp = [[TorrentWebParser alloc] init];
	torrentURLTextField.delegate = self;
	self.navigationItem.title = @"Search and add torrents";
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResult count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TorrentBrowserCell";
	static NSString *firstCellIdentifier = @"TorrentLinkCell";
    UITableViewCell * result;
	if (indexPath.row > 0) {
		self.cell = (TorrentBrowserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"TorrentBrowserCell" owner:self options:nil];
		}
		
		// Set up the cell...
		Torrent * torrent = [searchResult objectAtIndex:(indexPath.row - 1)];
		cell.torrentName.text = torrent.title;
		NSString * size = [[NSString alloc] initWithFormat:@"%2.2f %@", torrent.size, torrent.unit];
		cell.torrentSize.text = size;
		[size release];
		NSString * seeds = [[NSString alloc] initWithFormat:@"%i", torrent.seeds];
		cell.torrentSeeds.text = seeds;
		[seeds release];
		NSString * leechers = [[NSString alloc] initWithFormat:@"%i", torrent.leechers];
		cell.torrentLeechers.text = leechers;
		[leechers release];
		cell.torrentCategory.text = torrent.categoryName;
		if ([torrent.link rangeOfString:@"www.mininova.org"].location != NSNotFound) {
			cell.torrentSite.image = [UIImage imageNamed:@"mininova.png"];
		}
		result = cell;
	} else {
		self.firstCell = (TorrentLinkCell *)[tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
		if (firstCell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"TorrentLinkCell" owner:self options:nil];
		}
		result = firstCell;
	}

    return result;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = indexPath.row - 1;
	if (index <= 0) {
		[self.tableView cellForRowAtIndexPath:indexPath].selected = NO;
		return;
	}
	
    self.selectedTorrent = [searchResult objectAtIndex:(indexPath.row - 1)];
	self.selectedCellImage = ((TorrentBrowserCell *)[self.tableView cellForRowAtIndexPath:indexPath]).torrentSite;
	[Utilities alertOKCancelAction:@"Start downloading" 
						andMessage:@"Are you sure you want to start downloading the selected torrent?" 
					  withDelegate:self];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString * torrentURL = [selectedTorrent.link stringByReplacingOccurrencesOfString:@"/tor/" withString:@"/get/"];
	switch (buttonIndex) {
		case 1: // OK
			[tnm addTorrent:torrentURL];
			self.selectedCellImage.image = [UIImage imageNamed:@"ok.png"];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[tnm addTorrent:torrentURLTextField.text];
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[twp parseRSSResultsForQuery:torrentSearchBar.text andDelegate:self];
	[torrentSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[torrentSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark TorrentWebParserDelegate Methods

- (void)torrentWebParserDidFinishParsing:(NSMutableArray *)resultTorrents {
	self.searchResult = resultTorrents;
	[self.tableView reloadData];
}

- (void)dealloc {
	[torrentSearchBar release];
	[selectedTorrent release];
	[selectedCellImage release];
	[tnm release];
	[twp release];
	[cell release];
	[firstCell release];
	[torrentURLTextField release];
    [super dealloc];
}


@end

