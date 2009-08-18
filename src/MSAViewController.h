//
//  MSAViewController.h
//  Meshmerizer
//
//  Created by Mehmet Akten on 10/02/2009.
//  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

class MSATuioSenderCPP;
@class MSASettings;


@interface MSAViewController : UIViewController {
	IBOutlet UITextField		*hostTextField;
	IBOutlet UITextField		*portTextField;
	IBOutlet UISegmentedControl	*orientControl;
	IBOutlet UISegmentedControl *verbosityControl;
	
	IBOutlet MSASettings		*settings;
	
	MSATuioSenderCPP			*tuioSender;

	bool						_isOn;
}

@property (readonly, nonatomic)		MSATuioSenderCPP	*tuioSender;
@property (readonly, nonatomic)		MSASettings			*settings;


-(bool) isOn;
-(void) open:(bool)animate;
-(IBAction) close;

-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) detectHostPressed:(id)sender;
-(IBAction) defaultPortPressed:(id)sender;
-(IBAction) orientControlChanged:(id)sender;
-(IBAction) verbosityControlChanged:(id)sender;
-(IBAction) backgroundPressed:(id)sender;
-(IBAction) connectPressed:(id)sender;


@end
