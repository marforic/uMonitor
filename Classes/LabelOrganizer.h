//
//  LabelOrganizer.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentOrganizer.h"

@class TorrentNetworkManager;

@interface LabelOrganizer : NSObject<TorrentOrganizer> {
	NSMutableArray * organizedTorrents;
	TorrentNetworkManager * tnm;
	NSMutableDictionary * labelTitels;
}

@end
