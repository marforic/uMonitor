//
//  BrowserViewController.h
//  QGet-Remote
//
//  Created by Sylver Bruneau on 15/05/10.
//  Copyright 2010 Sylver Bruneau. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "uTorrentViewAppDelegate.h"
#import "TorrentNetworkManager.h"

@protocol BrowserViewControllerDelegate;

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
	@protected
	UIButton *backButton;
	UIButton *forwardButton;
	UIButton *stopReloadButton;
	UIBarButtonItem *doneButtonItem;
	UITextField *locationField;
	UIWebView *webView;
	UINavigationBar *navigationBar;
	NSURL *_urlToLoad;
	NSURL *_urlToHandle;
	
	TorrentNetworkManager * tnm;
	
	NSInteger downloadButtonIndex;
	NSInteger copyButtonIndex;
	NSInteger openLinkButtonIndex;
}

@property (nonatomic, retain, setter=loadURL:) NSURL *url;

- (void) loadLastURL;
- (void) loadURL:(NSURL *) url;
- (void) updateLoadingStatus;

- (void) goBack:(id) sender;
- (void) goForward:(id) sender;
- (void) reloadOrStop:(id) sender;

@end
