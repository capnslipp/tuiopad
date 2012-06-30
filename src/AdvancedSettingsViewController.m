//
//  AdvancedSettingsViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import "AdvancedSettingsViewController.h"
#import "LearnViewController.h"
#import "ExistingObjectsViewController.h"

@interface AdvancedSettingsViewController ()

@end

@implementation AdvancedSettingsViewController
@synthesize learnButton;
@synthesize showObjectsButton;

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
    
    
}

- (void)viewDidUnload
{
    [self setLearnButton:nil];
    [self setShowObjectsButton:nil];
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
}

- (IBAction)showObjectsButtonPressed:(id)sender {
    ExistingObjectsViewController *existingVC = [[ExistingObjectsViewController alloc] initWithNibName:@"ExistingObjectsViewController" bundle:nil];
    [self.navigationController pushViewController:existingVC animated:YES];
}
@end
