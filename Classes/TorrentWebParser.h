//
//  TorrentWebParser.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorrentWebParser : NSObject {

}

+ (NSMutableArray *)parseRSSResults:(NSString *)xml;

@end
