//
//  Utilities.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#import "uTorrentConstants.h"


@implementation Utilities

+(NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress {
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

+(int) getStatusProgrammable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress {
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

+(NSString *)getSizeReadable:(NSDecimalNumber *)size {
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

+(NSString *)getSpeedReadable:(NSDecimalNumber *)speed {
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

+(NSString *)getETAReadable:(NSDecimalNumber *)eta {
	// TODO: non capisco come mai il codice sotto qui' non funziona.
	/*int theETA = [eta intValue];
	NSDate * now = [[NSDate alloc] dateWithTimeIntervalSinceNow:(NSTimeInterval)theETA];
	return [now description];*/
	return @"TODO";
}

+(NSString *)getAvailabilityReadable:(NSDecimalNumber *)availability {
	double theAvailability = [availability doubleValue];
	float tmpAvailability = theAvailability / 65535;
	NSString * ret = [NSString stringWithFormat:@"%1.2f", tmpAvailability];
	return ret;
}


+(NSString *)getRatioReadable:(NSDecimalNumber *)ratio {
	float theRatio = [ratio floatValue];
	float tmpRet = theRatio / 1000;
	NSString * ret = [NSString stringWithFormat:@"%1.2f", tmpRet];
	return ret;
}

+(void)createAndShowAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:self 
										  cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];	
}

+(void)alertOKCancelAction:(NSString *)title andMessage:(NSString *)message withDelegate:(id)del {
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:del cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

+(void)showLoadingCursorForViewController:(UIViewController *)controller {
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



@end
