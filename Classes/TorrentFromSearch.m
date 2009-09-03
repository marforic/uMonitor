//
//  TorrentFromSearch.m
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import "TorrentFromSearch.h"


@implementation TorrentFromSearch

@synthesize title, categoryName, subcategoryName, language, uploader, category, subcategory, seeds, leechers, size, date, link;

- (NSString *)description {
	return [NSString stringWithFormat:@"title: %@\ncategory: %@\ndate: %@\nlink: %@", title, categoryName, date, link];
}

@end
