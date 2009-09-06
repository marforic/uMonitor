//
//  LabelOrganizer.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LabelOrganizer.h"
#import "TorrentNetworkManager.h"
#import "uTorrentConstants.h"
#import "Utilities.h"

@implementation LabelOrganizer

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = [networkManager retain];
		organizedTorrents = [[NSMutableArray alloc] init];
		labelTitels = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NSArray *)getOrganizedTorrents {
	return organizedTorrents;
}

- (void)organize {
	[organizedTorrents removeAllObjects];
	[labelTitels removeAllObjects];
	NSUInteger i = 0;
	NSNumber * index;
	for (NSArray * label in tnm.labelsData) {
		index = [[NSNumber alloc] initWithInteger:i];
		[labelTitels setValue:index forKey:[label objectAtIndex:0]];
		[index release];
		NSMutableArray * array = [[NSMutableArray alloc] init];
		[organizedTorrents addObject:array];
		[array release];
		i++;
	}
	index = [[NSNumber alloc] initWithInteger:i];
	[labelTitels setValue:index forKey:@"no label"];
	[index release];
	NSMutableArray * array = [[NSMutableArray alloc] init];
	[organizedTorrents addObject:array];
	[array release];
	for (NSArray * torrent in tnm.torrentsData) {
		NSString * torrentLabel = [torrent objectAtIndex:LABEL];
		NSNumber * section = [labelTitels valueForKey:torrentLabel];
		if (!section) {
			NSNumber * tmp = [[NSNumber alloc] initWithInteger:[organizedTorrents count] - 1];
			section = tmp;
			[tmp release];
		}
		[[organizedTorrents objectAtIndex:[section integerValue]] addObject:torrent];
	}
}

- (NSString *)getTitleForSection:(NSInteger)section {
	NSArray * keys = [labelTitels keysSortedByValueUsingSelector:@selector(compare:)];
	return [keys objectAtIndex:section];
}

- (NSInteger)getSectionNumber {
	return [tnm.labelsData count] + 1;
}

- (NSInteger)getRowNumberInSection:(NSInteger)section {
	NSMutableArray * ma = [organizedTorrents objectAtIndex:section];
	return [ma count];
}

- (NSArray *)getItemInPath:(NSIndexPath *)path {
	NSMutableArray * ma = [organizedTorrents objectAtIndex:path.section];
	return (NSArray *)[ma objectAtIndex:path.row];
}

- (NSString *)getLabelText {
	return @"Sort By Label";
}

- (void)dealloc {
	[labelTitels release];
	[tnm release];
	[organizedTorrents release];
	[super dealloc];
}

@end
