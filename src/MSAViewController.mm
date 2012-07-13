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

#import "MSAViewController.h"
#import <QuartzCore/CoreAnimation.h>

#import "MSATuioSenderCPP.h"
#import "MSASettings.h"

#import "AdvancedSettingsViewController.h"
#import "WebViewController.h"

#include "ofxiPhoneExtras.h"


@implementation MSAViewController

@synthesize settings;
@synthesize tuioSender;
@synthesize isOn;
@synthesize deviceOrientation;
@synthesize webViewController;
@synthesize isUsingWebView;


#pragma mark ----- Utility -----

-(void)connect {
	NSLog(@"MSAViewController::connect %@ %@ %i", hostTextField.text, portTextField.text, packetSwitch.selectedSegmentIndex);
    bool cProfile = [settings getInt:kSetting_EnableCursorProfile];
    bool oProfile = [settings getInt:kSetting_EnableObjectProfile];
	tuioSender->setup([hostTextField.text UTF8String], [portTextField.text intValue], packetSwitch.selectedSegmentIndex, [[settings getIpAddress] UTF8String],  oProfile, cProfile);
	
	if(periodicUpdatesSwitch.on) tuioSender->tuioServer->enablePeriodicMessages();
	else tuioSender->tuioServer->disablePeriodicMessages();
	
	if(fullUpdatesSwitch.on) tuioSender->tuioServer->enableFullUpdate();
	else tuioSender->tuioServer->disableFullUpdate();


}

-(void)disconnect {
	tuioSender->close();
}


#pragma mark ----- Control events -----

-(IBAction) orientControlChanged:(id)sender {
		
	switch(orientControl.selectedSegmentIndex) {
		case 0:	
			deviceOrientation = [[UIDevice currentDevice] orientation];
			[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
			break;
			
		case 1:
			deviceOrientation = UIDeviceOrientationLandscapeRight;
			[[NSNotificationCenter defaultCenter] removeObserver:self];
			break;
			
		case 2:
			deviceOrientation = UIDeviceOrientationPortrait;
			[[NSNotificationCenter defaultCenter] removeObserver:self];
			break;
	}
}


-(IBAction) textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


-(IBAction) backgroundPressed:(id)sender {
	[hostTextField resignFirstResponder];
	[portTextField resignFirstResponder];
}


-(IBAction) connectPressed:(id)sender {
	
	if (!network) return;
	
	[settings setInt:packetSwitch.selectedSegmentIndex forKey:kSetting_Packet];
	if (packetSwitch.selectedSegmentIndex<2) [settings setString:hostTextField.text forKey:kSetting_HostIP];
	[settings setInt:[portTextField.text intValue] forKey:kSetting_Port];
	[settings setInt:orientControl.selectedSegmentIndex forKey:kSetting_Orientation];
	[settings setInt:periodicUpdatesSwitch.on forKey:kSetting_PeriodicUpdates];
	[settings setInt:fullUpdatesSwitch.on forKey:kSetting_FullUpdates];
	[settings saveSettings];
	
	[self close];
	[self connect];
	
}


-(IBAction) packetSelected:(id)sender {
	if (packetSwitch.selectedSegmentIndex==2) {
		NSLog(@"MSAViewController::set %@", hostTextField.text);
		[settings setString:hostTextField.text forKey:kSetting_HostIP];
		hostTextField.text = @"incoming connection";
		hostTextField.textColor = [UIColor grayColor];
		//hostLabel.text = @"server";
		hostTextField.enabled = NO;
		hostButton.enabled = NO;
	} else {
		hostTextField.text = [settings getString:kSetting_HostIP];
		hostTextField.enabled = YES;
		hostButton.enabled = YES;
		hostTextField.textColor = [UIColor blackColor];
		//hostLabel.text = @"client";
	}
}

- (IBAction)moreButtonClicked:(id)sender {
    AdvancedSettingsViewController *advancedVC = [[AdvancedSettingsViewController alloc] initWithNibName:@"AdvancedSettingsViewController" bundle:nil];
    advancedVC.settings = self.settings;
    [self.navigationController pushViewController:advancedVC animated:YES];
    [advancedVC release];
}



-(IBAction) detectHostPressed:(id)sender {
	if (packetSwitch.selectedSegmentIndex<2)
		hostTextField.text = [settings getDefaultFor:kSetting_HostIP];
}


-(IBAction) defaultPortPressed:(id)sender {
	packetSwitch.selectedSegmentIndex = 0;
	portTextField.text = [NSString stringWithFormat:@"%i", [[settings getDefaultFor:kSetting_Port] intValue]];
}



#pragma mark ----- Open & close -----

#define ANIMATION_TIME		0.5f
#define ANIMATION_CURVE		UIViewAnimationCurveEaseIn

-(void)open:(bool)animate {
    self.navigationController.navigationBarHidden = YES;

	NSLog(@"MSAViewController::open %i", animate);
		
	if(self.view.superview == nil) {
		if(animate) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:ANIMATION_TIME];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
			[UIView setAnimationCurve: ANIMATION_CURVE];
			[self viewWillAppear:YES];
			[[[UIApplication sharedApplication] keyWindow] addSubview:self.navigationController.view];
			[self viewDidAppear:YES];
			[UIView commitAnimations];
		} 
        else {
			[[[UIApplication sharedApplication] keyWindow] addSubview:self.navigationController.view];
		}
		
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.navigationController.view];
    if (self.webViewController) {
        self.webViewController.rotationAllowed = NO;
//        [self.webViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];    
    }

	// suspend update loop while UI is visible
	isOn = true;
	[self disconnect];
	ofSetFrameRate(1);			
}


-(void) close {
	NSLog(@"MSAViewController::close");
    
    if ([settings getInt:kSetting_EnableVNCOVERHTML5]) {
        ofBackground(0, 0, 0);
        float *bgptr = ofBgColorPtr();
        bgptr[3] = 0.0f;       // there is no method to set the alpha channel of this member
        ofSetBackgroundAuto(true);
        ofxiPhoneSetGLViewTransparent(true);
        isUsingWebView = true;

        
        if (!self.webViewController) {
            [self setEnableWebView:YES];
        }
        if ([[[[UIApplication sharedApplication] keyWindow] subviews] count] == 2) {
            UIView* mainView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
            [mainView setBackgroundColor:[UIColor clearColor]];
            [[[UIApplication sharedApplication] keyWindow] insertSubview:self.webViewController.view belowSubview:mainView];
            [self configureWebView];
            [self.webViewController.view setFrame:mainView.frame];
        }
        self.webViewController.rotationAllowed = YES; 
    }
    
    else {
        ofBackground(255, 255, 255);
        ofxiPhoneSetGLViewTransparent(false);
        isUsingWebView = false;
        float *bgptr = ofBgColorPtr();
        bgptr[3] = 1.0f; 
        
        // remove webview if it's inside the keywindow subviews
        if ([[[[UIApplication sharedApplication] keyWindow] subviews] count] == 3) {
            UIView *bottomView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
            [bottomView removeFromSuperview];
        }
    }

	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATION_TIME];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
	[UIView setAnimationCurve: ANIMATION_CURVE];
	[self viewWillDisappear:YES];
	[self.navigationController.view removeFromSuperview];
	[self viewDidDisappear:YES];
	[UIView commitAnimations];
	

	ofSetFrameRate(60);			// restore update loop	
	isOn = false;
}

-(IBAction) exitPressed:(id)sender {
	
	[settings setInt:packetSwitch.selectedSegmentIndex forKey:kSetting_Packet];
	if (packetSwitch.selectedSegmentIndex<2) [settings setString:hostTextField.text forKey:kSetting_HostIP];
	[settings setInt:[portTextField.text intValue] forKey:kSetting_Port];
	[settings setInt:orientControl.selectedSegmentIndex forKey:kSetting_Orientation];
	[settings setInt:periodicUpdatesSwitch.on forKey:kSetting_PeriodicUpdates];
	[settings setInt:fullUpdatesSwitch.on forKey:kSetting_FullUpdates];
	[settings saveSettings];
	
	exit(0);
}


#pragma mark ----- Default events -----

-(void)viewDidLoad {
	NSLog(@"MSAViewController::viewDidLoad");
	[super viewDidLoad];
	
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	
	tuioSender = new MSATuioSenderCPP();
	
	NSString *HostIP = [settings getString:kSetting_HostIP];
	packetSwitch.selectedSegmentIndex		= [settings getInt:kSetting_Packet];
	if (packetSwitch.selectedSegmentIndex<2)
		hostTextField.text					= [settings getString:kSetting_HostIP];	
	else {
		hostTextField.text = @"incoming connection";
		hostTextField.textColor = [UIColor grayColor];
		hostTextField.enabled = NO;
		hostButton.enabled = NO;
	}
	[settings setString:HostIP forKey:kSetting_HostIP];
	portTextField.text						= [NSString stringWithFormat:@"%i", [settings getInt:kSetting_Port]];
	orientControl.selectedSegmentIndex		= [settings getInt:kSetting_Orientation];
	periodicUpdatesSwitch.on				= [settings getInt:kSetting_PeriodicUpdates];
	fullUpdatesSwitch.on					= [settings getInt:kSetting_FullUpdates];
//    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:navController.view];
	
//	[self.navigationController pushViewController:self animated:YES];
    
	
	[self orientControlChanged:nil];
	
	network = [settings connectedToNetwork];
	if (network) {
		NSString *address = [settings getIpAddress];
		
		NSString *status = [NSString stringWithFormat:@"current network address is %@", address];
		statusLabel.textColor = [UIColor whiteColor];
		statusLabel.text = status;
		[startButton setEnabled: YES];
		NSLog(@"MSAViewController: %@", status);
	} else {
		statusLabel.textColor = [UIColor redColor];
		statusLabel.text = @"no active network connection available!";
		[startButton setEnabled: NO];
		//NSLog(@"MSAViewController: no active network connection available!");
	}
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void) didRotate:(NSNotification *)notification {	
	int o = [[UIDevice currentDevice] orientation];
	if(o != UIDeviceOrientationUnknown && o != UIDeviceOrientationFaceUp && o != UIDeviceOrientationFaceDown) {
		deviceOrientation = o;
	} else if([settings getInt:kSetting_Orientation] == 0) {
		deviceOrientation = UIDeviceOrientationLandscapeRight;
	}
}

#pragma mark - AdvancedSettings delegate methods

- (void) setEnableWebView:(BOOL)enable {
    if (enable) {
        if (self.webViewController) return;
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }
    else {
        if (self.webViewController != nil) {
            [self.webViewController release];
            self.webViewController = nil;
        }
    }
}

- (void) configureWebView {
    [self.webViewController setURL:[settings getString:kSetting_VNC_IP] withPort:[settings getString:kSetting_VNC_PORT]];
    [self.webViewController loadURL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	delete tuioSender;
    [moreButton release];
    [super dealloc];
}


- (void)viewDidUnload {
    [moreButton release];
    moreButton = nil;
    [super viewDidUnload];
}
@end
