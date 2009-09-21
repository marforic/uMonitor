//
//  UserAccount.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserAccount : NSObject<NSCoding> {
	@private
	NSString * accountName;
	NSString * stringAddress;
	NSString * stringPort;
	NSString * stringUname;
	NSString * stringPassword;
}

@property(nonatomic, retain) NSString * accountName;
@property(nonatomic, retain) NSString * stringAddress;
@property(nonatomic, retain) NSString * stringPort;
@property(nonatomic, retain) NSString * stringUname;
@property(nonatomic, retain) NSString * stringPassword;

- (id)initWithName:(NSString *)name address:(NSString *)address port:(NSString *)port uname:(NSString *)uname password:(NSString *)password;

@end
