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

@implementation SettingsViewController

@synthesize stringAddress, stringPort, stringUname, stringPassword, cell, tnm;

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

#pragma mark -
#pragma mark TextField Delegate Methods

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
	[cell release];
	[stringAddress release];
	[stringPort release];
	[stringUname release];
	[stringPassword release];
	[tnm release];
	[super dealloc];
}


@end

