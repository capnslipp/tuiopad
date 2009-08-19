

#include "testApp.h"

#include "ofxAccelerometer.h"
#include "ofxiPhone.h"

#include "MSAViewController.h"
#include "MSAFingerDrawerCPP.h"
#include "MSATuioSenderCPP.h"
#include "MSASettings.h"

#pragma mark Variables

MSAViewController	*viewController;

ofImage				imageUp;
MSAFingerDrawerCPP	fingerDrawer[OF_MAX_TOUCHES];
ofPoint				rotatedTouchPosition;
ofPoint				restAccel;



#pragma mark App Loop Callbacks

void testApp::setup() {
	ofSetFrameRate(60);
	ofBackground(255, 255, 255);
	ofSetBackgroundAuto(true);
	
	ofxAccelerometer.setup();
	ofxMultiTouch.addListener(this);
	
	imageUp.loadImage("ThisWayUp.jpg");
	
	viewController	= [[MSAViewController alloc] initWithNibName:@"ui" bundle:nil];	
	
	// open UI, not animated
	[viewController open:false];
}


void testApp::update() {

	// if device is shaken hard, open UI, animated
	ofPoint &acc = ofxAccelerometer.getForce();
//	float f = acc.x*acc.x + acc.y*acc.y + acc.z*acc.z;
//	printf("%f\n", f);
	if(acc.x*acc.x + acc.y*acc.y + acc.z*acc.z > 4) [viewController open:true];
		
		
	[viewController tuioSender]->update();
}


void testApp::draw() {
	glPushMatrix();
	glTranslatef(ofGetWidth()/2, ofGetHeight()/2, 0);
	static float currentUpRot = -90;
	float targetUpRot;
	switch([[viewController settings] getInt:kSetting_Orientation]) {
		case UIDeviceOrientationPortrait:
			targetUpRot = 0;
			break;
			
		case UIDeviceOrientationPortraitUpsideDown:
			targetUpRot = 180;
			break;
			
		default:
		case UIDeviceOrientationLandscapeLeft:
			targetUpRot = 90;
			break;
			
		case UIDeviceOrientationLandscapeRight:
			targetUpRot = -90;
			break;
			
	}
	currentUpRot += (targetUpRot - currentUpRot) * 0.1f;
	glRotatef(currentUpRot, 0, 0, 1);
	glColor4f(1, 1, 1, 1);
	ofSetRectMode(OF_RECTMODE_CENTER);
	imageUp.draw(0, 0);
	glPopMatrix();
	
	for(int i=0; i<OF_MAX_TOUCHES; i++) fingerDrawer[i].draw();	
}



void testApp::exit() {
	[viewController release];
}




#pragma mark Touch Callbacks

void rotXY(float x, float y) {
	switch([[viewController settings] getInt:kSetting_Orientation]) {
		case UIDeviceOrientationPortrait:
			rotatedTouchPosition.x = x/ofGetWidth();
			rotatedTouchPosition.y = y/ofGetHeight();
			break;
			
		case UIDeviceOrientationPortraitUpsideDown:
			rotatedTouchPosition.x = 1 - x/ofGetWidth();
			rotatedTouchPosition.y = 1 - y/ofGetHeight();
			break;
			
		case UIDeviceOrientationLandscapeRight:
			rotatedTouchPosition.x = 1 - y/ofGetHeight();
			rotatedTouchPosition.y = x/ofGetWidth();
			break;
			
		default:
		case UIDeviceOrientationLandscapeLeft:
			rotatedTouchPosition.x = y/ofGetHeight();
			rotatedTouchPosition.y = 1.0f - x/ofGetWidth();
			break;
	}
}


void testApp::touchDoubleTap(float x, float y, int touchId, ofxMultiTouchCustomData *data) {
}


void testApp::touchDown(float x, float y, int touchId, ofxMultiTouchCustomData *data) {
	fingerDrawer[touchId].touchDown(x, y);
	rotXY(x, y);
	[viewController tuioSender]->cursorPressed(rotatedTouchPosition.x, rotatedTouchPosition.y, touchId);
}

void testApp::touchMoved(float x, float y, int touchId, ofxMultiTouchCustomData *data) {
	fingerDrawer[touchId].touchMoved(x, y);
	rotXY(x, y);	
	[viewController tuioSender]->cursorDragged(rotatedTouchPosition.x, rotatedTouchPosition.y, touchId);
}

void testApp::touchUp(float x, float y, int touchId, ofxMultiTouchCustomData *data) {
	fingerDrawer[touchId].touchUp();	
	rotXY(x, y);	
	[viewController tuioSender]->cursorReleased(rotatedTouchPosition.x, rotatedTouchPosition.y, touchId);
}
