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

- (TorrentNetworkManager *)getTNM {
	return tnm;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// instantiate our Torrent Network Manager
	tnm = [[TorrentNetworkManager alloc] init];
	
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
