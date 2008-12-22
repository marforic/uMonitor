//
//  TorrentNetworkManager.h
//  uTorrentView
//
//  Created by Mike Godenzi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentListener.h"

@interface TorrentNetworkManager : NSObject {
	@private
	NSMutableData * receivedData;
	NSDictionary * jsonItem;
	NSMutableArray * jsonArray;
	NSMutableArray * listeners;
}

@property (nonatomic, retain) NSMutableArray * jsonArray;
@property (nonatomic, retain) NSDictionary * jsonItem;

- (BOOL)connectedToNetwork;
- (BOOL)hostAvailable:(NSString *)theHost;
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *) address;
- (NSString *)getIPAddressForHost:(NSString *)theHost;
- (void)sendNetworkRequest:(NSString *)request;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)requestList;

- (void)addListener:(id<TorrentListener>)listener;
- (void)removeListener:(id<TorrentListener>)listener;

@end
