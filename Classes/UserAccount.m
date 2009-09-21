//
//  UserAccount.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UserAccount.h"


@implementation UserAccount

@synthesize stringAddress, stringPort, stringUname, stringPassword, accountName;

- (id)initWithName:(NSString *)name address:(NSString *)address port:(NSString *)port uname:(NSString *)uname password:(NSString *)password {
	if (self = [super init]) {
		self.accountName = name;
		self.stringAddress = address;
		self.stringPort = port;
		self.stringUname = uname;
		self.stringPassword = password;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.accountName = [coder decodeObjectForKey:@"accountName"];
		self.stringAddress = [coder decodeObjectForKey:@"stringAddress"];
		self.stringPort = [coder decodeObjectForKey:@"stringPort"];
		self.stringUname = [coder decodeObjectForKey:@"stringUname"];
		self.stringPassword = [coder decodeObjectForKey:@"stringPassword"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.accountName forKey:@"accountName"];
	[coder encodeObject:self.stringAddress forKey:@"stringAddress"];
	[coder encodeObject:self.stringPort forKey:@"stringPort"];
	[coder encodeObject:self.stringUname forKey:@"stringUname"];
	[coder encodeObject:self.stringPassword forKey:@"stringPassword"];
}

- (void)dealloc {
	[accountName release];
	[stringAddress release];
	[stringPort release];
	[stringUname release];
	[stringPassword release];
	[super dealloc];
}

@end
