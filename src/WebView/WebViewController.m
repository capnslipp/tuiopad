//
//  WebViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 12.07.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController () 

@end

@implementation WebViewController
@synthesize webView;
@synthesize URL;
@synthesize rotationAllowed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {

}

- (void) viewWillDisappear:(BOOL)animated {
    UIView* mainView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    [mainView setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:self.view belowSubview:mainView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (rotationAllowed) return YES;
    else return (interfaceOrientation == UIDeviceOrientationPortrait);
}

#pragma mark - url request handling

-(void)setURL:(NSString *)host withPort:(NSString *)port {
    if (!host || host.length == 0) return;
    if (host.length > 7)
        if (![[host substringToIndex:7] isEqualToString:@"http://"])
            host = [NSString stringWithFormat:@"http://%@", host];
    if(port && port !=@"") {
        if (URL) [URL release];
        URL = [[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@",host,port]] retain];
    }
    else {
        if (URL) [URL release];
        URL = [[NSURL URLWithString:host] retain];
    }
}

- (void) loadURL {
    if (URL) 
        [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark - webview delegate methods

-(void) webViewDidStartLoad:(UIWebView *)webView {
    /// ACTIVITY INDICATOR SHOULD APPEAR
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    /// ACTIVITY INDICATOR SHOULD DISAPPEAR
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)dealloc {
    if (URL) [URL release];
    [webView release];
    [super dealloc];
}
@end
