//
//  TorrentWebParserDelegate.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol TorrentWebParserDelegate

- (void)torrentWebParserDidFinishParsing:(NSMutableArray *)resultTorrents;

@end
