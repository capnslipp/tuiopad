/*
 TuioPad http://www.tuio.org/
 An Open Source TUIO App for iOS based on OpenFrameworks
 (c) 2010 by Mehmet Akten <memo@memo.tv> and Martin Kaltenbrunner <modin@yuri.at>
 
 TuioPad is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TuioPad is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TuioPad.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

#import <UIKit/UIKit.h>

#import "AdvancedSettingsViewController.h"

class MSATuioSenderCPP;
@class MSASettings;
@class WebViewController;


@interface MSAViewController : UIViewController <UINavigationControllerDelegate, AdvancedSettingsDelegate> {
	IBOutlet UITextField		*hostTextField;
	IBOutlet UITextField		*portTextField;
	IBOutlet UISegmentedControl	*orientControl;
	IBOutlet UISwitch			*periodicUpdatesSwitch;
	IBOutlet UISwitch			*fullUpdatesSwitch;
	IBOutlet UILabel			*statusLabel;
	IBOutlet UILabel			*hostLabel;
	IBOutlet UIButton			*startButton;
	IBOutlet UIButton			*hostButton;
	IBOutlet UISegmentedControl	*packetSwitch;
    IBOutlet UIButton *moreButton;

	
	IBOutlet MSASettings		*settings;
	
	MSATuioSenderCPP			*tuioSender;

	bool						isOn;
	bool						network;
	int							deviceOrientation;
}

@property (readonly, nonatomic)		MSATuioSenderCPP	*tuioSender;
@property (readonly, nonatomic)		MSASettings			*settings;
@property (readonly, nonatomic)		bool				isOn;
@property (readonly, nonatomic)		int					deviceOrientation;

@property (nonatomic, retain) WebViewController* webViewController;
@property (readonly, nonatomic) bool isUsingWebView;


-(void) open:(bool)animate;
-(IBAction) close;

-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) detectHostPressed:(id)sender;
-(IBAction) defaultPortPressed:(id)sender;
-(IBAction) orientControlChanged:(id)sender;
-(IBAction) backgroundPressed:(id)sender;
-(IBAction) connectPressed:(id)sender;
-(IBAction) exitPressed:(id)sender;
-(IBAction) packetSelected:(id)sender;
- (IBAction)moreButtonClicked:(id)sender;

-(void) connect;
-(void) disconnect;

@end
