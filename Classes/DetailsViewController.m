//
//  DetailsViewController.m
//  uTorrentView
//
//  Created by Mike Godenzi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
#import "uTorrentConstants.h"
#import "Utilities.h"


@implementation DetailsViewController

@synthesize torrent, actionButton, statusLabel, torrentStatus, torrentSize, torrentProgress;
@synthesize torrentDownloaded, torrentUploaded, torrentRatio, torrentUspeed, torrentDspeed, torrentEta;
@synthesize torrentPeers, torrentSeeds, torrentAvail, torrentRem, sizeLabel, progressLabel, downloadedLabel;
@synthesize uploadedLabel, ratioLabel, uspeedLabel, dspeedLabel, etaLabel, peersLabel, seedsLabel, availLabel;
@synthesize remLabel;

- (id)initWithTorrent:(NSArray *)selectedTorrent {
	if (self = [super initWithNibName:@"DetailsViewController" bundle:nil]) {
        self.torrent = selectedTorrent;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = (NSString *)[self.torrent objectAtIndex:NAME];
	[self updateLabels];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)updateLabels {
	[self.torrentStatus setText: [Utilities getStatusReadable:[self.torrent objectAtIndex:STATUS] forProgress:[self.torrent objectAtIndex:PERCENT_PROGRESS]]];
	[self.torrentSize setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:SIZE]]];
	[self.torrentProgress setText: [[[self.torrent objectAtIndex:PERCENT_PROGRESS] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:10]] stringValue]];
	[self.torrentDownloaded setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:DOWNLOADED]]];
	[self.torrentUploaded setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:UPLOADED]]];
	[self.torrentRatio setText: [[[self.torrent objectAtIndex:RATIO] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:10]] stringValue]];
	[self.torrentUspeed setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:UPLOAD_SPEED]]];
	[self.torrentDspeed setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:DOWNLOAD_SPEED]]];
	[self.torrentEta setText: [[self.torrent objectAtIndex:ETA] stringValue]];
	[self.torrentPeers setText: [[self.torrent objectAtIndex:PEERS_CONNECTED] stringValue]];
	[self.torrentSeeds setText: [[self.torrent objectAtIndex:SEEDS_CONNECTED] stringValue]];
	[self.torrentAvail setText: [[[self.torrent objectAtIndex:AVAILABILITY] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:65535]] stringValue]];
	[self.torrentRem setText: [Utilities getSizeReadable:[self.torrent objectAtIndex:REMAINING]]];
}

- (void)refresh {
	
}


- (void)dealloc {
    [super dealloc];
}


@end
