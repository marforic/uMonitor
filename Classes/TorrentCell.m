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

@synthesize titleLabel, statusLabel, sizeLabel, doneLabel, DLLabel, ULLabel, ETALabel, peersLabel, seedsLabel, progressView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		UIView *myContentView = self.contentView;
		
		// initialize label
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
	self.titleLabel.text = [data objectAtIndex:NAME];
	
	NSString * size = @"Size: ";
	NSString * sizeText = [size stringByAppendingString:[Utilities getSizeReadable:[data objectAtIndex:SIZE]]];
	self.sizeLabel.text = sizeText;
	
	NSString * done = @"Done: ";
	NSString * doneText = [done stringByAppendingString:[Utilities getSizeReadable:[data objectAtIndex:DOWNLOADED]]];
	self.doneLabel.text = doneText;
	
	self.progressView.progress = [self getProgressForBar:[data objectAtIndex:PERCENT_PROGRESS]];
	
	NSString * status = @"Status: ";
	NSString * statusText = [status stringByAppendingString:[Utilities getStatusReadable:[data objectAtIndex:STATUS]
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
 * Function was taken from an XML example provided by Apple
 */
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
						selectedColor:(UIColor *)selectedColor 
							 fontSize:(CGFloat)fontSize 
								 bold:(BOOL)bold {
	// Create and configure a label.
	
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    /*
	 * Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.
	 * To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
	 * This is handled in setSelected:animated:.
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
