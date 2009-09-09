//
//  PendingRequest.m
//  uTorrentView
//
//  Created by Mike Godenzi on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PendingRequest.h"


@implementation PendingRequest

@synthesize action, type, needToDelete, needListUpdate;

- (id)initWithAction:(NSString *)requestAction type:(NSUInteger)requestType needToDelete:(BOOL)requestNeedToDelete andNeedListUpdate:(BOOL)requestNeedListUpdate {
	if (self = [super init]) {
		self.action = requestAction;
		type = requestType;
		needToDelete = requestNeedToDelete;
		needListUpdate = requestNeedListUpdate;
	}
	return self;
}

@end
