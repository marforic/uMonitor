//
//  TorrentBrowserCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import "TorrentBrowserCell.h"


@implementation TorrentBrowserCell

@synthesize torrentName, torrentSeeds, torrentLeechers, torrentSize, torrentCategory, torrentSite;

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
		[self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[torrentName release];
	[torrentSeeds release];
	[torrentLeechers release];
	[torrentSize release];
	[torrentCategory release];
	[torrentSite release];
    [super dealloc];
}


@end
