//
//  TorrentFromSearch.m
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import "TorrentFromSearch.h"


@implementation TorrentFromSearch

@synthesize title, categoryName, subcategoryName, language, uploader, seeds, leechers, size, date, link, unit;

- (void)parseDescription:(NSString *)description {
	/*
	 * Parse a mininova description, something like:
	 * --------------------------------------------------------------------------------
	 * Category: <a href="http://www.mininova.org/cat/2">Books</a><br />
	 * Subcategory: <a href="http://www.mininova.org/sub/50">Ebooks</a><br />
	 * Size: 2.66&nbsp;megabyte<br />
	 * Ratio: 27 seeds, 4 leechers<br />
	 * Language: Unknown<br />
	 * Uploaded by: <a href="http://www.mininova.org/user/tqw">tqw</a>
	 * --------------------------------------------------------------------------------
	 */
	NSScanner * scanner = [NSScanner scannerWithString:description];
	[scanner scanUpToString:@"Size: " intoString:NULL];
	[scanner scanString:@"Size: " intoString:NULL];
	[scanner scanFloat:&size];
	[scanner scanUpToString:@"&nbsp;" intoString:NULL];
	[scanner scanString:@"&nbsp;" intoString:NULL];
	[scanner scanUpToString:@"<" intoString:&unit];
	[unit retain];
	[scanner scanUpToString:@"Ratio: " intoString:NULL];
	[scanner scanString:@"Ratio: " intoString:NULL];
	[scanner scanInt:&seeds];
	[scanner scanString:@" seeds, " intoString:NULL];
	[scanner scanInt:&leechers];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"title: %@\ncategory: %@\ndate: %@\nlink: %@", title, categoryName, date, link];
}

- (void)dealloc {
	[title release];
	[categoryName release];
	[subcategoryName release];
	[language release];
	[uploader release];
	[date release];
	[link release];
	[unit release];
	[super dealloc];
}

@end
