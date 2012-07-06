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

@interface AdvancedSettingsViewController ()

@end

@implementation AdvancedSettingsViewController
@synthesize learnButton;
@synthesize showObjectsButton;
@synthesize cursorProfileSwitch;
@synthesize objectProfileSwitch;
@synthesize VNCSwitch;
@synthesize VNCIPTextfield;
@synthesize settings;

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
    
	if (VNCSwitch.on ) {
        VNCIPTextfield.text					= [settings getString:kSetting_VNC_IP];	
        [VNCIPTextfield setEnabled:YES];
    }
	else {
        [VNCIPTextfield setEnabled:NO];
	}
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
    [super dealloc];
}
- (IBAction)learnButtonPressed:(id)sender {
    LearnViewController *learnVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        learnVC = [[LearnViewController alloc] initWithNibName:@"LearnViewPhone" bundle:nil];
    }
    else learnVC = [[LearnViewController alloc] initWithNibName:@"LearnViewPad" bundle:nil];
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    [self.navigationController pushViewController:learnVC animated:YES];
    [learnVC release];
}

- (IBAction)showObjectsButtonPressed:(id)sender {
    ExistingObjectsViewController *existingVC = [[ExistingObjectsViewController alloc] initWithNibName:@"ExistingObjectsViewController" bundle:nil];
    [self.navigationController pushViewController:existingVC animated:YES];
    [existingVC release];
}
@end
