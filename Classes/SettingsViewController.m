//
//  SettingsViewController.m
//  uTorrentView
//
//  Created by Mike Godenzi on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "uTorrentViewAppDelegate.h"
#import "uTorrentConstants.h"

@implementation SettingsViewController

@synthesize stringAddress, stringPort, stringUname, stringPassword, cell, tnm;

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
	
	uTorrentViewAppDelegate *mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.tnm = [mainAppDelegate getTNM];
	
	self.navigationItem.title = @"Settings";
    self.stringAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"address_preference"];
	self.stringPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"uport_preference"];
	self.stringUname = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
	self.stringPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"pwd_preference"];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCell";
    
    self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
		switch (indexPath.row) {
			case 0:
				[cell setCellDataWithLabelString:@"Address:" withText:self.stringAddress isSecure:NO withKeyboardType:UIKeyboardTypeURL andTag:ADDRESS_TAG];
				break;
			case 1:
				[cell setCellDataWithLabelString:@"Port:" withText:self.stringPort isSecure:NO withKeyboardType:UIKeyboardTypeNumbersAndPunctuation andTag:PORT_TAG];
				break;
			case 2:
				[cell setCellDataWithLabelString:@"Username:" withText:self.stringUname isSecure:NO withKeyboardType:UIKeyboardTypeDefault andTag:UNAME_TAG];
				break;
			case 3:
				[cell setCellDataWithLabelString:@"Password:" withText:self.stringPassword isSecure:YES withKeyboardType:UIKeyboardTypeDefault andTag:PWD_TAG];
				break;

		}
    }
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


// TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField.tag == ADDRESS_TAG) {
		[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"address_preference"];
		self.tnm.settingsAddress = textField.text;
	} else if (textField.tag == PORT_TAG) {
		[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"uport_preference"];
		self.tnm.settingsPort = textField.text;
	} else if (textField.tag == UNAME_TAG) {
		[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"username_preference"];
		self.tnm.settingsUname = textField.text;
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"pwd_preference"];
		self.tnm.settingsPassword = textField.text;
	}
}

- (void)dealloc {
    [super dealloc];
	[self.stringAddress dealloc];
	[self.stringPort dealloc];
	[self.stringUname dealloc];
	[self.stringPassword dealloc];
	[self.tnm release];
}


@end

