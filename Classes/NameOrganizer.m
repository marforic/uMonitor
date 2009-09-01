//
//  NameOrganizer.m
//  uTorrentView
//
//  Created by Mike Godenzi on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NameOrganizer.h"
#import "Utilities.h"
#import "uTorrentConstants.h"
#import "TorrentNetworkManager.h"

@implementation NameOrganizer

@synthesize organizedTorrents;

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = networkManager;
		NSArray * tmp = [[NSArray alloc] initWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
		self.organizedTorrents = tmp;
		[tmp release];
	}
	return self;
}

- (NSArray *)getOrganizedTorrents {
	return self.organizedTorrents;
}

- (void)organize {
	NSUInteger i, count = [tnm.torrentsData count];
	for (i = 0; i < count; i++) {
		NSArray * a = (NSArray *)[tnm.torrentsData objectAtIndex:i];
		NSUInteger section = [self getSectionFromName:[a objectAtIndex:NAME]];
		NSMutableArray * ma = [self.organizedTorrents objectAtIndex:section];
		NSUInteger j, count2 = [ma count];
		for (j = 0; j < count2; j++) {
			NSArray * b = (NSArray *)[ma objectAtIndex:j];
			if ([[a objectAtIndex:HASH] isEqual:[b objectAtIndex:HASH]]) {
				[ma removeObjectAtIndex:j];
				break;
			}
		}
		[Utilities insertItemOrderedByName:a inArrey:ma];
	}
	if (tnm.removedTorrents != nil) {
		count = [self.organizedTorrents count];
		BOOL stop = NO;
		for (NSString * rm in tnm.removedTorrents) {
			for (i = 0; i < count && !stop; i++) {
				NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:i];
				NSUInteger j, count2 = [ma count];
				for (j = 0; j < count2 && !stop; j++) {
					NSArray * t = (NSArray *)[ma objectAtIndex:j];
					NSString * tHash = (NSString *)[t objectAtIndex:HASH];
					if ([rm isEqual:tHash]) {
						[ma removeObjectAtIndex:j];
						stop = YES;
					}
				}
			}
			stop = NO;
		}
	} else if (tnm.needToDelete) {
		BOOL toRemove = YES;
		NSInteger i, count = [self.organizedTorrents count];
		NSUInteger k, count3 = [tnm.torrentsData count];
		for (i = 0; i < count; i++) {
			NSMutableArray * indexToRemove = [[NSMutableArray alloc] init];
			NSMutableArray * ma = (NSMutableArray *)[self.organizedTorrents objectAtIndex:i];
			NSUInteger j, count2 = [ma count];
			for (j = 0; j < count2; j++) {
				NSArray * a = (NSArray *)[ma objectAtIndex:j];
				NSString * aHASH = (NSString *)[a objectAtIndex:HASH];
				for (k = 0; k < count3; k++) {
					NSArray * b = (NSArray *)[tnm.torrentsData objectAtIndex:k];
					NSString * bHash = (NSString *)[b objectAtIndex:HASH];
					if ([aHASH isEqual:bHash]) {
						toRemove = NO;
						break;
					}
				}
				if (toRemove)
					[indexToRemove addObject:[NSNumber numberWithInt:j]];
				toRemove = YES;
			}
			NSUInteger l, count4 = [indexToRemove count];
			for (l = 0; l < count4; l++) {
				NSNumber * n = (NSNumber *)[indexToRemove objectAtIndex:l];
				[ma removeObjectAtIndex:[n intValue]];
			}
			[indexToRemove release];
		}
		tnm.needToDelete = NO;
	}
}

- (NSUInteger)getSectionFromName:(NSString *)name {
	name = [name uppercaseString];
	unichar firstchar = [name characterAtIndex:0];
	NSUInteger section;
	if (firstchar < 65 || firstchar > 90)
		section = 26;
	else
		section = (NSUInteger)firstchar - 65;
	return section;
}

- (NSString *)getTitleForSection:(NSInteger)section {
	unsigned short c = (unsigned short)(section + 65);
	NSString * ret;
	if ([self getRowNumberInSection:section] == 0)
		ret = @"";
	else if (c < 65 || c > 90)
		ret = @"Others";
	else
		ret = [NSString stringWithCharacters:&c length:1];
	return ret;
}

- (NSInteger)getSectionNumber {
	return [self.organizedTorrents count];
}

- (NSInteger)getRowNumberInSection:(NSInteger)section {
	NSMutableArray * ma = [self.organizedTorrents objectAtIndex:section];
	return [ma count];
}

- (NSArray *)getItemInPath:(NSIndexPath *)path {
	NSMutableArray * ma = [self.organizedTorrents objectAtIndex:path.section];
	return (NSArray *)[ma objectAtIndex:path.row];
}

- (NSString *)getLabelText {
	return @"Sort By Name";
}

- (void)dealloc {
	[organizedTorrents release];
	[tnm release];
	[super dealloc];
}

@end
