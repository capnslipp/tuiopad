//
//  MSAViewController.m
//  Meshmerizer
//
//  Created by Mehmet Akten on 10/02/2009.
//  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
//


#import "MSAViewController.h"
#import <QuartzCore/CoreAnimation.h>

#import "MSATuioSenderCPP.h"
#import "MSASettings.h"


@implementation MSAViewController

@synthesize settings;
@synthesize tuioSender;



#pragma mark ----- Utility -----

-(void)connect {
	NSLog(@"MSAViewController::connect %@ %@", hostTextField.text, portTextField.text);
	tuioSender->setup([hostTextField.text UTF8String], [portTextField.text intValue]);
}

-(bool) isOn {
	return _isOn;
}



#pragma mark ----- Control events -----

-(IBAction) orientControlChanged:(id)sender {
	[settings setInt:orientControl.selectedSegmentIndex forKey:kSetting_Orientation];
	
	switch(orientControl.selectedSegmentIndex) {
		case 0:	
			[settings setInt:[[UIDevice currentDevice] orientation] forKey:kSetting_Orientation];
			[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
			break;
			
		case 1:
			[settings setInt:UIDeviceOrientationLandscapeRight forKey:kSetting_Orientation];
			[[NSNotificationCenter defaultCenter] removeObserver:self];
			break;
			
		case 2:
			[settings setInt:UIDeviceOrientationPortrait forKey:kSetting_Orientation];
			[[NSNotificationCenter defaultCenter] removeObserver:self];
			break;
	}
}


-(IBAction) verbosityControlChanged:(id)sender {
}



-(IBAction) textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


-(IBAction) backgroundPressed:(id)sender {
	[hostTextField resignFirstResponder];
	[portTextField resignFirstResponder];
}


-(IBAction) connectPressed:(id)sender {
	[settings setString:hostTextField.text forKey:kSetting_HostIP];
	[settings setInt:[portTextField.text intValue] forKey:kSetting_Port];
	[self connect];
	[self close];
}



-(IBAction) detectHostPressed:(id)sender {
	hostTextField.text = [settings getDefaultFor:kSetting_HostIP];
//	[self connect];
}


-(IBAction) defaultPortPressed:(id)sender {
	portTextField.text = [NSString stringWithFormat:@"%i", [[settings getDefaultFor:kSetting_Port] intValue]];
//	[self connect];
}



#pragma mark ----- Open & close -----

#define ANIMATION_TIME		0.5f
#define ANIMATION_CURVE		UIViewAnimationCurveEaseIn

-(void)open:(bool)animate {
	NSLog(@"MSAViewController::open %i", animate);
	
	if(self.view.superview == nil) {
		if(animate) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:ANIMATION_TIME];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
			[UIView setAnimationCurve: ANIMATION_CURVE];
			[self viewWillAppear:YES];
			[[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
			[self viewDidAppear:YES];
			[UIView commitAnimations];
		} else {
			[[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
		}
		
		ofSetFrameRate(0);		// suspend update loop while UI is visible
	}
	
	_isOn = true;
}


-(void) close {
	NSLog(@"MSAViewController::close");
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATION_TIME];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[UIApplication sharedApplication] keyWindow] cache:YES];
	[UIView setAnimationCurve: ANIMATION_CURVE];
	[self viewWillDisappear:YES];
	[self.view removeFromSuperview];
	[self viewDidDisappear:YES];
	[UIView commitAnimations];
	
	ofSetFrameRate(60);			// restore update loop
	
	_isOn = false;
}


#pragma mark ----- Default events -----

-(void)viewDidLoad {
	NSLog(@"MSAViewController::viewDidLoad");
	[super viewDidLoad];
	
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	tuioSender = new MSATuioSenderCPP();
	
	hostTextField.text						= [settings getString:kSetting_HostIP];
	portTextField.text						= [NSString stringWithFormat:@"%i", [settings getInt:kSetting_Port]];
	orientControl.selectedSegmentIndex		= [settings getInt:kSetting_Orientation];
	verbosityControl.selectedSegmentIndex	= [settings getInt:kSetting_Verbosity];
	
	[self orientControlChanged:nil];
	[self verbosityControlChanged:nil];
	
	[self connect];
}

- (void) didRotate:(NSNotification *)notification {	
	int o = [[UIDevice currentDevice] orientation];
	if(o != UIDeviceOrientationUnknown && o != UIDeviceOrientationFaceUp && o != UIDeviceOrientationFaceDown) {
		[settings setInt:o forKey:kSetting_Orientation];
//		printf("orientation: %i\n", o);
	} else if([settings getInt:kSetting_Orientation] == 0) {
		[settings setInt:UIDeviceOrientationLandscapeLeft forKey:kSetting_Orientation];
	}
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	delete tuioSender;
    [super dealloc];
}


@end
