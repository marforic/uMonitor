/*
RootViewController.h
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
#import "TorrentListener.h"
#import "TorrentOrganizer.h"

@class TorrentNetworkManager;
@class uTorrentViewAppDelegate;
@class TorrentCell;

@interface RootViewController : UITableViewController<TorrentListener, UISearchDisplayDelegate, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
	@private
	NSUInteger currentOrganizer;
	NSInteger savedScopeButtonIndex;
	NSInteger selectedSorting;
	BOOL searchWasActive;
	IBOutlet UITableView * torrentsTable;
	IBOutlet TorrentCell * cell;
	IBOutlet UIPickerView * pickerView;
	IBOutlet UIView * allPickerView;
	TorrentNetworkManager * tnm;
	uTorrentViewAppDelegate * mainAppDelegate;
	NSArray * organizers;
	NSMutableArray * filteredListContent;
	NSString * savedSearchTerm;
}

@property(nonatomic, retain) IBOutlet UITableView *torrentsTable;
@property(nonatomic, retain) IBOutlet UIPickerView * pickerView;
@property(nonatomic, retain) IBOutlet UIView * allPickerView;
@property(nonatomic, retain) uTorrentViewAppDelegate * mainAppDelegate;
@property(nonatomic, retain) NSArray * organizers;

@property(nonatomic, retain) NSMutableArray * filteredListContent;
@property(nonatomic, copy) NSString * savedSearchTerm;
@property(nonatomic) NSInteger savedScopeButtonIndex;
@property(nonatomic) BOOL searchWasActive;

- (void)networkRequest;
- (void)toggleOrganizer;

@end
