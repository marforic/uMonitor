//
//  TorrentCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TorrentCell.h"
#import "uTorrentConstants.h"
#import "Utilities.h"

@implementation TorrentCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/*
 * Takes a progress in format x/1000 and outputs it's value in float format
 * example: 100/1000 = 0.1
 * To be used for progress bars which takes arguments from 0.0 to 1.0
 */
-(float)getProgressForBar:(NSDecimalNumber *)progress {
	float theProgress = [progress floatValue];
	float ret = theProgress / 1000;
	return ret;
}

-(void)setData:(NSArray *)data {
	/*if (!mainAppDelegate)
		mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// uncache cached images to refresh them
	if (mainAppDelegate.cacheNeedsRefresh) {
		cachedStatus = nil;
		cachedLabel = nil;
		mainAppDelegate.cacheNeedsRefresh = NO;
	}
	*/
	
	
	nonColoredImage = [UIImage imageNamed:@"my_flag.png"];
	
	nameLabel.text = [data objectAtIndex:NAME];	
	
	NSArray * color;
	if ([[data objectAtIndex:LABEL] length] != 0)
		color = [[NSUserDefaults standardUserDefaults] arrayForKey:[data objectAtIndex:LABEL]];
	else
		color = [[NSUserDefaults standardUserDefaults] arrayForKey:@"nolabel"];
	float colorHue, colorBrightness = 0.0f;
	if (color != nil) {
		colorHue = [[color objectAtIndex:0] floatValue];
		colorBrightness = [[color objectAtIndex:1] floatValue];
	} else {
		colorHue = 0.5f;
		colorBrightness = 0.4f;
	}

	//if (cachedLabel == nil) {
		//NSLog(@"I'm %@ colorHue: %f, brightness: %f", [data objectAtIndex:NAME], colorHue, colorBrightness);
		labelImage.image = [Utilities colorizeImage:nonColoredImage
											  color:[UIColor colorWithHue:colorHue
															   saturation:1.0 
															   brightness:colorBrightness 
																	alpha:1.0]];
	//	cachedLabel = labelImage.image;
	//} else {
		//NSLog (@"using cached image!!!!");
	//	labelImage.image = cachedLabel;
	//}
	
	
	sizeLabel.font = [UIFont systemFontOfSize:12];
	sizeLabel.text = @"Size: ";
	sizeLabel.text = [sizeLabel.text stringByAppendingString:[Utilities getSizeReadable:[data objectAtIndex:SIZE]]];
	
	doneLabel.font = [UIFont systemFontOfSize:12];
	doneLabel.text = @"Done: ";
	doneLabel.text = [doneLabel.text stringByAppendingString:[Utilities getSizeReadable:[data objectAtIndex:DOWNLOADED]]];
	
	uploadLabel.font = [UIFont systemFontOfSize:12];
	uploadLabel.text = @"UL: ";
	uploadLabel.text = [uploadLabel.text stringByAppendingString:[Utilities getSpeedReadable:[data objectAtIndex:UPLOAD_SPEED]]];
	
	downloadLabel.font = [UIFont systemFontOfSize:12];
	downloadLabel.text = @"DL: ";
	downloadLabel.text = [downloadLabel.text stringByAppendingString:[Utilities getSpeedReadable:[data objectAtIndex:DOWNLOAD_SPEED]]];

	progressView.progress = [self getProgressForBar:[data objectAtIndex:PERCENT_PROGRESS]];
	
	
	//if (cachedStatus == nil) {
		switch ([Utilities getStatusProgrammable:[data objectAtIndex:STATUS] forProgress:[data objectAtIndex:PERCENT_PROGRESS]]) {
			case LEECHING:
				statusImage.image = [[UIImage imageNamed:@"status_green.png"] retain];
				break;
			case SEEDING:
				statusImage.image = [[UIImage imageNamed:@"status_blue.png"] retain];
				break;
			case PAUSED:
				statusImage.image = [[UIImage imageNamed:@"status_yellow.png"] retain];
				break;
			case CHECKING:// same as stopped
			case STOPPED:
				statusImage.image = [[UIImage imageNamed:@"status_grey.png"] retain];
				break;
			case FINISHED:
				statusImage.image = [[UIImage imageNamed:@"status_violet.png"] retain];
				break;
			case ERROR:
				statusImage.image = [[UIImage imageNamed:@"status_skull.png"] retain];
				break;
		}
	//	cachedStatus = statusImage.image;
	//} else {
	//	statusImage.image = cachedStatus;
	//}
	
}

/*- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        /*
		 Place the title label.
		 place the label whatever the current X is plus 10 pixels from the left
		 place the label 4 pixels from the top
		 make the label 300 pixels wide
		 make the label 20 pixels high
		 
		frame = CGRectMake(boundsX + 10, 4, 300, 20);
		self.titleLabel.frame = frame;
		
		// place the size label
		frame = CGRectMake(boundsX + 10, 20, 100, 20);
		self.sizeLabel.frame = frame;
		
		// place the done label
		frame = CGRectMake(boundsX + 110, 20, 100, 20);
		self.doneLabel.frame = frame;
		
		// place the progress bar
		[self.contentView addSubview:self.progressView];
		frame = CGRectMake(boundsX + 10, 40, 270, 20);
		self.progressView.frame = frame;
		
		// place the status label
		frame = CGRectMake(boundsX + 10, 50, 200, 20);
		self.statusLabel.frame = frame;
	}
}*/

- (void)dealloc {
	[statusImage release];
	[labelImage release];
    [super dealloc];
}


@end
