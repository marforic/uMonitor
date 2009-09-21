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
	if ([accountsData isKindOfClass:[NSArray class]]) {
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
		self.cell.backgroundColor = [UIColor redColor]; // FIX: does not work
	
    NSString * aName = [[accounts objectAtIndex:indexPath.row] accountName];
    cell.textLabel.text = aName ? aName : @"Unnamed";

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem = editButton;
	selectedAccountIndex = indexPath.row;
	UserAccount * ua = [accounts objectAtIndex:selectedAccountIndex];
	tnm.settingsAddress = ua.stringAddress;
	tnm.settingsPort = ua.stringPort;
	tnm.settingsUname = ua.stringUname;
	tnm.settingsPassword = ua.stringPassword;
}

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

- (void)dealloc {
	[accounts release];
	[editButton release];
	[tnm release];
	[cell release];
    [super dealloc];
}

@end
