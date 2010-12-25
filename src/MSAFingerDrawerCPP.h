/*
 *  MSAFingerDrawerCPP.h
 *  TUIO Pad
 *
 *  Created by Mehmet Akten on 14/01/2009.
 *  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
 *
 */

#pragma once

#include "ofMain.h"

#include "MSAViewController.h"

#define		FINGER_RADIUS		40


class MSAFingerDrawerCPP {
public:
	
	MSAFingerDrawerCPP() {
	}
	
	void draw() {
		if(points.size() == 0) return;
		
		int numPoints = points.size()>>1;
		
		
		ofDisableAlphaBlending();
		//ofEnableSmoothing();
		
		glColor4f(0.5, 0.5, 0.5, 1);
		glLineWidth(2);
		glEnableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_NORMAL_ARRAY);
		
		glVertexPointer(2, GL_FLOAT, 0, &points[0]);
		glDrawArrays(GL_LINE_STRIP, 0, numPoints);
		
		//glColor4f(1, 0, 0, 1);
		//glPointSize(3);
		//glDrawArrays(GL_POINTS, 0, numPoints);
		
		
		ofEnableAlphaBlending();
		float x = points.at(points.size()-2);
		float y = points.at(points.size()-1);
		ofFill();
		glColor4f(0.1, 0.2, 0.3, 0.3);
		ofCircle(x, y, FINGER_RADIUS);
		//ofCircle(x, y, FINGER_RADIUS * 0.8);
		//ofCircle(x, y, FINGER_RADIUS * 0.5);
		//ofCircle(x, y, FINGER_RADIUS * 0.2);
		//ofNoFill();
		//glColor4f(0, 0, 0, 1);
		//ofCircle(x, y, FINGER_RADIUS);
	}
	
	void touchDown(int x, int y) {
		points.clear();
		points.push_back(x);
		points.push_back(y);
	}
	
	
	void touchMoved(int x, int y) {
		points.push_back(x);
		points.push_back(y);
	}
	
	
	void touchUp() {
		points.clear();
	}
	
protected:
	vector<float> points;
};
