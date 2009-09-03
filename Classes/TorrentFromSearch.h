//
//  TorrentFromSearch.h
//  uTorrentView
//
//  Created by Claudio Marforio on 9/3/09.
//  Copyright 2009 Erhart-Strasse 8152 Opfikon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TorrentFromSearch : NSObject {
	@private
	NSString * name;
	NSString * categoryName;
	NSString * subcategoryName;
	NSString * language;
	NSString * uploader;
	NSInteger category, subcategory, seeds, leechers;
	float size;
}

@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * categoryName;
@property(nonatomic, retain) NSString * subcategoryName;
@property(nonatomic, retain) NSString * language;
@property(nonatomic, retain) NSString * uploader;

@property(assign) NSInteger category;
@property(assign) NSInteger subcategory;
@property(assign) NSInteger seeds;
@property(assign) NSInteger leechers;
@property(assign) float size;

@end
