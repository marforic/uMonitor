//
//  SizeOrganizer.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParameterOrganizer.h"
#import "TorrentNetworkManager.h"
#import "Utilities.h"

@implementation ParameterOrganizer

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	return [self initWithTNM:networkManager parameter:SIZE andLabel:@"Sort By Size"];
}

- (id)initWithTNM:(TorrentNetworkManager *)networkManager parameter:(TORRENTS_ARRAY)parameter andLabel:(NSString *)label {
	if (self = [super init]) {
		tnm = [networkManager retain];
		NSMutableArray * section = [[NSMutableArray alloc] init];
		organizedTorrents = [[NSMutableArray alloc] initWithObjects:section, nil];
		[section release];
		index = parameter;
		textLabel = [label retain];
	}
	return self;
}

- (NSArray *)getOrganizedTorrents {
	return organizedTorrents;
}

- (void)organize {
	NSMutableArray * organized = [organizedTorrents objectAtIndex:0];
	[organized removeAllObjects];
	for (NSArray * torrent in tnm.torrentsData) {
		NSNumber * size = [torrent objectAtIndex:index];
		NSInteger i;
		for (i = 0; i < [organized count]; i++) {
			NSNumber * orderedSize = [[organized objectAtIndex:i] objectAtIndex:index];
			if ([size doubleValue] > [orderedSize doubleValue])
				break;
		}
		[organized insertObject:torrent atIndex:i];
	}
}

- (NSString *)getTitleForSection:(NSInteger)section {
	return nil;
}

- (NSInteger)getSectionNumber {
	return 1;
}

- (NSInteger)getRowNumberInSection:(NSInteger)section {
	return [[organizedTorrents objectAtIndex:section] count];
}

- (NSArray *)getItemInPath:(NSIndexPath *)path {
	NSMutableArray * ma = [organizedTorrents objectAtIndex:path.section];
	return (NSArray *)[ma objectAtIndex:path.row];
}

- (NSString *)getLabelText {
	return textLabel;
}

- (void)dealloc {
	[textLabel release];
	[tnm release];
	[organizedTorrents release];
	[super dealloc];
}

@end
