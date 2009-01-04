//
//  TorrentNetworkManager.m
//  uTorrentView
//
//  Created by Mike Godenzi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TorrentNetworkManager.h"

#import "Utilities.h"
#import "TorrentListener.h"
#import "uTorrentConstants.h"
#import "uTorrentViewAppDelegate.h"

#import <SystemConfiguration/SCNetworkConnection.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

#import <JSON/JSON.h>

@implementation TorrentNetworkManager
	
@synthesize torrentsData;
@synthesize labelsData;
@synthesize jsonItem;
@synthesize torrentsCacheID;
@synthesize unlabelledTorrents;
@synthesize removedTorrents;

- (id)init {
	if (self = [super init]) {
        listeners = [[NSMutableArray alloc] init];
		needListUpdate = NO;
    }
    return self;
}

/*
 * TODO: this class may need HUGE refactoring
 * the cache_ID doesn't seem to work, I always get back the full list of torrents.
 * on the forum it says that uTorrent can only remember _1_ cacheID, so if checking for it, make sure nobody else is using the webui
 */

- (BOOL)connectedToNetwork {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		printf("Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}

- (BOOL)hostAvailable: (NSString *) theHost {
	NSString *addressString = [self getIPAddressForHost:theHost];
	if (!addressString) {
		printf("Error recovering IP address from host name\n");
		return NO;
	}
	
	struct sockaddr_in address;
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if (!gotAddress) {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
		return NO;
	}
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		printf("Error. Could not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	return isReachable ? YES : NO;
}

- (BOOL)addressFromString: (NSString *)IPAddress address:(struct sockaddr_in *) address {
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

- (NSString *)getIPAddressForHost: (NSString *) theHost {
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
	if (host == NULL) {
		herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])];
	return addressString;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@"didReceiveResonse called: %@", response);
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
	//NSLog(@"didReceiveData got called\n");
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	//NSLog(@"connectiondidReceiveAuthenticationChallenge got called\n");
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:@"zurich"
                                                 password:@"Mike Nub ImbaFail!"
                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		[Utilities createAndShowAlertWithTitle:@"Credentials Incorrect" andMessage:@"Username or Password incorrect"];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString * readableString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	// Uncomment to see what is returned from the network call
	//NSLog(@"%@", readableString);
	
	self.jsonItem = [readableString JSONValue];
	// if checks because following requests (actions) won't return the list
	if ([jsonItem objectForKey:@"torrents"] != nil) { // new request -> no cache
		self.torrentsData = [[NSMutableArray alloc] initWithArray:[jsonItem objectForKey:@"torrents"]];
	} else if ([jsonItem objectForKey:@"torrentp"] != nil) { // cache id being used - this are the modified torrents
		if (self.removedTorrents != nil)
			[self.removedTorrents release];
		self.removedTorrents = [[NSArray alloc] initWithArray:[jsonItem objectForKey:@"torrentm"]];
		if (self.removedTorrents != nil) {
			for (NSString * removedTorrentHash in self.removedTorrents) {
				for (NSArray* oldTorrent in torrentsData) {
					NSString * oldHash = [oldTorrent objectAtIndex:HASH];
					if ([removedTorrentHash isEqual:oldHash])
						[torrentsData removeObject:oldTorrent];
				}
			}
		}
		for (NSArray* newTorrent in [jsonItem objectForKey:@"torrentp"]) {
			for (NSArray* oldTorrent in torrentsData) {
				NSString * newHash = [newTorrent objectAtIndex:HASH];
				NSString * oldHash = [oldTorrent objectAtIndex:HASH];
				if ([newHash isEqual:oldHash]) {
					[torrentsData removeObject:oldTorrent];
					[torrentsData addObject:newTorrent];
					break;
				}
			}
		}
	}
	
	if ([jsonItem objectForKey:@"label"] != nil) {
		self.labelsData = [[NSMutableArray alloc] initWithArray:[jsonItem objectForKey:@"label"]];
		float randomH;
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		NSArray * labelColorData;
		for (NSArray * label in self.labelsData) {
			if ((labelColorData = [defaults arrayForKey:[label objectAtIndex:0]]) == nil) {
				// label not found in user defaults, create random color and store it
				randomH = (float) random() / (float) 0x7fffffff;
				NSArray * colorInfo = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:randomH], [NSNumber numberWithFloat:1.0f], nil];
				[[NSUserDefaults standardUserDefaults] setObject:colorInfo forKey:[label objectAtIndex:0]];
			}
		}
		// add color (black) for 'No label' torrents
		NSArray * colorInfo = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil];
		[[NSUserDefaults standardUserDefaults] setObject:colorInfo forKey:@"No label"];
	}
	
	if ([jsonItem objectForKey:@"torrentc"] != nil)
		self.torrentsCacheID = [jsonItem objectForKey:@"torrentc"];
	
	NSLog(@"cacheID as string:%@ as int: %i", [jsonItem objectForKey:@"torrentc"], [[jsonItem objectForKey:@"torrentc"] intValue]);
	
	NSLog(@"torrentsData size: %i", [self.torrentsData count]);
	NSLog(@"labelsData size: %i", [self.labelsData count]);
	NSLog(@"unlabelled Torrents: %i", [[self updateUnlabelledTorrents] intValue]);
	
	// call update method on listeners
	// only if it was a requestList!
	if (needListUpdate == NO) {
		NSEnumerator * enumerator = [listeners objectEnumerator];
		id obj;
		while (obj = [enumerator nextObject]) {
			id<TorrentListener> listener = (id<TorrentListener>)obj;
			[listener update];
		}
	}
	
	// stop the spinning
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
	[readableString release];
	
	if (needListUpdate)
		[self requestList];
}

- (void)sendNetworkRequest:(NSString *)request {
	if ([self connectedToNetwork] && [self hostAvailable:@"ea17.homends.org"])
		printf("network connection established and host available\n");
	else
		printf("couldn't reach host\n");
	// create the request
	NSString * url = @"http://ea17.homedns.org:8080/gui/";
	NSString * urlrequest = [url stringByAppendingString:request];
	if (self.torrentsCacheID != nil) {
		urlrequest = [urlrequest stringByAppendingString:@"&cid="];
		urlrequest = [urlrequest stringByAppendingString:self.torrentsCacheID];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSLog(@"request: %@, chacheID: %@", urlrequest, self.torrentsCacheID);
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlrequest]];
		
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData = [[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
		NSLog(@"download can't be made\n");
	}
}

- (void)actionStartForTorrent:(NSString *)hash {
	needListUpdate = YES;
	NSString * action = @"?action=start&hash=";
	[self sendNetworkRequest:[action stringByAppendingString:hash]];
}

- (void)actionStopForTorrent:(NSString *)hash {
	needListUpdate = YES;
	NSString * action = @"?action=stop&hash=";
	[self sendNetworkRequest:[action stringByAppendingString:hash]];
}

- (void)requestList {
	needListUpdate = NO;
	[self sendNetworkRequest:@"?list=1"];
}

- (void)addListener:(id<TorrentListener>)listener {
	[listeners addObject:listener];
}

- (void)removeListener:(id<TorrentListener>)listener {
	NSUInteger i, count = [listeners count];
	for (i = 0; i < count; i++) {
		NSObject * obj = [listeners objectAtIndex:i];
		if ([obj isEqual:listener]) {
			[listeners removeObjectAtIndex:i];
			break;
		}
	}
}

- (NSNumber *) updateUnlabelledTorrents {
	int ret = 0;
	int labelledItemCount = 0;
	for (NSArray * label in labelsData) {
		labelledItemCount += [[label objectAtIndex:1] intValue];
	}
	ret = [torrentsData count] - labelledItemCount;
	NSNumber * retObj = [[NSNumber alloc] initWithInt:ret];
	//self.unlabelledTorrents = retObj;
	return retObj;
}

- (void)dealloc {
	[torrentsData dealloc];
	[labelsData dealloc];
	[jsonItem dealloc];
	[removedTorrents dealloc];
    [super dealloc];
}
@end
