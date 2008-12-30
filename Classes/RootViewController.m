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

@implementation RootViewController

@synthesize torrentsTable;
@synthesize mainAppDelegate;
@synthesize organizedTorrents;

- (void)viewDidLoad {
    [super viewDidLoad];
	mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	tnm = [mainAppDelegate getTNM];
	[tnm addListener:self];
	
	// set the title
	self.navigationItem.title = @"Torrents";
	// set the refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest)];
	
	[Utilities showLoadingCursorForViewController:self];
	
	self.organizedTorrents = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
	
	[self networkRequest];
}

- (void)networkRequest {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	[Utilities showLoadingCursorForViewController:self];
	// create the request
	[tnm requestList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:section];
	return [ma count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TorrentsCell";
    cell = (TorrentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TorrentCell" owner:self options:nil];
		NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:indexPath.section];
		NSArray *itemAtIndex = (NSArray *)[ma objectAtIndex:indexPath.row];
		[cell setData:itemAtIndex];
    }	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:indexPath.section];
	NSArray * itemAtIndex = (NSArray *)[ma objectAtIndex:indexPath.row];
	DetailedViewController * detailsViewController = [[DetailedViewController alloc] initWithTorrent:itemAtIndex];
	[self.navigationController pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {  
    return 80.0; //returns floating point which will be used for a cell row height at specified row index  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString * title = @"";
	switch (section) {
		case 0:
			title = ([[organizedTorrents objectAtIndex:0] count] != 0) ? @"STARTED" : @"";
			break;
		case 1:
			title = ([[organizedTorrents objectAtIndex:1] count] != 0) ? @"LEECHING" : @"";
			break;
		case 2:
			title = ([[organizedTorrents objectAtIndex:2] count] != 0) ? @"SEEDING" : @"";
			break;
		case 3:
			title = ([[organizedTorrents objectAtIndex:3] count] != 0) ? @"QUEUED" : @"";
			break;
		case 4:
			title = ([[organizedTorrents objectAtIndex:4] count] != 0) ? @"PAUSED" : @"";
			break;
		case 5:
			title = ([[organizedTorrents objectAtIndex:5] count] != 0) ? @"STOPPED": @"";
			break;
		case 6:
			title = ([[organizedTorrents objectAtIndex:6] count] != 0) ? @"FINISHED": @"";
			break;
		case 7:
			title = ([[organizedTorrents objectAtIndex:7] count] != 0) ? @"CHECKING": @"";
			break;
		case 8:
			title = ([[organizedTorrents objectAtIndex:8] count] != 0) ? @"ERROR" : @"";
			break;
		default:
			title = @"";
			break;
	}
	return title;
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

- (void)update {
	[self organize];
	[torrentsTable reloadData];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.navigationItem.leftBarButtonItem = nil;
}

- (void)organize {
	NSUInteger i, count = [tnm.torrentsData count];
	BOOL stop = NO;
	for (i = 0; i < count; i++) {
		NSArray * a = (NSArray *)[tnm.torrentsData objectAtIndex:i];
		int section = [self getSectionFromStatus:[Utilities getStatusProgrammable:[a objectAtIndex:STATUS] forProgress:[a objectAtIndex:PERCENT_PROGRESS]]];
		NSUInteger k, count2 = [organizedTorrents count];
		for (k = 0; (k < count2) && !stop; k++) {
			NSMutableArray * ma = (NSMutableArray *)[organizedTorrents objectAtIndex:k];
			NSUInteger j, count3 = [ma count];
			for (j = 0; (j < count3) && !stop; j++) {
				NSArray * b = (NSArray *)[ma objectAtIndex:j];
				if ([[a objectAtIndex:HASH] isEqual:[b objectAtIndex:HASH]]) {
					[ma removeObjectAtIndex:j];
					stop = YES;
				}
			}
		}
		[[organizedTorrents objectAtIndex:section] addObject:a];
		stop = NO;
	}
}

- (int)getSectionFromStatus:(int)status {
	int ret = 0;
	switch (status) {
		case 0:
			ret = 0;
			break;
		case 8:
			ret = 1;
			break;
		case 7:
			ret = 2;
			break;
		case 4:
			ret = 3;
			break;
		case 1:
			ret = 4;
			break;
		case 5:
			ret = 5;
			break;
		case 6:
			ret = 6;
			break;
		case 2:
			ret = 7;
			break;
		case 3:
			ret = 8;
			break;
	}
	return ret;
}

- (void)dealloc {
    [super dealloc];
	[self.organizedTorrents release];
	[tnm release];
}


@end

