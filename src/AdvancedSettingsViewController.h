//
//  AdvancedSettingsViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSASettings.h"

@class WebViewController;

@protocol AdvancedSettingsDelegate <NSObject>

- (void) setEnableWebView: (BOOL) enable;
- (void) configureWebView;

@end

@interface AdvancedSettingsViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>
{
    NSArray *sections;
    NSDictionary *rows;
    id <AdvancedSettingsDelegate> delegate;
}
@property (retain, nonatomic) IBOutlet UIButton *learnButton;
@property (retain, nonatomic) IBOutlet UIButton *showObjectsButton;
@property (retain, nonatomic) IBOutlet UISwitch *cursorProfileSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *objectProfileSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *VNCSwitch;
@property (retain, nonatomic) IBOutlet UITextField *VNCIPTextfield;
@property (retain, nonatomic) IBOutlet UILabel *ipLabel;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property (retain, nonatomic) IBOutlet UITextField *portTextfield;

@property (retain, nonatomic) IBOutlet UIButton *openWebViewButton;
@property (retain, nonatomic) IBOutlet UILabel *webViewlabel;
@property (retain, nonatomic) IBOutlet UIButton *autoButton;

- (IBAction)autoButtonPressed:(id)sender;
- (IBAction)openWebViewPressed:(id)sender;

@property (assign, nonatomic) MSASettings *settings;

- (IBAction)learnButtonPressed:(id)sender;
- (IBAction)showObjectsButtonPressed:(id)sender;
- (IBAction)vncSwitchChanged:(id)sender;

@end
