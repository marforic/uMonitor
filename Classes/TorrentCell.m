//
//  TorrentCell.m
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TorrentCell.h"
#import "uTorrentConstants.h"

@implementation TorrentCell

@synthesize titleLabel, statusLabel, sizeLabel, doneLabel, DLLabel, ULLabel, ETALabel, peersLabel, seedsLabel, progressView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		UIView *myContentView = self.contentView;
		
		// initialize title label
		self.titleLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES]; 
		self.titleLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.titleLabel];
		[self.titleLabel release];
		
		self.sizeLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		self.sizeLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.sizeLabel];
		[self.sizeLabel release];
		
		self.statusLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		self.statusLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.statusLabel];
		[self.statusLabel release];
		
		self.doneLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		self.doneLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.doneLabel];
		[self.doneLabel release];
		
		self.progressView = [UIProgressView alloc];
		[self.progressView initWithProgressViewStyle:UIProgressViewStyleDefault];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress {
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

-(NSString *)getSizeReadable:(NSDecimalNumber *)size {
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

-(float)getProgressForBar:(NSDecimalNumber *)progress {
	int theProgress = [progress intValue];
	return theProgress/100;
}

-(void)setData:(NSArray *)data {
	self.titleLabel.text = [data objectAtIndex:NAME];
	
	NSString * size = @"Size: ";
	NSString * sizeText = [size stringByAppendingString:[self getSizeReadable:[data objectAtIndex:SIZE]]];
	self.sizeLabel.text = sizeText;
	
	NSString * done = @"Done: ";
	NSString * doneText = [done stringByAppendingString:[self getSizeReadable:[data objectAtIndex:DOWNLOADED]]];
	self.doneLabel.text = doneText;
	
	NSLog(@"progress: %@ is: %@", [data objectAtIndex:PERCENT_PROGRESS], [[data objectAtIndex:PERCENT_PROGRESS] class]);
	self.progressView.progress = [self getProgressForBar:[data objectAtIndex:PERCENT_PROGRESS]];
	
	NSString * status = @"Status: ";
	NSString * statusText = [status stringByAppendingString:[self getStatusReadable:[data objectAtIndex:STATUS]
																		forProgress:[data objectAtIndex:PERCENT_PROGRESS]]];
	self.statusLabel.text = statusText;
}

- (void)layoutSubviews {
	
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
		 */
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
}

/*
 this function was taken from an XML example
 provided by Apple
 
 I can take no credit in this
 */
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
	 Create and configure a label.
	 */
	
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}




- (void)dealloc {
	[titleLabel dealloc];
	[sizeLabel dealloc];
	[statusLabel dealloc];
	[doneLabel dealloc];
	[progressView dealloc];
    [super dealloc];
}


@end
