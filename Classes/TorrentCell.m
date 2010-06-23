/*
TorrentCell.m
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

#import "TorrentCell.h"
#import "uTorrentConstants.h"
#import "Utilities.h"
#import "uTorrentViewAppDelegate.h"

@implementation TorrentCell

@synthesize nameLabel, sizeLabel, doneLabel, uploadLabel, downloadLabel, statusImage, labelImage, progressView, downloadPercentageLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
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
	
	labelImage.image = [Utilities colorizeImage:nonColoredImage
										  color:[UIColor colorWithHue:colorHue
														   saturation:1.0 
														   brightness:colorBrightness 
																alpha:1.0]];
	
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
	
	downloadPercentageLabel.font = [UIFont systemFontOfSize:12];
	downloadPercentageLabel.text = [NSString stringWithFormat:@"%i%%", (int)([[data objectAtIndex:PERCENT_PROGRESS] intValue] / 10)];
	
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
	
}

- (void)dealloc {
	[nameLabel release];
	[sizeLabel release];
	[doneLabel release];
	[uploadLabel release];
	[downloadLabel release];
	[progressView release];
	[statusImage release];
	[labelImage release];
	[downloadPercentageLabel release];
    [super dealloc];
}


@end
