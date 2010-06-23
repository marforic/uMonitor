/*
uTorrentViewAppDelegate.m
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
