//
//  uTorrentViewAppDelegate.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentNetworkManager.h"

@interface uTorrentViewAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	UITabBarController * tabBarController;
    TorrentNetworkManager * tnm;
	
	NSString * settingsPassword;
	NSString * settingsUname;
	NSString * settingsPort;
	NSString * settingsAddress;
	
	BOOL cacheNeedsRefresh;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController * tabBarController;

@property (nonatomic, retain) TorrentNetworkManager * tnm;
@property (nonatomic, retain) NSString * settingsAddress;
@property (nonatomic, retain) NSString * settingsPort;
@property (nonatomic, retain) NSString * settingsUname;
@property (nonatomic, retain) NSString * settingsPassword;

@property BOOL cacheNeedsRefresh;

- (TorrentNetworkManager *)getTNM;

@end

