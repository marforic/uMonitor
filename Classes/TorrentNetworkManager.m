/*
TorrentNetworkManager.m
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "TorrentNetworkManager.h"

#import "Utilities.h"
#import "TorrentListener.h"
#import "uTorrentConstants.h"
#import "uTorrentViewAppDelegate.h"
#import "PendingRequest.h"
#import "UserAccount.h"

#import <SystemConfiguration/SCNetworkConnection.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

#import <JSON/JSON.h>

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
	return YES; // Or whatever logic
}
@end

@interface TorrentNetworkManager (PrivateMethods)

- (void)parseToken:(NSString *)index;
- (void)finishRequest;

@end



@implementation TorrentNetworkManager
	
@synthesize torrentsData;
@synthesize labelsData;
@synthesize torrentsCacheID;
@synthesize unlabelledTorrents;
@synthesize removedTorrents;
@synthesize needToDelete;
@synthesize settingsAddress, settingsPort, settingsUname, settingsPassword, currentRequestAction;

- (id)init {
	if (self = [super init]) {
        listeners = [[NSMutableArray alloc] init];
		needListUpdate = NO;
		self.needToDelete = NO;
		hasReceivedResponse = YES;
		pendingRequests = [[NSMutableArray alloc] init];
		// load User settings
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		NSData * accountsData = [defaults objectForKey:@"accounts"];
		if (accountsData) {
			NSMutableArray * c = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:accountsData]];
			NSInteger index = [[defaults objectForKey:@"selectedAccount"] integerValue];
			if (index >= 0 && index < [c count]) {
				UserAccount * ua = [c objectAtIndex:index];
				self.settingsAddress = ua.stringAddress;
				self.settingsPort = ua.stringPort;
				self.settingsUname = ua.stringUname;
				self.settingsPassword = ua.stringPassword;
			}
			[c release];
		}
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
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
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
        NSURLCredential * newCredential;
        newCredential = [NSURLCredential credentialWithUser:(settingsUname == nil) ? @"" : settingsUname
                                                   password:(settingsPassword == nil) ? @"" : settingsPassword
                                                persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		//[Utilities createAndShowAlertWithTitle:@"Credentials Incorrect" andMessage:@"Username or Password incorrect" withDelegate:self];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credentials Problem" 
														message:@"Username and/or Password are incorrect\nPlease check your settings\n ... Exit on OK ..."
													   delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles: nil];
		alert.tag = 13371007;
		[alert show];	
		[alert release];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	hasReceivedResponse = YES;
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	NSString * message;
    // inform the user
	switch ([error code]) {
		case -1012: // credentials incorrect - handled in another funtion (just above)
			return;
		default:
			message = [[@"Error - " stringByAppendingString:[error localizedDescription]] stringByAppendingString:@"\nPlease check your settings"];
			break;
	}
	[Utilities createAndShowAlertWithTitle:@"Network Problem" andMessage:message withDelegate:self andTag:13371007];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSInteger problem;
	id obj;
	
	if (actionSheet.tag == 13371007)
		problem = T_NETWORK_PROBLEM;
	else
		problem = T_DOWNLOAD_PROBLEM;
	
	NSEnumerator * enumerator = [listeners objectEnumerator];
	while (obj = [enumerator nextObject]) {
		id<TorrentListener> listener = (id<TorrentListener>)obj;
		[listener update:problem];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString * readableString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	// Uncomment to see what is returned from the network call
	
	if (type == T_TOKEN) {
		[self parseToken:readableString];
		[connection release];
		[readableString release];
		[self finishRequest];
		return;
	}
	
	NSDictionary * jsonItem = [readableString JSONValue];
	//NSLog(@"readable: %@", readableString);
	static int count = 0;
	if (!jsonItem) { // something wrong with the settings
		
		// stop the spinning
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		// release the connection, and the data object
		[connection release];
		[receivedData release];
		[readableString release];
		
		if (!count) {
			[self getToken];
			count++;
			PendingRequest * pr = [[PendingRequest alloc] initWithAction:currentRequestAction 
																	type:type 
															needToDelete:needToDelete 
													   andNeedListUpdate:needListUpdate];
			[pendingRequests addObject:pr];
			[pr release];
			return;
		}
		
		[Utilities createAndShowAlertWithTitle:@"Network Problem" 
									andMessage:@"There's something wrong evaluating the JSON answer from the server. \n Either check the settings or contact the developers!" 
								  withDelegate:self 
										andTag:13371008];
		return;
	}
	
	// if checks because following requests (actions) won't return the list
	if ([jsonItem objectForKey:@"torrents"] != nil) { // new request -> no cache
		self.torrentsData = [NSMutableArray arrayWithArray:[jsonItem objectForKey:@"torrents"]];
	} else if ([jsonItem objectForKey:@"torrentp"] != nil) { // cache id being used - this are the modified torrents
		//[self.removedTorrents release];
		self.removedTorrents = [jsonItem objectForKey:@"torrentm"];
		if (self.removedTorrents != nil) {
			for (NSString * removedTorrentHash in removedTorrents) {
				for (NSArray * oldTorrent in torrentsData) {
					NSString * oldHash = [oldTorrent objectAtIndex:HASH];
					if ([removedTorrentHash isEqual:oldHash]) {
						[torrentsData removeObject:oldTorrent];
						break;
					}
				}
			}
		}
		for (NSArray * newTorrent in [jsonItem objectForKey:@"torrentp"]) {
			for (NSArray* oldTorrent in torrentsData) {
				NSString * newHash = [newTorrent objectAtIndex:HASH];
				NSString * oldHash = [oldTorrent objectAtIndex:HASH];
				if ([newHash isEqual:oldHash]) {
					[torrentsData removeObject:oldTorrent];
					[torrentsData addObject:newTorrent];
					break;
				} else if ([[torrentsData lastObject] isEqual:oldTorrent]) {
					// if we reached the last object, it means this is a new torrent!
					[torrentsData addObject:newTorrent];
				}
			}
		}
	}
	if ([jsonItem objectForKey:@"label"] != nil) {
		self.labelsData = [NSMutableArray arrayWithArray:[jsonItem objectForKey:@"label"]];
		float randomH;
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		NSArray * labelColorData;
		for (NSArray * label in self.labelsData) {
			if ((labelColorData = [defaults arrayForKey:[label objectAtIndex:0]]) == nil) {
				// NSLog(@"%@/%@ not found:", [label objectAtIndex:0], labelColorData);
				// label not found in user defaults, create random color and store it
				randomH = (float) random() / (float) 0x7fffffff;
				NSArray * colorInfo = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:randomH], [NSNumber numberWithFloat:1.0f], nil];
				[defaults setObject:colorInfo forKey:[label objectAtIndex:0]];
				[colorInfo release];
			}
		}
		// add color (black) for 'No label' torrents only if it doesn't exist!
		if ([defaults arrayForKey:@"nolabel"] == nil) {
			//NSLog(@"defaults: %@", [defaults arrayForKey:@"nolabel"]);
			NSArray * colorInfo = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.1f], nil];
			[defaults setObject:colorInfo forKey:@"nolabel"];
			[colorInfo release];
		}
	}

	if ([jsonItem objectForKey:@"torrentc"] != nil)
		self.torrentsCacheID = [jsonItem objectForKey:@"torrentc"];
	
	[connection release];
	[readableString release];
	
	// call update method on listeners
	// only if it was a requestList!
	if (needListUpdate == NO) {
		NSEnumerator * enumerator = [listeners objectEnumerator];
		id obj;
		while (obj = [enumerator nextObject]) {
			id<TorrentListener> listener = (id<TorrentListener>)obj;
			[listener update:type];
		}
	}
	
	[self finishRequest];
}

- (void)finishRequest {
	// stop the spinning
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    // release the connection, and the data object
    [receivedData release];
	
	if ([pendingRequests count] > 0) {
		[self sendNetworkRequest];
	} else
		hasReceivedResponse = YES;
	
	if (needListUpdate)
		[self requestList];
}

- (NSString *)createRequest:(NSString *)request {
	NSString * url = settingsAddress;
	if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) url = [NSString stringWithFormat:@"http://%@", url];
	if ([url hasSuffix:@"/"]) url = [url substringToIndex:[url length] - 1];
	if ([url hasSuffix:@"/gui"]) url = [url substringToIndex:[url length] - 4];
	NSString * req = [NSString stringWithFormat:@"%@:%@/gui/%@%@", url, (settingsPort && [settingsPort length] != 0) ? settingsPort : @"80", (token) ? token : @"", request];
	//NSLog(@"request: %@", req);
	return req;
}

- (void)sendNetworkRequest {
	// create the request
	PendingRequest * pendingRequest = [pendingRequests objectAtIndex:0];
	type = pendingRequest.type;
	needToDelete = pendingRequest.needToDelete;
	needListUpdate = pendingRequest.needListUpdate;
	currentRequestAction = pendingRequest.action;
	NSString * url = [self createRequest:pendingRequest.action];
	[pendingRequests removeObjectAtIndex:0];
	if (url == nil)
		url = @"";
	NSString * urlrequest = [[NSString alloc] initWithFormat:@"%@&cid=%@", url, (self.torrentsCacheID != nil) ? self.torrentsCacheID : @""];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlrequest]];
	[urlrequest release];	
	NSURLConnection * theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData = [[NSMutableData data] retain];
		hasReceivedResponse = NO;
	} else {
		// inform the user that the download could not be made
		//NSLog(@"download can't be made\n");
		[Utilities createAndShowAlertWithTitle:@"Download Problem" andMessage:@"Download can't be made\nTry restarting the application" withDelegate:self andTag:13371008];
	}
}

- (void)actionStartForTorrent:(NSString *)hash {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=start&hash=%@", hash];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_START 
													needToDelete:NO 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)actionForceStartForTorrent:(NSString *)hash {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=forcestart&hash=%@", hash];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_START 
													needToDelete:NO 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)actionStopForTorrent:(NSString *)hash {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=stop&hash=%@", hash];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_STOP 
													needToDelete:NO 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)actionDeleteForTorrent:(NSString *)hash {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=remove&hash=%@", hash];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_DELETE 
													needToDelete:YES 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)actionDeleteData:(NSString *)hash {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=removedata&hash=%@", hash];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_DELETE 
													needToDelete:YES 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)requestList {
	NSString * requestAction = @"list=1";
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_LIST 
													needToDelete:NO 
											   andNeedListUpdate:NO];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
}

- (void)addTorrent:(NSString *)torrentURL {
	NSString * requestAction = [[NSString alloc] initWithFormat:@"action=add-url&s=%@", torrentURL];
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_ADD 
													needToDelete:NO 
											   andNeedListUpdate:YES];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)getToken {
	NSString * requestAction = @"token.html";
	PendingRequest * pr = [[PendingRequest alloc] initWithAction:requestAction 
															type:T_TOKEN 
													needToDelete:NO 
											   andNeedListUpdate:NO];
	[pendingRequests addObject:pr];
	[pr release];
	if (hasReceivedResponse)
		[self sendNetworkRequest];
	[requestAction release];
}

- (void)parseToken:(NSString *)index {
	NSArray * first = [index componentsSeparatedByString:@"<div id='token' style='display:none;'>"];
	first = [[first objectAtIndex:1] componentsSeparatedByString:@"</div>"];
	token = [[NSString alloc] initWithFormat:@"?token=%@&", [first objectAtIndex:0]];
}

#pragma mark -
#pragma mark Notify Listeners

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

- (NSNumber *)updateUnlabelledTorrents {
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
	[pendingRequests release];
	[unlabelledTorrents release];
	[torrentsCacheID release];
	[listeners release];
	[torrentsData release];
	[labelsData release];
	[removedTorrents release];
	[settingsAddress release];
	[settingsPort release];
	[settingsUname release];
	[settingsPassword release];
	[currentRequestAction release];
	[token release];
    [super dealloc];
}

@end
