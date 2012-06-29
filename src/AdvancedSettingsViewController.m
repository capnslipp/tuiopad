//
//  AdvancedSettingsViewController.m
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import "AdvancedSettingsViewController.h"

@interface AdvancedSettingsViewController ()

@end

@implementation AdvancedSettingsViewController

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
