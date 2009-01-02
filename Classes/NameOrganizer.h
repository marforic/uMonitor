//
//  NameOrganizer.h
//  uTorrentView
//
//  Created by Mike Godenzi on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentOrganizer.h"
#import "TorrentNetworkManager.h"

@interface NameOrganizer : NSObject<TorrentOrganizer> {
	@private
	NSArray * organizedTorrents;
	TorrentNetworkManager * tnm;
}

@property (nonatomic, retain) NSArray * organizedTorrents;

- (NSUInteger)getSectionFromName:(NSString *)name;

@end
