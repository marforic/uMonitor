/*
TorrentCell.h
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

#import <UIKit/UIKit.h>

@class uTorrentViewAppDelegate;

@interface TorrentCell : UITableViewCell {
	@private
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * sizeLabel;
	IBOutlet UILabel * doneLabel;
	IBOutlet UILabel * uploadLabel;
	IBOutlet UILabel * downloadLabel;
	IBOutlet UILabel * downloadPercentageLabel;
	IBOutlet UIImageView * statusImage;
	IBOutlet UIImageView * labelImage;
	IBOutlet UIProgressView * progressView;
	UIImage * nonColoredImage;
}

@property(nonatomic, retain) IBOutlet UILabel * nameLabel;
@property(nonatomic, retain) IBOutlet UILabel * sizeLabel;
@property(nonatomic, retain) IBOutlet UILabel * doneLabel;
@property(nonatomic, retain) IBOutlet UILabel * uploadLabel;
@property(nonatomic, retain) IBOutlet UILabel * downloadLabel;
@property(nonatomic, retain) IBOutlet UILabel * downloadPercentageLabel;
@property(nonatomic, retain) IBOutlet UIImageView * statusImage;
@property(nonatomic, retain) IBOutlet UIImageView * labelImage;
@property(nonatomic, retain) IBOutlet UIProgressView * progressView;

- (void)setData:(NSArray *)data;
- (float)getProgressForBar:(NSDecimalNumber *)progress;

@end
