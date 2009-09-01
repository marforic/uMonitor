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
    
    UIWindow * window;
	UITabBarController * tabBarController;
    TorrentNetworkManager * tnm;
	
	BOOL cacheNeedsRefresh;
	
}

@property(nonatomic, retain) IBOutlet UIWindow * window;
@property(nonatomic, retain) IBOutlet UITabBarController * tabBarController;
@property(nonatomic, retain) TorrentNetworkManager * tnm;
@property BOOL cacheNeedsRefresh;

- (TorrentNetworkManager *)getTNM;

@end

