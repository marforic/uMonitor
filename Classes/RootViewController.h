//
//  RootViewController.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/15/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	@private
	NSMutableData * receivedData;
	NSDictionary * jsonItem;
	NSMutableArray * jsonArray;
	
	IBOutlet UITableView * torrentsTable;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) NSDictionary *jsonItem;
@property (nonatomic,retain) IBOutlet UITableView *torrentsTable;

- (BOOL)connectedToNetwork;
- (BOOL)hostAvailable: (NSString *) theHost;
- (BOOL)addressFromString: (NSString *)IPAddress address:(struct sockaddr_in *) address;
- (NSString *) getIPAddressForHost: (NSString *) theHost;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection   didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
