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
	IBOutlet UISwitch			*periodicUpdatesSwitch;
	IBOutlet UISwitch			*fullUpdatesSwitch;
	
	IBOutlet MSASettings		*settings;
	
	MSATuioSenderCPP			*tuioSender;

	bool						isOn;
	int							deviceOrientation;
}

@property (readonly, nonatomic)		MSATuioSenderCPP	*tuioSender;
@property (readonly, nonatomic)		MSASettings			*settings;
@property (readonly, nonatomic)		bool				isOn;
@property (readonly, nonatomic)		int					deviceOrientation;


-(void) open:(bool)animate;
-(IBAction) close;

-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) detectHostPressed:(id)sender;
-(IBAction) defaultPortPressed:(id)sender;
-(IBAction) orientControlChanged:(id)sender;
-(IBAction) backgroundPressed:(id)sender;
-(IBAction) connectPressed:(id)sender;


@end
