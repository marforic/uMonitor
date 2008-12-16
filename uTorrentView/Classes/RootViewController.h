//
//  RootViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
@private
	NSStream * iStream;
	NSStream * oStream;
}

- (BOOL)connectedToNetwork;
- (BOOL)hostAvailable: (NSString *) theHost;
- (BOOL)addressFromString: (NSString *)IPAddress address:(struct sockaddr_in *) address;
- (NSString *) getIPAddressForHost: (NSString *) theHost;

@end
