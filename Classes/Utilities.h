//
//  Utilities.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {

}

+(NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress;
+(NSString *)getSizeReadable:(NSDecimalNumber *)size;


@end
