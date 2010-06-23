/*
StatusOrganizer.m
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "StatusOrganizer.h"
#import "Utilities.h"
#import "uTorrentConstants.h"
#import "TorrentNetworkManager.h"


@implementation StatusOrganizer

@synthesize organizedTorrents;

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = [networkManager retain];
		NSArray * tmp = [[NSArray alloc] initWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
						 [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], 
						 [NSMutableArray array], [NSMutableArray array], nil];
		self.organizedTorrents = tmp;
		[tmp release];
	}
	return self;
}

- (void)organize {
	NSUInteger i, count = [tnm.torrentsData count];
	BOOL stop = NO;
	for (i = 0; i < count; i++) {
		NSArray * a = (NSArray *)[tnm.torrentsData objectAtIndex:i];
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
		int section = [self getSectionFromStatus:[Utilities getStatusProgrammable:[a objectAtIndex:STATUS] forProgress:[a objectAtIndex:PERCENT_PROGRESS]]];
		[Utilities insertItemOrderedByName:a inArrey:[self.organizedTorrents objectAtIndex:section]];
		stop = NO;
	}
	[Utilities removeNotNeededTorrentsFromList:self.organizedTorrents 
							   andOriginalList:tnm.torrentsData 
							  usingRemovedList:tnm.removedTorrents 
							   andNeedToDelete:tnm.needToDelete];
	tnm.needToDelete = NO;
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
	[organizedTorrents release];
	[tnm release];
	[super dealloc];
}

@end
