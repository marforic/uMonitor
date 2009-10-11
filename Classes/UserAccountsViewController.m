//
//  UserAccountsViewController.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:accounts] forKey:@"accounts"];
		NSNumber * selectedAccount = [[NSNumber alloc] initWithInteger:selectedAccountIndex];
		[defaults setObject:selectedAccount forKey:@"selectedAccount"];
		[selectedAccount release];
		needToSave = NO;
		[self.tableView reloadData];
	}
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	if (needToSave) {
		[self save];
		needToSave = NO;
		[self.tableView reloadData];
	}
	[super viewDidDisappear:animated];
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
	needToSave = YES;
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
