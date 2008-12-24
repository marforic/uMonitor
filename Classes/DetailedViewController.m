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


@implementation DetailedViewController

@synthesize torrent;
@synthesize customFooter;
@synthesize startButton, deleteButton;

- (id)initWithTorrent:(NSArray *)selectedTorrent {
	if (self = [super initWithStyle:UITableViewStyleGrouped])
		self.torrent = selectedTorrent;
	//NSLog(@"%@", self.torrent);
    return self;
}

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
	self.navigationItem.title = @"Torrent details";
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

#pragma mark Buttons methods
- (void)startButtonAction {
	NSLog(@"Start Button");
}

- (void)stopButtonAction {
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
			// TODO: call the deletion of .torrent file
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
			// TODO: call the deletion of .torrent file and data
			NSLog(@"Doom be upon you, you are deleting everything!");
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
	if (torrentStatus == STARTED || torrentStatus == QUEUED) {
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
			cellContent = [cellContent stringByAppendingString:[self.torrent objectAtIndex:LABEL]];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

