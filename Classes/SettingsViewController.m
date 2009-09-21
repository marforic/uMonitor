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
#import "SettingsCell.h"
#import "TorrentNetworkManager.h"
#import "UserAccount.h"

@implementation SettingsViewController

@synthesize cell, tnm, userAccount;

- (id)initWithAccount:(UserAccount *)uAccount {
	if (self = [super initWithNibName:@"SettingsViewController" bundle:nil]) {
		self.userAccount = uAccount;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	uTorrentViewAppDelegate *mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.tnm = [mainAppDelegate getTNM];
	
	self.navigationItem.title = @"Settings";
}

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
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCell";
    
    self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
		switch (indexPath.row) {
			case 0:
				[cell setCellDataWithLabelString:@"Profile Name:" withText:userAccount.accountName isSecure:NO withKeyboardType:UIKeyboardTypeDefault andTag:ACCOUNT_NAME_TAG];
				break;
			case 1:
				[cell setCellDataWithLabelString:@"Address:" withText:userAccount.stringAddress isSecure:NO withKeyboardType:UIKeyboardTypeURL andTag:ADDRESS_TAG];
				break;
			case 2:
				[cell setCellDataWithLabelString:@"Port:" withText:userAccount.stringPort isSecure:NO withKeyboardType:UIKeyboardTypeNumbersAndPunctuation andTag:PORT_TAG];
				break;
			case 3:
				[cell setCellDataWithLabelString:@"Username:" withText:userAccount.stringUname isSecure:NO withKeyboardType:UIKeyboardTypeDefault andTag:UNAME_TAG];
				break;
			case 4:
				[cell setCellDataWithLabelString:@"Password:" withText:userAccount.stringPassword isSecure:YES withKeyboardType:UIKeyboardTypeDefault andTag:PWD_TAG];
				break;
		}
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark -
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField.tag == ADDRESS_TAG) {
		self.userAccount.stringAddress = textField.text;
	} else if (textField.tag == PORT_TAG) {
		self.userAccount.stringPort = textField.text;
	} else if (textField.tag == UNAME_TAG) {
		self.userAccount.stringUname = textField.text;
	} else if (textField.tag == PWD_TAG) {
		self.userAccount.stringPassword = textField.text;
	} else {
		self.userAccount.accountName = textField.text;
	}

}

- (void)dealloc {
	[cell release];
	[userAccount release];
	[tnm release];
	[super dealloc];
}


@end

