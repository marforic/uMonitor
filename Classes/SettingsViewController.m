/*
SettingsViewController.m
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

#import "SettingsViewController.h"
#import "uTorrentViewAppDelegate.h"
#import "uTorrentConstants.h"
#import "SettingsCell.h"
#import "TorrentNetworkManager.h"
#import "UserAccount.h"

@implementation SettingsViewController

@synthesize cell, switchCell, tnm, userAccount;

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
    return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *SwitchCellIdentifier = @"SwitchCell";
	
	UITableViewCell *newCell;
    
	switch (indexPath.row) {
		case 0:
			[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
			if (cell == nil)
				self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			[cell setCellDataWithLabelString:@"Profile Name:" withText:userAccount.accountName isSecure:NO withKeyboardType:UIKeyboardTypeDefault andTag:ACCOUNT_NAME_TAG];
			newCell = cell;
			break;
		case 1:
			[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
			if (cell == nil)
				self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			[cell setCellDataWithLabelString:@"Address:" withText:userAccount.stringAddress isSecure:NO withKeyboardType:UIKeyboardTypeURL andTag:ADDRESS_TAG];
			newCell = cell;
			break;
		case 2:
			[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
			if (cell == nil)
				self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			[cell setCellDataWithLabelString:@"Port:" withText:userAccount.stringPort isSecure:NO withKeyboardType:UIKeyboardTypeNumbersAndPunctuation andTag:PORT_TAG];
			newCell = cell;
			break;
		case 3:
			[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
			if (cell == nil)
				self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			[cell setCellDataWithLabelString:@"Username:" withText:userAccount.stringUname isSecure:NO withKeyboardType:UIKeyboardTypeDefault andTag:UNAME_TAG];
			newCell = cell;
			break;
		case 4:
			[[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
			if (cell == nil)
				self.cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			[cell setCellDataWithLabelString:@"Password:" withText:userAccount.stringPassword isSecure:YES withKeyboardType:UIKeyboardTypeDefault andTag:PWD_TAG];
			newCell = cell;
			break;
		case 5:
			switchCell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
			if (switchCell == nil) {
				switchCell = [[[SwitchCell alloc] initWithFrame:CGRectZero reuseIdentifier:SwitchCellIdentifier] autorelease];
			}
			[switchCell setCellDataWithLabelString:NSLocalizedString(@"SSL:",@"")
										 withState:userAccount.boolSSL
											andTag:SSL_TAG];
			[switchCell.switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
			newCell = switchCell;
	}

    return newCell;
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

#pragma mark -
#pragma mark UISwitch responder

- (void)switchValueChanged:(id)sender {
	if (((UISwitch *)sender).tag == SSL_TAG)
		self.userAccount.boolSSL = [sender isOn];
}

- (void)dealloc {
	[cell release];
	[userAccount release];
	[tnm release];
	[super dealloc];
}


@end

