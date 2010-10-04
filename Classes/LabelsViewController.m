/*
LabelsViewController.m
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

#import "uTorrentViewAppDelegate.h"
#import "LabelsViewController.h"
#import "TorrentNetworkManager.h"
#import "Utilities.h"
#import "TorrentListener.h"
#import "LabelSlidersView.h"
#import "LabelCell.h"

#import <math.h>

@implementation LabelsViewController

@synthesize labelsTable, mainAppDelegate, cell, fakeView, sliderView, currentlyEditingCell, plainThumbImage, tnm;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.tnm = [mainAppDelegate getTNM];
	[tnm addListener:self];
	
	// set the title
	self.navigationItem.title = @"Labels";
	// set the refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest)];
	
	// plainThumbImage
	self.plainThumbImage = [UIImage imageNamed:@"ring.png"];
	// sliderView definition
	CGRect frame = self.sliderView.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = self.view.frame.size.height - 350;
	self.sliderView.frame = frame;
	[self.fakeView addSubview:self.sliderView];
	// set the paramenters
	[self.sliderView.hue setMinimumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
	[self.sliderView.hue setMaximumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
	[self.sliderView.hue setThumbImage:self.plainThumbImage forState:UIControlStateNormal];
	[self.sliderView.brightness setMinimumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
	[self.sliderView.brightness setMaximumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
	[self.sliderView.brightness setThumbImage:self.plainThumbImage forState:UIControlStateNormal];
	// add selectors for events
	[self.sliderView.hue addTarget:self action:@selector(updateHueSlider) forControlEvents:UIControlEventValueChanged];
	[self.sliderView.hue addTarget:self action:@selector(updateBrightnessSlider) forControlEvents:UIControlEventValueChanged];
	[self.sliderView.brightness addTarget:self action:@selector(updateBrightnessSlider) forControlEvents:UIControlEventValueChanged];
	
	// add fakeView
	[self.view addSubview:self.fakeView];
}

- (void)networkRequest {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	[Utilities showLoadingCursorForViewController:self];
	// create the request
	[tnm requestList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)update:(NSUInteger)type {
	[labelsTable reloadData];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.navigationItem.leftBarButtonItem release];
	self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int unlabelled = 0;
	if ((unlabelled = [[tnm updateUnlabelledTorrents] intValue]) == 0)
		return [tnm.labelsData count]; // no unlabelled torrents
	else
		return [tnm.labelsData count] + 1; // unlabelled torrents
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LabelsCell";
    
	cell = (LabelCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LabelCell" owner:self options:nil];
		//NSLog(@"%i, %i", indexPath.row, [tnm.labelsData count]);
		if (indexPath.row < [tnm.labelsData count]) {
			NSArray * color = [[NSUserDefaults standardUserDefaults] arrayForKey:[[tnm.labelsData objectAtIndex:indexPath.row] objectAtIndex:0]];
			float colorHue, colorBrightness = 0.0f;
			if (color != nil) {
				colorHue = [[color objectAtIndex:0] floatValue];
				colorBrightness = [[color objectAtIndex:1] floatValue];
			} else {
				colorHue = 0.5f;
				colorBrightness = 0.4f;
			}
			UIColor * theColor = [[UIColor alloc] initWithHue:colorHue saturation:1.0f brightness:colorBrightness alpha:1.0f];
			[cell setCellDataWithLabelString:[[tnm.labelsData objectAtIndex:indexPath.row] objectAtIndex:0] 
								  withNumber:[[tnm.labelsData objectAtIndex:indexPath.row] objectAtIndex:1]
								 colorString:theColor];
			[theColor release];
		} else { // no label case
			NSArray * color = [[NSUserDefaults standardUserDefaults] arrayForKey:@"nolabel"];
			float colorHue, colorBrightness = 0.0f;
			if (color != nil) {
				colorHue = [[color objectAtIndex:0] floatValue];
				colorBrightness = [[color objectAtIndex:1] floatValue];
			} else {
				colorHue = 0.5f;
				colorBrightness = 0.4f;
			}
			UIColor * theColor = [[UIColor alloc] initWithHue:colorHue saturation:1.0f brightness:colorBrightness alpha:1.0f];
			[cell setCellDataWithLabelString:@"No Label"
								  withNumber:(NSDecimalNumber *)[tnm updateUnlabelledTorrents]
								 colorString:theColor];
			[theColor release];
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationController dismissModalViewControllerAnimated:YES]; 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	currentlyEditingCell = (LabelCell *)[tableView cellForRowAtIndexPath:indexPath];

	// configure values of sliderView
	sliderView.hue.value = [[[Utilities RGBtoHSB:currentlyEditingCell.labelColor] objectAtIndex:0] floatValue];
	sliderView.brightness.value = [[[Utilities RGBtoHSB:currentlyEditingCell.labelColor] objectAtIndex:2] floatValue];
	[self updateHueSlider];
	[self updateBrightnessSlider];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	fakeView.alpha = 1;
	sliderView.alpha = 1;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark LabelsSliderView

- (IBAction)cancelButtonPressed:(id)sender {
	currentlyEditingCell = nil;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	fakeView.alpha = 0.0;
	sliderView.alpha = 0.0;
	[UIView commitAnimations];
}

- (IBAction)okButtonPressed:(id)sender {
	float hS = self.sliderView.hue.value;
	float bS = self.sliderView.brightness.value;
	// set label image color
	currentlyEditingCell.labelColor = [[UIColor alloc] initWithHue:hS saturation:1.0f brightness:bS alpha:1.0];
	currentlyEditingCell.labelImage.image = [Utilities colorizeImage:currentlyEditingCell.colorizedImage color:currentlyEditingCell.labelColor];
	[currentlyEditingCell.labelColor release];
	// save info into UserDefaults
	NSArray * colorInfo = [NSArray arrayWithObjects:[NSNumber numberWithFloat:hS], [NSNumber numberWithFloat:bS], nil];
	if ([currentlyEditingCell.labelLabel.text isEqual:@"No Label"])
		[[NSUserDefaults standardUserDefaults] setObject:colorInfo forKey:@"nolabel"];
	else
		[[NSUserDefaults standardUserDefaults] setObject:colorInfo forKey:currentlyEditingCell.labelLabel.text];
	
	// remove the views
	[self cancelButtonPressed:sender];
}

- (void) updateHueSlider {
	UIColor * color = [[UIColor alloc] initWithHue:self.sliderView.hue.value 
										saturation:1.0 
										brightness:1.0
											 alpha:1.0];
	UIImage * tmpImage = [Utilities colorizeImage:self.plainThumbImage 
											color:color];
	[color release];
	[self.sliderView.hue setThumbImage:tmpImage forState:UIControlStateNormal];
}

- (void) updateBrightnessSlider {
	UIColor * color = [[UIColor alloc] initWithHue:self.sliderView.hue.value 
										saturation: 1.0 
										brightness:self.sliderView.brightness.value 
											 alpha:1.0];
	UIImage * tmpImage = [Utilities colorizeImage:self.plainThumbImage
											color:color];
	[color release];
	[self.sliderView.brightness setThumbImage:tmpImage forState:UIControlStateNormal];
}

- (void)dealloc {	
	[tnm release];
	[cell release];
	[labelsTable release];
	[mainAppDelegate release];
	[fakeView release];
	[sliderView release];
	[plainThumbImage release];
	[currentlyEditingCell release];
	[super dealloc];
}


@end

