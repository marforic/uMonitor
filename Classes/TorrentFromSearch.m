/*
TorrentFromSearch.m
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

#import "TorrentFromSearch.h"


@implementation TorrentFromSearch

@synthesize title, categoryName, subcategoryName, language, uploader, seeds, leechers, size, date, link, unit;

- (void)parseDescription:(NSString *)description {
	/*
	 * Parse a mininova description, something like:
	 * --------------------------------------------------------------------------------
	 * Category: <a href="http://www.mininova.org/cat/2">Books</a><br />
	 * Subcategory: <a href="http://www.mininova.org/sub/50">Ebooks</a><br />
	 * Size: 2.66&nbsp;megabyte<br />
	 * Ratio: 27 seeds, 4 leechers<br />
	 * Language: Unknown<br />
	 * Uploaded by: <a href="http://www.mininova.org/user/tqw">tqw</a>
	 * --------------------------------------------------------------------------------
	 */
	NSScanner * scanner = [NSScanner scannerWithString:description];
	[scanner scanUpToString:@"Size: " intoString:NULL];
	[scanner scanString:@"Size: " intoString:NULL];
	[scanner scanFloat:&size];
	[scanner scanUpToString:@"&nbsp;" intoString:NULL];
	[scanner scanString:@"&nbsp;" intoString:NULL];
	[scanner scanUpToString:@"<" intoString:&unit];
	[unit retain];
	[scanner scanUpToString:@"Ratio: " intoString:NULL];
	[scanner scanString:@"Ratio: " intoString:NULL];
	[scanner scanInt:&seeds];
	[scanner scanString:@" seeds, " intoString:NULL];
	[scanner scanInt:&leechers];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"title: %@\ncategory: %@\ndate: %@\nlink: %@", title, categoryName, date, link];
}

- (void)dealloc {
	[title release];
	[categoryName release];
	[subcategoryName release];
	[language release];
	[uploader release];
	[date release];
	[link release];
	[unit release];
	[super dealloc];
}

@end
