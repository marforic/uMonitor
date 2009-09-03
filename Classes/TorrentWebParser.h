//
//  TorrentWebParser.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TorrentFromSearch;

@interface TorrentWebParser : NSObject {
	@private
	BOOL needToAppend;
	NSXMLParser * rssParser;
	id delegate;
	TorrentFromSearch * item;
	NSMutableString * characters;
	NSMutableArray * resultTorrents;
}

@property(nonatomic, retain) NSXMLParser * rssParser;
@property(nonatomic, retain) TorrentFromSearch * item;
@property(nonatomic, retain) NSMutableString * characters;

- (void)parseRSSResultsForQuery:(NSString *)query andDelegate:(id)parserDelegate;

@end
