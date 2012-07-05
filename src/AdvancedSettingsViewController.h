//
//  AdvancedSettingsViewController.h
//  TuioPad
//
//  Created by Oleg Langer on 29.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSASettings.h"

@interface AdvancedSettingsViewController : UIViewController <UINavigationControllerDelegate>
{
    NSArray *sections;
    NSDictionary *rows;
}
@property (retain, nonatomic) IBOutlet UIButton *learnButton;
@property (retain, nonatomic) IBOutlet UIButton *showObjectsButton;
@property (retain, nonatomic) IBOutlet UISwitch *cursorProfileSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *objectProfileSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *VNCSwitch;
@property (retain, nonatomic) IBOutlet UITextField *VNCIPTextfield;

@property (readonly, nonatomic) IBOutlet MSASettings *settings;

- (IBAction)learnButtonPressed:(id)sender;
- (IBAction)showObjectsButtonPressed:(id)sender;

@end
