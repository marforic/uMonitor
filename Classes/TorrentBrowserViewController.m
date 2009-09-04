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
#import "TorrentFromSearch.h"

@implementation TorrentBrowserViewController

@synthesize torrentSearchBar, cell, searchResult;

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
    return [searchResult count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TorrentBrowserCell";
    
    self.cell = (TorrentBrowserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TorrentBrowserCell" owner:self options:nil];
    }
	
    // Set up the cell...
	TorrentFromSearch * torrent = [searchResult objectAtIndex:indexPath.row];
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
	cell.torrentCategory.text = ([torrent.categoryName isKindOfClass:[NSString class]]) ? torrent.categoryName : @"No category";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TorrentFromSearch * torrent = [searchResult objectAtIndex:indexPath.row];
	NSString * torrentURL = [torrent.link stringByReplacingOccurrencesOfString:@"/tor/" withString:@"/get/"];
	[tnm addTorrent:torrentURL];
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[twp parseRSSResultsForQuery:torrentSearchBar.text andDelegate:self];
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
	[tnm release];
	[twp release];
	[cell release];
    [super dealloc];
}


@end

