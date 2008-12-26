//
//  TorrentNetworkManager.m
//  uTorrentView
//
//  Created by Mike Godenzi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TorrentNetworkManager.h"

#import "Utilities.h"

#import <SystemConfiguration/SCNetworkConnection.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

#import <JSON/JSON.h>

@implementation TorrentNetworkManager
	
@synthesize torrentsData;
@synthesize labelsData;
@synthesize jsonItem;

- (id)init {
	if (self = [super init]) {
        listeners = [[NSMutableArray alloc] init];
    }
    return self;
}

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
	if ([jsonItem objectForKey:@"torrents"] != nil)
		self.torrentsData = [[NSMutableArray alloc] initWithArray:[jsonItem objectForKey:@"torrents"]];
	if ([jsonItem objectForKey:@"label"] != nil)
		self.labelsData = [[NSMutableArray alloc] initWithArray:[jsonItem objectForKey:@"label"]];
	
	NSLog(@"torrentsData size: %i", [self.torrentsData count]);
	NSLog(@"labelsData size: %i", [self.labelsData count]);
	//NSLog(@"jsonArray: %@", self.jsonArray);
	NSEnumerator * enumerator = [listeners objectEnumerator];
	id obj;
	while (obj = [enumerator nextObject]) {
		id<TorrentListener> listener = (id<TorrentListener>)obj;
		[listener update];
	}
    // release the connection, and the data object
    [connection release];
    [receivedData release];
	[readableString release];
	// call update method on listeners
}

- (void)sendNetworkRequest:(NSString *)request {
	if ([self connectedToNetwork] && [self hostAvailable:@"ea17.homends.org"])
		printf("network connection established and host available\n");
	else
		printf("couldn't reach host\n");
	// create the request
	NSString * url = @"http://ea17.homedns.org:8080/gui/";
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:request]]];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
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
	NSString * action = @"?action=start&hash=";
	[self sendNetworkRequest:[action stringByAppendingString:hash]];
}

- (void)actionStopForTorrent:(NSString *)hash {
	NSString * action = @"?action=stop&hash=";
	[self sendNetworkRequest:[action stringByAppendingString:hash]];
}

- (void)requestList {
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

- (void)dealloc {
	[torrentsData dealloc];
	[labelsData dealloc];
	[jsonItem dealloc];
    [super dealloc];
}
@end
