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


void TriangleObject::setTriangle(SimpleTriangle *tr)
{
	this->triangle = tr;
}

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
    return 0.0f;
}

void TriangleObject::update()
{
    //    m_triangle->computeParameters();    // params of the base class
    x = triangle->getCentroidX();
    y = triangle->getCentroidY();
//    angle = - triangle->getOrientationPoint().getAngle(m_x, m_y);
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