//
//  WebViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 12.07.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSURL* URL;

-(void)setURL:(NSString *)host withPort:(NSString *)port;
- (void) loadURL;


@end
