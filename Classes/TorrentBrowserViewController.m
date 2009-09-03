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

@synthesize torrentSearchBar, cell;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	uTorrentViewAppDelegate * appDel = [[UIApplication sharedApplication] delegate];
	tnm = [[appDel getTNM] retain];
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
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TorrentBrowserCell";
    
    cell = (TorrentBrowserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
    // Set up the cell...
	/*
	TorrentFromSearch * torrent = [allTorrents objectAtIndex:indexPath.row];
	cell.torrent = torrent;
	cell.torrentName = torrent.name;
	NSString * size = [[NSString alloc] initWithFormat:@"%f MB", torrent.size];
	cell.torrentSize = size;
	[size release];
	NSString * ratio = [[NSString alloc] initWithFormat:@"Seeds: %i - Leechers: %i", torrent.seeds, torrent.leechers];
	cell.torrentRatio = ratio;
	[ratio release];
	*/
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString * result = [tnm searchTorrentForQuery:torrentSearchBar.text];
	[TorrentWebParser parseRSSResults:result];
}

- (void)dealloc {
	[torrentSearchBar release];
	[tnm release];
	[cell release];
    [super dealloc];
}


@end

