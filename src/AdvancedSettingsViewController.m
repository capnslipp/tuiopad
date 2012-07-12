//
//  AdvancedSettingsViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import "AdvancedSettingsViewController.h"
#import "LearnViewController.h"
#import "ExistingObjectsViewController.h"
#import "WebViewController.h"
#import "MSAViewController.h"

@interface AdvancedSettingsViewController ()
- (void) refreshVNCControls: (BOOL)enabled;
- (void) configureWebView: (BOOL) enabled;
- (void) animateViewUp;
- (void) animateViewDown;
@end

@implementation AdvancedSettingsViewController
@synthesize learnButton;
@synthesize showObjectsButton;
@synthesize cursorProfileSwitch;
@synthesize objectProfileSwitch;
@synthesize VNCSwitch;
@synthesize VNCIPTextfield;
@synthesize ipLabel;
@synthesize openWebViewButton;
@synthesize settings;
@synthesize webViewlabel;
@synthesize autoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Advanced Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // for tableview
//	NSArray *arr = [NSArray arrayWithObjects:@"Cursor Profile", @"Object Profile", @"VNC Settings", nil];
//    sections = arr;
//    
//    NSArray *cursorRows = [NSArray arrayWithObjects:@"Enabled", nil];
//    NSArray *objectRows = [NSArray arrayWithObjects:@"Enabled", @"Learning Mode", nil];
//    NSArray *vncRows = [NSArray arrayWithObjects:@"Enabled", @"IP: ", nil];
//    NSArray *allRows = [NSArray arrayWithObjects:cursorRows, objectRows, vncRows, nil];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjects:allRows forKeys:sections];
//    rows = dict;
    
    NSString *HostIP = [settings getString:kSetting_HostIP];
	cursorProfileSwitch.on		= [settings getInt:kSetting_EnableCursorProfile];
    objectProfileSwitch.on		= [settings getInt:kSetting_EnableObjectProfile];
    VNCSwitch.on                = [settings getInt:kSetting_EnableVNCOVERHTML5];
    
    [self refreshVNCControls:VNCSwitch.on];
	if (VNCSwitch.on ) {
        VNCIPTextfield.text					= [settings getString:kSetting_VNC_IP];	
    }
	else {
	}
    
    MSAViewController *msaVC;
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MSAViewController class]])
        msaVC = [self.navigationController.viewControllers objectAtIndex:0];
    if (msaVC) delegate = msaVC;
    
    [delegate setEnableWebView:VNCSwitch.on];
    
	[settings setString:HostIP forKey:kSetting_HostIP];
    

}

- (void) viewWillDisappear:(BOOL)animated {
    [settings setInt:cursorProfileSwitch.on forKey:kSetting_EnableCursorProfile];
    [settings setInt:objectProfileSwitch.on forKey:kSetting_EnableObjectProfile];
    [settings setInt:VNCSwitch.on forKey:kSetting_EnableVNCOVERHTML5];
    if ([VNCIPTextfield isEnabled] && VNCIPTextfield.text != nil) [settings setString:VNCIPTextfield.text forKey:kSetting_VNC_IP];

	[settings saveSettings];
}

- (void)viewDidUnload
{
    [self setLearnButton:nil];
    [self setShowObjectsButton:nil];
    [self setCursorProfileSwitch:nil];
    [self setObjectProfileSwitch:nil];
    [self setVNCSwitch:nil];
    [self setVNCIPTextfield:nil];
    [self setOpenWebViewButton:nil];
    [self setIpLabel:nil];
    [self setWebViewlabel:nil];
    [self setAutoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [learnButton release];
    [showObjectsButton release];
    [cursorProfileSwitch release];
    [objectProfileSwitch release];
    [VNCSwitch release];
    [VNCIPTextfield release];
    [openWebViewButton release];
    [ipLabel release];
    [webViewlabel release];
    [autoButton release];
    [super dealloc];
}

#pragma mark - IBACTIONS

- (IBAction)learnButtonPressed:(id)sender {
    LearnViewController *learnVC;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        learnVC = [[LearnViewController alloc] initWithNibName:@"LearnViewPhone" bundle:nil];
//    }
//    else learnVC = [[LearnViewController alloc] initWithNibName:@"LearnViewPad" bundle:nil];
    
    learnVC = [[LearnViewController alloc] initWithNibName:@"LearnViewPhone" bundle:nil];
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    [self.navigationController pushViewController:learnVC animated:YES];
    [learnVC release];
}

- (IBAction)showObjectsButtonPressed:(id)sender {
    ExistingObjectsViewController *existingVC = [[ExistingObjectsViewController alloc] initWithNibName:@"ExistingObjectsViewController" bundle:nil];
    [self.navigationController pushViewController:existingVC animated:YES];
    [existingVC release];
}

- (IBAction)vncSwitchChanged:(id)sender {
    [self refreshVNCControls:VNCSwitch.on];
    [delegate setEnableWebView:VNCSwitch.on];
    [delegate configureWebView];

//    [self configureWebView:VNCSwitch.on];
}
- (IBAction)autoButtonPressed:(id)sender {
    [self.VNCIPTextfield setText:[settings getString:kSetting_HostIP]];
    [settings setString:[settings getString:kSetting_HostIP] forKey:kSetting_VNC_IP];
}

- (IBAction)openWebViewPressed:(id)sender {
    MSAViewController *msaVC;
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MSAViewController class]])
        msaVC = [self.navigationController.viewControllers objectAtIndex:0];
    
    if ([[[[UIApplication sharedApplication] keyWindow] subviews] count] == 3) {
        UIView *bottomView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
        [bottomView removeFromSuperview];
    }
    
    [self.navigationController pushViewController:msaVC.webViewController animated:YES];
    [delegate configureWebView];
}

#pragma mark - other stuff

- (void) refreshVNCControls: (BOOL) enabled{
    self.ipLabel.hidden = !enabled;
    self.openWebViewButton.hidden = !enabled;
    self.VNCIPTextfield.hidden = !enabled;
    self.webViewlabel.hidden = !enabled;
}

- (void) configureWebView:(BOOL)enabled {
//    MSAViewController *msaVC;
//    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MSAViewController class]])
//        msaVC = [self.navigationController.viewControllers objectAtIndex:0];
}

#pragma mark - textfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{ 
    [textField resignFirstResponder]; 
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {     
    [self animateViewUp];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self animateViewDown];
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) 
        [settings setString:textField.text forKey:kSetting_VNC_IP];
}

#pragma mark - view animation

- (void) animateViewUp {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = newFrame.origin.y - 100.0;
        self.view.frame = newFrame;
    }
                     completion:^(BOOL){
                         
                     }];
}

- (void) animateViewDown {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = newFrame.origin.y + 100.0;
        self.view.frame = newFrame;
    }
                     completion:^(BOOL){
                         
                     }];
}
@end