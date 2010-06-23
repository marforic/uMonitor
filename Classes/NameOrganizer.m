/*
NameOrganizer.m
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

#import "NameOrganizer.h"
#import "Utilities.h"
#import "uTorrentConstants.h"
#import "TorrentNetworkManager.h"

@implementation NameOrganizer

@synthesize organizedTorrents;

- (id)initWithTNM:(TorrentNetworkManager *)networkManager {
	if (self = [super init]) {
		tnm = [networkManager retain];
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
	[Utilities removeNotNeededTorrentsFromList:self.organizedTorrents 
							   andOriginalList:tnm.torrentsData 
							  usingRemovedList:tnm.removedTorrents 
							   andNeedToDelete:tnm.needToDelete];
	tnm.needToDelete = NO;
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
