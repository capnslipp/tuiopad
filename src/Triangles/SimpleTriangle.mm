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

//extern float initial_tolerance;
//extern float evaluated_tolerance;

NSMutableDictionary *current_settings = [[[NSUserDefaults standardUserDefaults] objectForKey:kSettings_Key] mutableCopy];
static float initial_tolerance = [[current_settings objectForKey:kSetting_OBJECT_TOLERANCE] floatValue];
static float evaluated_tolerance = 0.0f;


#define SIZE_OF_ABSDIFFS 100

float absDiffs[SIZE_OF_ABSDIFFS];
int absDiffCounter = 0;
long double absDiffsSum = 0;

SimpleTriangle::SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3) {
    cursors.push_back(c1);
    cursors.push_back(c2);
    cursors.push_back(c3);
    
    lastAspectRatio = 1.0f;
    
    computeParameters();
}

SimpleTriangle::SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3, int ID) {
    cursors.push_back(c1);
    cursors.push_back(c2);
    cursors.push_back(c3);
    
    symbolID = ID;
    
    lastAspectRatio = 1.0f;
    
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
    
    if (sideList.at(1) < sideList.at(2))
        orientation = ORIENTATION_CLOCKWISE;
    else 
        orientation = ORIENTATION_COUNTER_CLOCKWISE;
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
    
    // orientation point is the point between the longest sides
    orientationPointID = test;
}



float SimpleTriangle::distanceBetweenCursors(MyCursorInfo* c1, MyCursorInfo* c2) {
	float dx = c1->x - c2->x;
	float dy = c1->y - c2->y;
	return sqrtf(dx*dx+dy*dy);
}

bool SimpleTriangle::compareWith(SimpleTriangle *B, float aspectRatio)
{
    // check the orientation
//    if (B->orientation != orientation)
//    {
//        printf("\nMatching failed because of wrong orientation\n");
//        return false;
//    }
    
    // TRANSFORM POINTS AND SIDES TO THE ASPECT RATIO
    
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
        if(absDiff > initial_tolerance) 
            return false;
    }

    for (int i = 0; i < 3; i++) {
        absDiffs[absDiffCounter] = absDiffsTemp[i];
        absDiffCounter++;
        absDiffsSum += absDiffsTemp[i];
        if (absDiffCounter == SIZE_OF_ABSDIFFS) break;
    }

        
    if (absDiffCounter == SIZE_OF_ABSDIFFS) {
        float max = *max_element(absDiffs,absDiffs + SIZE_OF_ABSDIFFS);
        cout << endl << "Absdiffs:" << endl;
        cout << "max element = " << fixed << max << endl;
        if (max > evaluated_tolerance) evaluated_tolerance = max;
        cout << "evaluated tolerance = " << fixed << evaluated_tolerance << endl;

        absDiffCounter = 0;
    }

	return true;
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
    //    floatStringHelper << "\nsymbolID = " << symbolID;
    //    floatStringHelper << "\norientation = " << orientation << endl;
    
	result = floatStringHelper.str();
	return result;						
}
