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
    
    float side = xp - x;
	float height = yp - y;
	
	float distance = sqrtf(side*side + height*height);
	
	angle = (float)(M_PI/2 - asin(side/distance));
	if (height<0) 
        angle = 2.0f*(float)M_PI-angle;
//    printf("\n%s  angle = %f\tside = %f\tdistance = %f\theight = %f", __FUNCTION__, angle, side, distance, height);
//    cout << "\ndevice orientation = " << [UIDevice currentDevice].orientation << endl;
//    printf("\ncentroid x = %f y = %f\toPoint x = %f y = %f", x, y, xp, yp);
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