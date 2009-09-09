//
//  PendingRequest.h
//  uTorrentView
//
//  Created by Mike Godenzi on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PendingRequest : NSObject {
	@private
	NSString * action;
	NSUInteger type;
	BOOL needToDelete;
	BOOL needListUpdate;
}

@property(nonatomic, retain) NSString * action;
@property(assign) NSUInteger type;
@property(assign) BOOL needToDelete;
@property(assign) BOOL needListUpdate;

- (id)initWithAction:(NSString *)requestAction type:(NSUInteger)requestType needToDelete:(BOOL)requestNeedToDelete andNeedListUpdate:(BOOL)requestNeedListUpdate;

@end
