//
//  TorrentFromSearch.h
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Torrent : NSObject {
	@private
	NSString * title;
	NSString * categoryName;
	NSString * subcategoryName;
	NSString * language;
	NSString * uploader;
	NSInteger seeds, leechers;
	NSString * date;
	NSString * unit;
	NSString * link;
	float size;
}

@property(nonatomic, retain) NSString * title;
@property(nonatomic, retain) NSString * categoryName;
@property(nonatomic, retain) NSString * subcategoryName;
@property(nonatomic, retain) NSString * language;
@property(nonatomic, retain) NSString * uploader;
@property(nonatomic, retain) NSString * date;
@property(nonatomic, retain) NSString * link;
@property(nonatomic, retain) NSString * unit;

@property(assign) NSInteger seeds;
@property(assign) NSInteger leechers;
@property(assign) float size;

- (void)parseDescription:(NSString *)description;

@end
