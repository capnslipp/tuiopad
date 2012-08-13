//
//  SimpleTriangle.cpp
//  TuioPad
//
//  Created by Oleg Langer on 30.05.2012
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#include <iostream>
#include "SimpleTriangle.h"
#include "ofxiPhone.h"  // currently used only for ostringstream
#include "MyCursorInfo.h"
#include "TriangleManager.h"


SimpleTriangle::SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3) {
    cursors.push_back(c1);
    cursors.push_back(c2);
    cursors.push_back(c3);
    
    lastAspectRatio = 1.0f;
    
    computeParameters();
}

SimpleTriangle::SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3, int ID, float tolerance) {
    cursors.push_back(c1);
    cursors.push_back(c2);
    cursors.push_back(c3);
    
    symbolID = ID;
    
    lastAspectRatio = 1.0f;
    
    recognitionTolerance = tolerance;
    
    computeParameters();
}


void SimpleTriangle::computeParameters()
{
    this->adjustPointsClockwise();  // ensure that the points are ordered clockwise
    
    r1 = distanceBetweenCursors(cursors.at(0), cursors.at(1));
    r2 = distanceBetweenCursors(cursors.at(1), cursors.at(2));
    r3 = distanceBetweenCursors(cursors.at(0), cursors.at(2));
    sideList.push_back(r1);
    sideList.push_back(r2);
    sideList.push_back(r3);
    this->sortSides();
}

void SimpleTriangle::adjustPointsClockwise()
{
    float deltaX01 = cursors.at(1)->x - cursors.at(0)->x;
    float deltaX12 = cursors.at(2)->x - cursors.at(1)->x;
    float deltaY01 = cursors.at(1)->y - cursors.at(0)->y;
    float deltaY12 = cursors.at(2)->y - cursors.at(1)->y;
    float det = deltaX01*deltaY12 - deltaX12*deltaY01;
    if (det < 0) {
        // swap p1 and p2
        MyCursorInfo* temp = cursors.at(1);
        cursors.erase(cursors.begin()+1);
        cursors.push_back(temp);
    }
}

void SimpleTriangle::sortSides()
{
	vector<float>::iterator it = min_element(sideList.begin(), sideList.end());
    rotate(sideList.begin(), it, sideList.end());
    // declare the point between the longest sides as the orientation point
    int test = distance(sideList.begin(), it);
    test--;
    if(test == -1) test = 2;
    
    orientationPointID = test;
}

float SimpleTriangle::distanceBetweenCursors(MyCursorInfo* c1, MyCursorInfo* c2) {
	float dx = c1->x - c2->x;
	float dy = c1->y - c2->y;
	return sqrtf(dx*dx+dy*dy);
}

bool SimpleTriangle::compareWith(SimpleTriangle *B, float aspectRatio)
{    
    MyCursorInfo c1Transformed = *cursors.at(0);
    MyCursorInfo c2Transformed = *cursors.at(1);
    MyCursorInfo c3Transformed = *cursors.at(2);
    
    if (aspectRatio < 1)    // x coordinate has to be scaled down
    {
        c1Transformed.x /= aspectRatio;
        c2Transformed.x /= aspectRatio;
        c3Transformed.x /= aspectRatio;
    }
    else {                  // y coordinate has to be scaled up
        c1Transformed.y *= aspectRatio;
        c2Transformed.y *= aspectRatio;
        c3Transformed.y *= aspectRatio;
    }
    
    sideList.clear();
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c2Transformed));
    sideList.push_back(distanceBetweenCursors(&c2Transformed, &c3Transformed));
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c3Transformed));
    
    sortSides();
    
    float absDiff = 0;
    float absDiffsTemp[3];
    vector<float> hisSides = B->getSides();
    for (int i = 0; i<3; i++) {
        float diff = hisSides.at(i) - sideList.at(i);
        absDiff = fabs(diff);
        absDiffsTemp[i] = absDiff;
        if(absDiff > B->getRecognitionTolerance()) 
            return false;
    }    
	return true;
}

float SimpleTriangle::getMaxSideDifference(SimpleTriangle *t, float aspectRatio) {
    MyCursorInfo c1Transformed = *cursors.at(0);
    MyCursorInfo c2Transformed = *cursors.at(1);
    MyCursorInfo c3Transformed = *cursors.at(2);
    
    if (aspectRatio < 1)    // x coordinate has to be scaled down
    {
        c1Transformed.x /= aspectRatio;
        c2Transformed.x /= aspectRatio;
        c3Transformed.x /= aspectRatio;
    }
    else {                  // y coordinate has to be scaled up
        c1Transformed.y *= aspectRatio;
        c2Transformed.y *= aspectRatio;
        c3Transformed.y *= aspectRatio;
    }
    
    sideList.clear();
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c2Transformed));
    sideList.push_back(distanceBetweenCursors(&c2Transformed, &c3Transformed));
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c3Transformed));
    
    sortSides();
    
    float maxDiff = 0;
    vector<float> hisSides = t->getSides();
    for (int i = 0; i<3; i++) {
        float absDiff = fabs(hisSides.at(i) - sideList.at(i));
        cout << endl << "absdiff = " << fixed << absDiff;
        if (absDiff > maxDiff) maxDiff = absDiff;
    }    
    return maxDiff;
}

#pragma mark getter - setter

vector<float> SimpleTriangle::getSides() {
    return this->sideList;
}

vector<MyCursorInfo*> SimpleTriangle::getCursors() {
    return cursors;
}

float SimpleTriangle::getCentroidX()
{
    return (cursors.at(0)->x + cursors.at(1)->x + cursors.at(2)->x) / 3;
}

float SimpleTriangle::getCentroidY()
{
    return (cursors.at(0)->y + cursors.at(1)->y + cursors.at(2)->y) / 3;
}

int SimpleTriangle::getSymbolID()
{
    return symbolID;
}

void SimpleTriangle::setSymbolID(int ID)
{
    symbolID = ID;
}

MyCursorInfo* SimpleTriangle::getOrientationPoint() {
    return cursors.at(orientationPointID);
}

float SimpleTriangle::getRecognitionTolerance() {
    return  recognitionTolerance;
}

void SimpleTriangle::setRecognitionTolerance(float tolerance) {
    recognitionTolerance = tolerance;
}

#pragma mark - debug utility function

string SimpleTriangle::testOutput()
{
    string result;
	ostringstream floatStringHelper;
	
    for (int i = 0; i < 3; i++)
    {
        floatStringHelper << cursors.at(i)->x << " / " << cursors.at(i)->y << "\n";
    }
    floatStringHelper << "\nr1 = " << r1 << " r2 = " << r2 << " r3 = " << r3;
    floatStringHelper << "\nsorted list:\n side 1 = " << sideList.at(0) << " side 2 = " << sideList.at(1) << " side 3 = " << sideList.at(2);
    
	result = floatStringHelper.str();
	return result;						
}
