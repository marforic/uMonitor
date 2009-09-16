//
//  TorrentWebParser.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TorrentWebParser.h"
#import "Torrent.h"
#import "TorrentWebParserDelegate.h"

@implementation TorrentWebParser

@synthesize rssParser, item, characters;

- (void)parseRSSResultsForQuery:(NSString *)query andDelegate:(id)parserDelegate {
	delegate = parserDelegate;
	query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString * url = [[NSString alloc] initWithFormat:@"http://www.mininova.org/rss/%@/seeds", query];
	NSXMLParser * p = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	self.rssParser = p;
	[p release];
	resultTorrents = [[NSMutableArray alloc] init];
	[rssParser setDelegate:self];
	[rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];
}

#pragma mark -
#pragma mark NSXMLParser delegate Methods
/*
- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	//NSLog(@"found file and started parsing");
}
*/
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error parsing results" 
													message:errorString
												   delegate:self 
										  cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	needToAppend = NO;
	if ([elementName isEqualToString:@"item"]) {
		Torrent * i = [[Torrent alloc] init];
		self.item = i;
		[i release];
	} else if ([elementName isEqualToString:@"title"] || 
			   [elementName isEqualToString:@"pubDate"] || 
			   [elementName isEqualToString:@"category"] || 
			   [elementName isEqualToString:@"link"] ||
			   [elementName isEqualToString:@"description"]) {
		NSMutableString * ms = [[NSMutableString alloc] init];
		self.characters = ms;
		[ms release];
		needToAppend = YES;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"title"])
		self.item.title = characters;
	else if ([elementName isEqualToString:@"pubDate"])
		self.item.date = characters;
	else if ([elementName isEqualToString:@"category"])
		self.item.categoryName = characters;
	else if ([elementName isEqualToString:@"description"])
		[self.item parseDescription:characters];
	else if ([elementName isEqualToString:@"link"])
		self.item.link = characters;
	else if ([elementName isEqualToString:@"item"]) {
		[resultTorrents addObject:item];
		self.item = nil;
	}
	self.characters = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	if (needToAppend) {
		[characters appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"all done!");
	if ([delegate respondsToSelector:@selector(torrentWebParserDidFinishParsing:)])
		[delegate torrentWebParserDidFinishParsing:resultTorrents];
	[resultTorrents release];
}

- (void)dealloc {
	[resultTorrents release];
	[item release];
	[rssParser release];
	[super dealloc];
}

@end
