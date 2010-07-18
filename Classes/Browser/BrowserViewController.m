//
//  BrowserViewController.m
//  QGet-Remote
//
//  Created by Sylver Bruneau on 15/05/10.
//  Copyright 2010 Sylver Bruneau. All rights reserved.
//
#import "BrowserViewController.h"
#import "Utilities.h"

static NSURL *lastURL;

@implementation BrowserViewController
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
	// titleView
	locationField = [[UITextField alloc] initWithFrame:CGRectMake(37,7,246,31)];
	locationField.delegate = self;
	locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
	locationField.textAlignment = UITextAlignmentLeft;
	locationField.borderStyle = UITextBorderStyleRoundedRect;
	locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
	locationField.autocorrectionType = UITextAutocorrectionTypeNo;
	locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	locationField.clearsOnBeginEditing = NO;

	locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	locationField.autocorrectionType = UITextAutocorrectionTypeNo;
	locationField.keyboardType = UIKeyboardTypeURL;
	locationField.returnKeyType = UIReturnKeyGo;

	locationField.clearButtonMode = UITextFieldViewModeWhileEditing;

	// rightBarButton
	stopReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
	stopReloadButton.bounds = CGRectMake(0, 0, 26, 30);
	[stopReloadButton setImage:[UIImage imageNamed:@"browserReload.png"] forState:UIControlStateNormal];
	[stopReloadButton setImage:[UIImage imageNamed:@"browserReload.png"] forState:UIControlStateHighlighted];
	stopReloadButton.showsTouchWhenHighlighted = NO;
	[stopReloadButton addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
	locationField.rightView = stopReloadButton;
	locationField.rightViewMode = UITextFieldViewModeUnlessEditing;

	// leftBarButton
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.bounds = CGRectMake(0, 0, 24, 33);
	backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[backButton setImage:[UIImage imageNamed:@"browserBack.png"] forState:UIControlStateNormal];
	[backButton setImage:[UIImage imageNamed:@"browserBack.png"] forState:UIControlStateHighlighted];
	backButton.showsTouchWhenHighlighted = YES;
	[backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];

	// rightBarButton
	forwardButton  = [UIButton buttonWithType:UIButtonTypeCustom];
	forwardButton.bounds = CGRectMake(0, 0, 24, 33);
	forwardButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	forwardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[forwardButton setImage:[UIImage imageNamed:@"browserForward.png"] forState:UIControlStateNormal];
	[forwardButton setImage:[UIImage imageNamed:@"browserForward.png"] forState:UIControlStateHighlighted];
	forwardButton.showsTouchWhenHighlighted = YES;
	[forwardButton addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];

	navigationItem.titleView = locationField;
	navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:forwardButton] autorelease];

	navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
	[self.view addSubview:navigationBar];
	[navigationBar release];

	// webView
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
	webView.scalesPageToFit = YES;
	webView.contentMode = UIViewContentModeScaleToFill;
	webView.multipleTouchEnabled = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:webView];
	[webView release];
}

- (void) dealloc {
	[backButton release];
	[stopReloadButton release];
	[doneButtonItem release];
	[locationField release];
	[webView release];
	[navigationBar release];
	[_urlToLoad release];
	[_urlToHandle release];
	[tnm release];

	[super dealloc];
}

#pragma mark -

- (void) viewDidLoad {
	[super viewDidLoad];

	webView.delegate = self;

	[self updateLoadingStatus];

	_urlToLoad = [[NSURL alloc] initWithString:@"http://www.google.com"];

	if (_urlToLoad.absoluteString.length) {
		[self loadURL:_urlToLoad];
		[_urlToLoad release];
		_urlToLoad = nil;
	} else [locationField becomeFirstResponder];

	uTorrentViewAppDelegate *mainAppDelegate = (uTorrentViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	tnm = [[mainAppDelegate getTNM] retain];

}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -

- (void) loadLastURL {
	self.url = lastURL;
}

- (void) loadURL:(NSURL *) url {
	if (!webView) {
		id old = _urlToLoad;
		_urlToLoad = [url retain];
		[old release];
		return;
	}

	if (!url) return;

	locationField.text = url.absoluteString;

	[webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) goBack:(id) sender {
	[webView goBack];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
}

- (void) goForward:(id) sender {
	[webView goForward];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
}

- (void) reloadOrStop:(id) sender {
	if (webView.loading)
		[webView stopLoading];
	else [webView reload];
}

- (NSURL *) url {
	NSURL *url = [NSURL URLWithString:locationField.text];
	if (!url.scheme.length && locationField.text.length) url = [NSURL URLWithString:[@"http://" stringByAppendingString:locationField.text]];
	return url;
}

#pragma mark -

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	NSURL *url = [NSURL URLWithString:locationField.text];
	if (!url.scheme.length) url = [NSURL URLWithString:[@"http://" stringByAppendingString:locationField.text]];

	[self loadURL:url];

	[locationField resignFirstResponder];

	return YES;
}

#pragma mark -

- (void) updateLocationField {
	NSString *location = webView.request.URL.absoluteString;
	if (location.length)
		locationField.text = webView.request.URL.absoluteString;
}

- (void) updateLoadingStatus {
	UIImage *image = nil;
	if (webView.loading) {
		image = [UIImage imageNamed:@"browserStop.png"];

		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
		image = [UIImage imageNamed:@"browserReload.png"];

		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}

	[stopReloadButton setImage:image forState:UIControlStateNormal];

	// update status of back/forward buttons
	backButton.enabled = [webView canGoBack];
	backButton.alpha = [webView canGoBack] ? 1.0f : 0.5f;
	forwardButton.enabled = [webView canGoForward];
	forwardButton.alpha = [webView canGoForward] ? 1.0f : 0.5f;
	backButton.showsTouchWhenHighlighted = [webView canGoBack];
	forwardButton.showsTouchWhenHighlighted = [webView canGoForward];	
}

#pragma mark -

- (BOOL) webView:(UIWebView *) sender shouldStartLoadWithRequest:(NSURLRequest *) request navigationType:(UIWebViewNavigationType) navigationType {
	if ((navigationType == UIWebViewNavigationTypeLinkClicked) ||
		(navigationType == UIWebViewNavigationTypeFormSubmitted)) {
		NSURL *url = request.URL;
		NSString *urlString = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		URL_TYPE urlType = [Utilities getURLType:urlString];

		if (urlType == URL_TYPE_DOWNLOAD_TORRENT) {
			_urlToHandle = [url retain];

			// open a dialog with two custom buttons
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:urlString
																	 delegate:self
															cancelButtonTitle:nil
													   destructiveButtonTitle:nil
															otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
			
			downloadButtonIndex = [actionSheet addButtonWithTitle:@"Download"];
			copyButtonIndex = [actionSheet addButtonWithTitle:@"Copy"];
			openLinkButtonIndex = [actionSheet addButtonWithTitle:@"Open"];
			actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
			
			[actionSheet showInView:self.parentViewController.tabBarController.view]; // show from our table view (pops up in the middle of the table)
			[actionSheet release];
			return NO;
		}
	}

	return YES;
}

- (void) webViewDidStartLoad:(UIWebView *) sender {
	[self updateLoadingStatus];
}

- (void) webViewDidFinishLoad:(UIWebView *) sender {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
	[self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
}

- (void) webView:(UIWebView *) sender didFailLoadWithError:(NSError *) error {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
	[self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLoadingStatus) object:nil];
	[self performSelector:@selector(updateLoadingStatus) withObject:nil afterDelay:1.];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (copyButtonIndex == buttonIndex) {
		NSURL *url = _urlToHandle;
		NSString *urlString = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];

		[pasteBoard setValue:urlString forPasteboardType:@"public.utf8-plain-text"];
	} else if (downloadButtonIndex == buttonIndex) {
		URL_TYPE urlType = [Utilities getURLType:[_urlToHandle.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		if (urlType == URL_TYPE_DOWNLOAD_TORRENT) {
			[tnm addTorrent:[_urlToHandle.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[_urlToHandle release];
			_urlToHandle = nil;
		}
	} else if (openLinkButtonIndex == buttonIndex) {
		[self loadURL:_urlToHandle];
		[_urlToHandle release];
		_urlToHandle = nil;
	}
}

@end
