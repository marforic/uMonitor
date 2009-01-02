//
//  StatusOrganizer.m
//  uTorrentView
//
//  Created by Mike Godenzi on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StatusOrganizer.h"
#import "Utilities.h"
#import "uTorrentConstants.h"


@implementation StatusOrganizer

@synthesize organizedTorrents;

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = networkManager;
		self.organizedTorrents = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
							 [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
							 [NSMutableArray array], [NSMutableArray array], nil];
	}
	return self;
}

- (void)organize {
	NSUInteger i, count = [tnm.torrentsData count];
	BOOL stop = NO;
	for (i = 0; i < count; i++) {
		NSArray * a = (NSArray *)[tnm.torrentsData objectAtIndex:i];
		int section = [self getSectionFromStatus:[Utilities getStatusProgrammable:[a objectAtIndex:STATUS] forProgress:[a objectAtIndex:PERCENT_PROGRESS]]];
		NSUInteger k, count2 = [self.organizedTorrents count];
		for (k = 0; (k < count2) && !stop; k++) {
			NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:k];
			NSUInteger j, count3 = [ma count];
			for (j = 0; (j < count3) && !stop; j++) {
				NSArray * b = (NSArray *)[ma objectAtIndex:j];
				if ([[a objectAtIndex:HASH] isEqual:[b objectAtIndex:HASH]]) {
					[ma removeObjectAtIndex:j];
					stop = YES;
				}
			}
		}
		[Utilities insertItemOrderedByName:a inArrey:[self.organizedTorrents objectAtIndex:section]];
		stop = NO;
	}
}

- (int)getSectionFromStatus:(int)status {
	int ret = 0;
	switch (status) {
		case 0:
			ret = 0;
			break;
		case 8:
			ret = 1;
			break;
		case 7:
			ret = 2;
			break;
		case 4:
			ret = 3;
			break;
		case 1:
			ret = 4;
			break;
		case 5:
			ret = 5;
			break;
		case 6:
			ret = 6;
			break;
		case 2:
			ret = 7;
			break;
		case 3:
			ret = 8;
			break;
	}
	return ret;
}

- (NSString *)getTitleForSection:(NSInteger)section {
	NSString * title = @"";
	switch (section) {
		case 0:
			title = ([[organizedTorrents objectAtIndex:0] count] != 0) ? @"STARTED" : @"";
			break;
		case 1:
			title = ([[organizedTorrents objectAtIndex:1] count] != 0) ? @"LEECHING" : @"";
			break;
		case 2:
			title = ([[organizedTorrents objectAtIndex:2] count] != 0) ? @"SEEDING" : @"";
			break;
		case 3:
			title = ([[organizedTorrents objectAtIndex:3] count] != 0) ? @"QUEUED" : @"";
			break;
		case 4:
			title = ([[organizedTorrents objectAtIndex:4] count] != 0) ? @"PAUSED" : @"";
			break;
		case 5:
			title = ([[organizedTorrents objectAtIndex:5] count] != 0) ? @"STOPPED": @"";
			break;
		case 6:
			title = ([[organizedTorrents objectAtIndex:6] count] != 0) ? @"FINISHED": @"";
			break;
		case 7:
			title = ([[organizedTorrents objectAtIndex:7] count] != 0) ? @"CHECKING": @"";
			break;
		case 8:
			title = ([[organizedTorrents objectAtIndex:8] count] != 0) ? @"ERROR" : @"";
			break;
		default:
			title = @"";
			break;
	}
	return title;
}

- (NSArray *)getOrganizedTorrents {
	return organizedTorrents;
}

- (NSInteger)getSectionNumber {
	return [organizedTorrents count];
}

- (NSInteger)getRowNumberInSection:(NSInteger)section {
	NSMutableArray * ma = (NSMutableArray *)[organizedTorrents objectAtIndex:section];
	return [ma count];
}

- (NSArray *)getItemInPath:(NSIndexPath *)path {
	NSMutableArray * ma = (NSMutableArray *)[organizedTorrents objectAtIndex:path.section];
	return (NSArray *)[ma objectAtIndex:path.row];
}

- (NSString *)getLabelText {
	return @"Sort By Status";
}

- (void)dealloc {
	[super dealloc];
	[organizedTorrents dealloc];
	[tnm release];
}

@end
