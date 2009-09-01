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
@synthesize cacheNeedsRefresh;

- (TorrentNetworkManager *)getTNM {
	return tnm;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// set the cacheNeedsUpdate to false
	cacheNeedsRefresh = NO;
	
	// instantiate our Torrent Network Manager
	TorrentNetworkManager * torrentManager = [[TorrentNetworkManager alloc] init];
	self.tnm = torrentManager;
	[torrentManager release];
	
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
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end
