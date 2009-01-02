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


@implementation NameOrganizer

@synthesize organizedTorrents;

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = networkManager;
		self.organizedTorrents = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
								  [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
	}
	return self;
}

- (NSArray *)getOrganizedTorrents {
	return self.organizedTorrents;
}

- (void)organize {
	NSLog(@"LOL");
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
}

- (NSUInteger)getSectionFromName:(NSString *)name {
	name = [name uppercaseString];
	unichar firstchar = [name characterAtIndex:0];
	NSUInteger section;
	if (firstchar < 65 || firstchar > 90)
		section = 27;
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
	[super dealloc];
	[self.organizedTorrents dealloc];
	[tnm release];
}

@end
