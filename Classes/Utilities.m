/*
Utilities.m
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

#import "Utilities.h"

#import "uTorrentConstants.h"

@implementation Utilities

+ (NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress {
	int theStatus = [status intValue];
	int theProgress = [progress intValue];
	bool flag = false;
	NSString * ret = @"";
	
	if ((theStatus & 1) == 1){ //Started
		if ((theStatus & 32) == 32){ //paused
			ret = @"Paused";
			flag = true;
		} else { //seeding or leeching
			if ((theStatus & 64) == 64) {
				ret = (theProgress == 1000) ? @"Seeding" : @"Downloading";
				flag = true;
			}
			else {
				ret = (theProgress == 1000) ? @"Forced Seeding" : @"Forced Downloading";
				flag = true;
			}
		}
	} else if ((theStatus & 2) == 2){ //checking
		ret = @"Checking";
		flag = true;
	} else if ((theStatus & 16) == 16){ //error
		ret = @"Error";
		flag = true;
	} else if ((theStatus & 64) == 64){ //queued
		ret = @"Queued";
		flag = true;
	}
	
	if (theProgress == 1000 && !flag) {
		ret = @"Finished";
	}
	else if (theProgress < 1000 && !flag) {
		ret = @"Stopped";
	}
	
	return ret;
	
}

+ (int)getStatusProgrammable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress {
	int theStatus = [status intValue];
	int theProgress = [progress intValue];
	bool flag = false;
	int ret = STOPPED;
	
	if ((theStatus & 1) == 1){ //Started
		if ((theStatus & 32) == 32){ //paused
			ret = PAUSED;
			flag = true;
		} else { //seeding or leeching
			if ((theStatus & 64) == 64) {
				ret = (theProgress == 1000) ? SEEDING : LEECHING;
				flag = true;
			}
			else {
				ret = (theProgress == 1000) ? SEEDING : LEECHING;
				flag = true;
			}
		}
	} else if ((theStatus & 2) == 2){ //checking
		ret = CHECKING;
		flag = true;
	} else if ((theStatus & 16) == 16){ //error
		ret = ERROR;
		flag = true;
	} else if ((theStatus & 64) == 64){ //queued
		ret = QUEUED;
		flag = true;
	}
	
	if (theProgress == 1000 && !flag) {
		ret = FINISHED;
	}
	else if (theProgress < 1000 && !flag) {
		ret = STOPPED;
	}
	
	return ret;
}

+ (NSString *)getSizeReadable:(NSDecimalNumber *)size {
	double theSize = [size doubleValue];
	float floatSize = theSize;
	if (theSize < 1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

+ (NSString *)getSpeedReadable:(NSDecimalNumber *)speed {
	double theSpeed = [speed doubleValue];
	float floatSize = theSpeed;
	//if (theSpeed < 1023)
	//	return([NSString stringWithFormat:@"%1.1f bytes/s",theSpeed]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f kB/s",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return([NSString stringWithFormat:@"%1.1f MB/s",floatSize]);
	floatSize = floatSize / 1024;
	// codiez se scaricano cosi': GIEF BANDA!!!
	return([NSString stringWithFormat:@"%1.1f GB/s",floatSize]);
}

+ (NSString *)getETAReadable:(NSDecimalNumber *)eta {
	double theETA = [eta doubleValue];
	if (theETA == -1)
		return @"∞";
	else if (theETA == 0)
		return @"DONE";
	else {
		NSDate * futureDone = [[NSDate alloc] initWithTimeIntervalSinceNow:theETA];
		int sinceNow = [futureDone timeIntervalSinceNow];
		[futureDone release];
		int week = (int)(sinceNow / 604800);
		int day = (int)((sinceNow % 604800) / 86400);
		if (week > 0)
			return [NSString stringWithFormat:@"%iw %id", week, day];
		int hour = (int)((sinceNow % 86400) / 3600);
		if (day > 0)
			return [NSString stringWithFormat:@"%id %ih", day, hour];
		int minutes = (int)((sinceNow % 3600) / 60);
		if (hour > 0)
			return [NSString stringWithFormat:@"%ih %im", hour, minutes];
		int seconds = (int)((sinceNow % 3600) % 60);
		if (minutes > 0)
			return [NSString stringWithFormat:@"%im %is", minutes, seconds];
		if (seconds > 0)
			return [NSString stringWithFormat:@"%is", seconds];
	}
	return @"Unknown";
}

+ (NSString *)getAvailabilityReadable:(NSDecimalNumber *)availability {
	double theAvailability = [availability doubleValue];
	float tmpAvailability = theAvailability / 65535;
	NSString * ret = [NSString stringWithFormat:@"%1.2f", tmpAvailability];
	return ret;
}


+ (NSString *)getRatioReadable:(NSDecimalNumber *)ratio {
	float theRatio = [ratio floatValue];
	float tmpRet = theRatio / 1000;
	NSString * ret = [NSString stringWithFormat:@"%1.2f", tmpRet];
	return ret;
}

+ (void)createAndShowAlertWithTitle:(NSString *)title andMessage:(NSString *)message withDelegate:(id)del andTag:(NSInteger)tag {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:del 
										  cancelButtonTitle:@"OK" otherButtonTitles: nil];
	alert.tag = tag;
	[alert show];	
	[alert release];	
}

+ (void)alertOKCancelAction:(NSString *)title andMessage:(NSString *)message withDelegate:(id)del {
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:del cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

+ (void)showLoadingCursorForViewController:(UIViewController *)controller {
	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:frame];
	[loading startAnimating];
	[loading sizeToFit];
	loading.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
								UIViewAutoresizingFlexibleRightMargin |
								UIViewAutoresizingFlexibleTopMargin |
								UIViewAutoresizingFlexibleBottomMargin);
	
	// initing the bar button
	UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:loading];
	[loading release];
	loadingView.target = controller;
	controller.navigationItem.leftBarButtonItem = loadingView;
}

+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSArray *)RGBtoHSB:(UIColor *)RGBcolor {
	float r, g, b = 0.0f;
	float v, x, f = 0.0f;
	int i = 0;
	NSArray * ret;
	r = CGColorGetComponents(RGBcolor.CGColor)[0];
	g = CGColorGetComponents(RGBcolor.CGColor)[1];
	b = CGColorGetComponents(RGBcolor.CGColor)[2];
	x = fminf(r, fminf(g, b));
	v = fmaxf(r, fmaxf(g, b));
	if (v == x) {
		ret = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], 
			   [NSNumber numberWithFloat:0.0f], 
			   [NSNumber numberWithFloat:v], 
			   nil];
		return ret;
	}
	f = (r == x) ? g - b : ((g == x) ? b - r : r - g);
	i = (r == x) ? 3 : ((g == x) ? 5 : 1);
	ret = [NSArray arrayWithObjects:[NSNumber numberWithFloat:((i - f /(v - x)) / 6)], 
					 [NSNumber numberWithFloat:(v - x) / v], 
					 [NSNumber numberWithFloat:v], 
					 nil];
	return ret;
}

+ (void)insertItemOrderedByName:(NSArray *)item inArrey:(NSMutableArray *)ma {
	NSUInteger i, count = [ma count];
	NSString * itemName = [item objectAtIndex:NAME];
	if (count == 0) {
		[ma addObject:item];
	} else {
		for (i = 0; i < count; i++) {
			NSArray * a = (NSArray *)[ma objectAtIndex:i];
			NSString * aName = [a objectAtIndex:NAME];
			if ([itemName compare:aName] == NSOrderedAscending) {
				[ma insertObject:item atIndex:i];
				break;
			} else if (i == (count - 1))
				[ma addObject:item];
		}
	}
}

+ (void)removeNotNeededTorrentsFromList:(NSArray *)organizedTorrents 
						andOriginalList:(NSMutableArray *)torrentsData
					   usingRemovedList:(NSArray *)removedTorrents 
						 andNeedToDelete:(BOOL)needToDelete {
	if (removedTorrents != nil) {
		NSInteger count = [organizedTorrents count];
		BOOL stop = NO;
		for (NSString * rm in removedTorrents) {
			for (NSInteger i = 0; i < count && !stop; i++) {
				NSMutableArray * ma = (NSMutableArray *)[organizedTorrents objectAtIndex:i];
				NSUInteger j, count2 = [ma count];
				for (j = 0; j < count2 && !stop; j++) {
					NSArray * t = (NSArray *)[ma objectAtIndex:j];
					NSString * tHash = (NSString *)[t objectAtIndex:HASH];
					if ([rm isEqual:tHash]) {
						[ma removeObjectAtIndex:j];
						stop = YES;
					}
				}
			}
			stop = NO;
		}
	} else if (needToDelete) {
		BOOL toRemove = YES;
		NSInteger i, count = [organizedTorrents count];
		NSUInteger k, count3 = [torrentsData count];
		for (i = 0; i < count; i++) {
			NSMutableArray * indexToRemove = [[NSMutableArray alloc] init];
			NSMutableArray * ma = (NSMutableArray *)[organizedTorrents objectAtIndex:i];
			NSUInteger j, count2 = [ma count];
			for (j = 0; j < count2; j++) {
				NSArray * a = (NSArray *)[ma objectAtIndex:j];
				NSString * aHASH = (NSString *)[a objectAtIndex:HASH];
				for (k = 0; k < count3; k++) {
					NSArray * b = (NSArray *)[torrentsData objectAtIndex:k];
					NSString * bHash = (NSString *)[b objectAtIndex:HASH];
					if ([aHASH isEqual:bHash]) {
						toRemove = NO;
						break;
					}
				}
				if (toRemove)
					[indexToRemove addObject:[NSNumber numberWithInt:j]];
				toRemove = YES;
			}
			NSUInteger l, count4 = [indexToRemove count];
			for (l = 0; l < count4; l++) {
				NSNumber * n = (NSNumber *)[indexToRemove objectAtIndex:l];
				[ma removeObjectAtIndex:[n intValue]];
			}
			[indexToRemove release];
		}
	}
}

+ (URL_TYPE)getURLType:(NSString *)urlString {
	URL_TYPE urlType = URL_TYPE_UNKNOWN;
	NSString *lowerCaseURLString = [urlString lowercaseString];
	NSArray *urlArray = [lowerCaseURLString componentsSeparatedByString:@"/"];
	NSString *urlObject = [urlArray lastObject];
	NSString *urlBase = [urlArray objectAtIndex:2];
	
	NSArray *urlExtention = [urlObject componentsSeparatedByString:@"."];
	
	if ((([urlExtention count] > 1) && ([[urlExtention lastObject] isEqual:@"torrent"])) ||
		(([urlExtention count] > 1) && ([[urlExtention lastObject] rangeOfString:@"downloadtorrent"].location != NSNotFound)) ||
		(([urlBase isEqual:@"www.mininova.org"]) && ([urlArray count] > 3) && ([[urlArray objectAtIndex:3] isEqual:@"get"])) ||
		(([urlBase isEqual:@"www.demonoid.com"]) && ([urlArray count] > 4) && ([[urlArray objectAtIndex:4] isEqual:@"download"])) ||
		(([urlBase isEqual:@"www.torrent411.com"]) && ([urlArray count] > 3) && ([[urlArray objectAtIndex:3] rangeOfString:@"download.php?id="].location != NSNotFound))
		) {
		// Tested with :
		// - torrentleech
		// - torrentbytes
		// - demonoid
		// - pirate bay
		// - mininova
		// - isoHunt
		// Not working with :
		// - torrent411 (problem with getting file => it gives a 0 bytes file ...)
		urlType = URL_TYPE_DOWNLOAD_TORRENT;
	} else if (([urlExtention count] > 1) &&
			   ((([[urlExtention lastObject] length] == 3)&&
				 (![[urlExtention lastObject] isEqual:@"htm"])&&
				 (![[urlExtention lastObject] isEqual:@"php"])&&
				 (![[urlExtention lastObject] isEqual:@"jpg"])&&
				 (![[urlExtention lastObject] isEqual:@"png"])&&
				 (![[urlExtention lastObject] isEqual:@"com"])&&
				 (![[urlExtention lastObject] isEqual:@"gif"])
				 ) ||
			    ([[urlExtention lastObject] isEqual:@"divx"]) ||
			    ([[urlExtention lastObject] isEqual:@"ipsw"]) ||
				([[urlExtention lastObject] isEqual:@"7z"])
				)) {
				   urlType = URL_TYPE_DOWNLOAD_HTTP_FTP;
			   } else {
				   urlType = URL_TYPE_DONT_DOWNLOAD;
			   }
	return urlType;
}

@end
