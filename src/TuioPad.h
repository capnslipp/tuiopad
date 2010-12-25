
#ifndef TUIOPAD_H
#define TUIOPAD_H

#import "ofMain.h"
#include "ofxMultiTouch.h"

class TuioPad : public ofBaseApp, ofxMultiTouchListener
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