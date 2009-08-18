
#ifndef TESTAPP_H
#define TESTAPP_H

#import "ofMain.h"
#include "ofxMultiTouch.h"

class testApp : public ofBaseApp, ofxMultiTouchListener
{

public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(float x, float y, int touchId, ofxMultiTouchCustomData *data = NULL);
	void touchMoved(float x, float y, int touchId, ofxMultiTouchCustomData *data = NULL);
	void touchUp(float x, float y, int touchId, ofxMultiTouchCustomData *data = NULL);
	void touchDoubleTap(float x, float y, int touchId, ofxMultiTouchCustomData *data = NULL);
};

#endif