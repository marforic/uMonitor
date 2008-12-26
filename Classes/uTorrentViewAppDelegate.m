//
//  uTorrentViewAppDelegate.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "uTorrentViewAppDelegate.h"
#import "RootViewController.h"


@implementation uTorrentViewAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize tnm;

@synthesize settingsAddress, settingsPort, settingsUname, settingsPassword;

- (TorrentNetworkManager *)getTNM {
	return tnm;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// instantiate our Torrent Network Manager
	tnm = [[TorrentNetworkManager alloc] init];
	
	// load User settings
	settingsAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"address_preference"];
	settingsPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"uport_preference"];
	settingsUname = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
	settingsPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"pwd_preference"];
	
	//NSLog(@"address: %@, port: %@, uname: %@, pwd:%@", settingsAddress, settingsPort, settingsUname, settingsPassword);
	
	
	// Configure and show the window
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[tnm release];
	[settingsAddress release];
	[settingsPort release];
	[settingsUname release];
	[settingsPassword release];
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end
