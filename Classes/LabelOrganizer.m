/*
LabelOrganizer.m
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
