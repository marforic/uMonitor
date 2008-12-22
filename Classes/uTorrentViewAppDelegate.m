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
//@synthesize navigationController;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	//[window addSubview:[navigationController view]];
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[tabBarController release];
	//[navigationController release];
	[window release];
	[super dealloc];
}

@end
