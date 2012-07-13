/*
 *  TriangleObject.mm
 *  TuioPad
 *
 *  Created by berimac on 07.12.11.
 *  Copyright 2011 Oleg Langer. All rights reserved.
 *
 */

#include "TriangleObject.h"
#include "ofxiPhone.h"
#include "MyCursorInfo.h"

int TriangleObject::getSymbolID() {
    return triangle->getSymbolID();
}

float TriangleObject::getX() {
    return x;
}

float TriangleObject::getY() {
    return y;
}

float TriangleObject::getAngle() {
    return angle;
}

void TriangleObject::update()
{
    x = triangle->getCentroidX();
    y = triangle->getCentroidY();
    
    float xp = triangle->getOrientationPoint()->x;
    float yp = triangle->getOrientationPoint()->y;
    
    float side = x -  xp;
	float height = y - yp;
	float distance = sqrtf(side*side + height*height);
	angle = (float)(M_PI/2 - asin(height/distance));
	if (side>0) 
        angle = 2.0f*(float)M_PI-angle;
}



string TriangleObject::testOutput()
{
    string result;
	ostringstream floatStringHelper;
    floatStringHelper << "\nangle = " << angle;
    floatStringHelper << "\ncentroidX = " << x;
    floatStringHelper << "\ncentroidY = " << y;
//    floatStringHelper << "\nOrientationPointX = " << triangle->getOrientationPoint().getX();
//    floatStringHelper << "\nOrientationPointY = " << triangle->getOrientationPoint().getY();
//    floatStringHelper << "\norientationPointID = " << triangle->getOrientationPointID();
    
	result = floatStringHelper.str();
    return result;
}