/*
UserAccountsViewController.m
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

#import "UserAccountsViewController.h"
#import "SettingsViewController.h"
#import "UserAccount.h"
#import "uTorrentViewAppDelegate.h"
#import "TorrentNetworkManager.h"

@interface UserAccountsViewController (PrivateMethods)

- (void)editButtonPressed;
- (void)addButtonPressed;
- (void)save;

@end


@implementation UserAccountsViewController

@synthesize accounts, cell;

- (void)viewDidLoad {
    [super viewDidLoad];
	needToSave = NO;
	uTorrentViewAppDelegate * appDel = [[UIApplication sharedApplication] delegate];
	tnm = [[appDel getTNM] retain];
	self.navigationItem.title = @"Profiles";
	editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																	  target:self 
																	  action:@selector(editButtonPressed)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																						  target:self 
																						  action:@selector(addButtonPressed)];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSData * accountsData = [defaults objectForKey:@"accounts"];
	if (!accountsData) {
		accounts = [[NSMutableArray alloc] init];
		selectedAccountIndex = 0;
	} else {
		NSMutableArray * c = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:accountsData]];
		self.accounts = c;
		[c release];
		selectedAccountIndex = [[defaults objectForKey:@"selectedAccount"] integerValue];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	if (needToSave) {
		[self save];
		needToSave = NO;
		[self.tableView reloadData];
	}
	[super viewDidAppear:animated];
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
    return [accounts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    
    self.cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        self.cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (selectedAccountIndex == indexPath.row)
		self.cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_green.png"]];
	
    NSString * aName = [[accounts objectAtIndex:indexPath.row] accountName];
    cell.textLabel.text = aName ? aName : @"Unnamed";

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem = editButton;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedAccountIndex inSection:0]].accessoryView = nil;
	[tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_green.png"]];
	selectedAccountIndex = indexPath.row;
	UserAccount * ua = [accounts objectAtIndex:selectedAccountIndex];
	if (!tnm) {
		uTorrentViewAppDelegate * appDel = [[UIApplication sharedApplication] delegate];
		tnm = [[appDel getTNM] retain];
	}
	tnm.settingsAddress = ua.stringAddress;
	tnm.settingsPort = ua.stringPort;
	tnm.settingsUname = ua.stringUname;
	tnm.settingsPassword = ua.stringPassword;
	[self save];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && [accounts count] > 1) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
		[accounts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		selectedAccountIndex = indexPath.row - 1;
		[self save];
		[self.tableView reloadData];
    }   
}


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

#pragma mark -
#pragma mark TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark PrivateMethods implementation

- (void)editButtonPressed {
	needToSave = YES;
	SettingsViewController * svc = [[SettingsViewController alloc] initWithAccount:[accounts objectAtIndex:selectedAccountIndex]];
	[self.navigationController pushViewController:svc animated:YES];
	[svc release];
}

- (void)addButtonPressed {
	UserAccount * ua = [[UserAccount alloc] initWithName:nil 
												 address:nil 
													port:nil 
												   uname:nil 
												password:nil];
	[accounts addObject:ua];
	[ua release];
	[self.tableView reloadData];
}

- (void)save {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:accounts] forKey:@"accounts"];
	NSNumber * selectedAccount = [[NSNumber alloc] initWithInteger:selectedAccountIndex];
	[defaults setObject:selectedAccount forKey:@"selectedAccount"];
	[selectedAccount release];
}

- (void)dealloc {
	[accounts release];
	[editButton release];
	[tnm release];
	[cell release];
    [super dealloc];
}

@end
