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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated {
    UIView* mainView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    [mainView setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:self.view belowSubview:mainView];
}

-(void)setURL:(NSString *)host withPort:(NSString *)port
{
    if (!host || host.length == 0) return;
    if (![[host substringToIndex:7] isEqualToString:@"http://"])
        host = [NSString stringWithFormat:@"http://%@", host];
    if(port && port !=@"")
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@",host,port]];
    else
        URL = [NSURL URLWithString:host];
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
    NSLog(@"%@", [error localizedDescription]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    [URL release];
    [webView release];
    [super dealloc];
}
@end
