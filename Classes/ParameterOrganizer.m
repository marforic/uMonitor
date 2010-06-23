/*
ParameterOrganizer.m
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
