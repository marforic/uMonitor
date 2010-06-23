/*
LabelCell.m
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

#import "LabelCell.h"
#import "BlueBadge.h"
#import "Utilities.h"

@implementation LabelCell

@synthesize labelColor, colorizedImage, labelImage, labelLabel;

- (void)setCellDataWithLabelString:(NSString *)label withNumber:(NSDecimalNumber *)count colorString:(UIColor *)color {
	self.labelColor = color;
	labelLabel.text = label;
	
	self.colorizedImage = [Utilities colorizeImage:labelImage.image color:color];
	UIImage * tmpImage = labelImage.image;
	labelImage.image = colorizedImage;
	self.colorizedImage = tmpImage;
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame = CGRectMake(boundsX + 250, 12, 40, 40);
	BlueBadge *blueBadge = [[BlueBadge alloc] initWithFrame:frame];
	[blueBadge drawWithCount:[count intValue]];
	[self.contentView addSubview:blueBadge];
	[blueBadge release];
}

- (void)dealloc {
	[labelLabel release];
	[labelImage release];
	[colorizedImage release];
	[labelColor release];
    [super dealloc];
}


@end
