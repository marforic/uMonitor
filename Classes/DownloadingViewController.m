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

@implementation DownloadingViewController

@synthesize downloadingTorrents;

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

	mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	tnm = [mainAppDelegate getTNM];
	[tnm addListener:self];
	
	downloadingTorrents = [[NSMutableArray alloc] init];
	
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

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[torrentsTable reloadData];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    cell = (TorrentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

