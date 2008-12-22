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
+(NSString *)getSpeedReadable:(NSDecimalNumber *)speed;
+(NSString *)getRatioReadable:(NSDecimalNumber *)ratio;
+(NSString *)getETAReadable:(NSDecimalNumber *)eta;
+(NSString *)getAvailabilityReadable:(NSDecimalNumber *)availability;
+(void)createAndShowAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
