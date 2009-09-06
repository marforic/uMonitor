//
//  LabelOrganizer.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentOrganizer.h"
#import "uTorrentConstants.h"

@class TorrentNetworkManager;

@interface ParameterOrganizer : NSObject<TorrentOrganizer> {
	NSMutableArray * organizedTorrents;
	TorrentNetworkManager * tnm;
	TORRENTS_ARRAY index;
	NSString * textLabel;
}

- (id)initWithTNM:(TorrentNetworkManager *)networkManager parameter:(TORRENTS_ARRAY)parameter andLabel:(NSString *)label;

@end
