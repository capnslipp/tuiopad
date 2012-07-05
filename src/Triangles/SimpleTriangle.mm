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
    
    //    cout << "\norientation = " << orientation <<endl;
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
    //	rotate(ptsList.begin(), ptsList.begin() + test, ptsList.end());
    // declare the point between the longest sides as the orientation point
    int test = distance(sideList.begin(), it);
    test--;
    if(test == -1) test = 2;
    
    // orientation point is the point between the longest sides
    orientationPointID = test;
//    cout << "\nsortsides method, orientationpointID = " << orientationPointID;
}



float SimpleTriangle::distanceBetweenCursors(MyCursorInfo* c1, MyCursorInfo* c2) {
	float dx = c1->x - c2->x;
	float dy = c1->y - c2->y;
	return sqrtf(dx*dx+dy*dy);
}

bool SimpleTriangle::compareWith(SimpleTriangle *B, float aspectRatio)
{
    // check the orientation
    if (B->orientation != orientation)
    {
//        printf("\nMatching failed because of wrong orientation\n");
//        return false;
    }
    
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
    
    vector<float> transformedSides;
    transformedSides.push_back(distanceBetweenCursors(&c1Transformed, &c2Transformed));
    transformedSides.push_back(distanceBetweenCursors(&c2Transformed, &c3Transformed));
    transformedSides.push_back(distanceBetweenCursors(&c1Transformed, &c3Transformed));
    
    sideList.clear();
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c2Transformed));
    sideList.push_back(distanceBetweenCursors(&c2Transformed, &c3Transformed));
    sideList.push_back(distanceBetweenCursors(&c1Transformed, &c3Transformed));
    
    sortSides();
    
    vector<float> hisSides = B->getSides();
    for (int i = 0; i<3; i++) {
        float diff = hisSides.at(i) - sideList.at(i);
        float absDiff = fabs(diff);
//        cout << "\nabsDiff = " << absDiff;
        if(absDiff > DISTANCE_TOLERANCE) return false;
    }
	return true;
}

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


int SimpleTriangle::getSymbolID()
{
    return symbolID;
}

void SimpleTriangle::setSymbolID(int ID)
{
    symbolID = ID;
}

MyCursorInfo* SimpleTriangle::getOrientationPoint() {
    return cursors.at(0);
}


//
//SimpleTriangle* SimpleTriangle::getTransformedTriangle(float aspectRatio)
//{
//    if(lastAspectRatio == aspectRatio) return this; // auf jeden fall irgendwie nix machen 
//    
//    if (aspectRatio < 1)    // x coordinate has to be scaled down
//    {
//        p1 = new MyCursorInfo(cursors.at(0)->x/aspectRatio, this->cursors.at(0)->y);
//        p2 = new MyCursorInfo(this->tcurList.at(1)->getX()/aspectRatio, this->tcurList.at(1)->getY());
//        p3 = new MyCursorInfo(this->tcurList.at(2)->getX()/aspectRatio, this->tcurList.at(2)->getY());
//    }
//    else {                  // y coordinate has to be scaled up
//        p1 = new TuioPoint(this->tcurList.at(0)->getX(), this->tcurList.at(0)->getY()*aspectRatio);
//        p2 = new TuioPoint(this->tcurList.at(1)->getX(), this->tcurList.at(1)->getY()*aspectRatio);
//        p3 = new TuioPoint(this->tcurList.at(2)->getX(), this->tcurList.at(2)->getY()*aspectRatio);
//    }
//    return new SimpleTriangle(p1, p2, p3,);
//}


//void SimpleTriangle::computeParameters()
//{
//    this->adjustPointsClockwise();  // ensure that the points are ordered clockwise
//    
//    r1 = ptsList.at(0).getDistance(&ptsList.at(1));
//    r2 = ptsList.at(1).getDistance(&ptsList.at(2));
//    r3 = ptsList.at(2).getDistance(&ptsList.at(0));
//    sideList.push_back(r1);
//    sideList.push_back(r2);
//    sideList.push_back(r3);
//    this->sortSides();
//    
//    if (sideList.at(1) < sideList.at(2))
//        orientation = ORIENTATION_CLOCKWISE;
//    else 
//        orientation = ORIENTATION_COUNTER_CLOCKWISE;
//    
////    cout << "\norientation = " << orientation <<endl;
//}
//
//void SimpleTriangle::adjustPointsClockwise()
//{
//    float deltaX01 = ptsList.at(1).getX() - ptsList.at(0).getX();
//    float deltaX12 = ptsList.at(2).getX() - ptsList.at(1).getX();
//    float deltaY01 = ptsList.at(1).getY() - ptsList.at(0).getY();
//    float deltaY12 = ptsList.at(2).getY() - ptsList.at(1).getY();
//    float det = deltaX01*deltaY12 - deltaX12*deltaY01;
//    if (det < 0) {
//        // swap p1 and p2
//        TuioPoint temp = ptsList.at(1);
//        ptsList.erase(ptsList.begin()+1);
//        ptsList.push_back(temp);
//        if (tcurList.size()!=0)
//        {
//            TuioCursor *tempCursor = tcurList.at(1);
//            tcurList.erase(tcurList.begin()+1);
//            tcurList.push_back(tempCursor);
//        }
//    }
//}
//
//
//void SimpleTriangle::sortSides()
//{
//	vector<float>::iterator it = min_element(sideList.begin(), sideList.end());
//    rotate(sideList.begin(), it, sideList.end());
////	rotate(ptsList.begin(), ptsList.begin() + test, ptsList.end());
//    // declare the point between the longest sides as the orientation point
//    int test = distance(sideList.begin(), it);
//    test--;
//    if(test == -1) test = 2;
//    
//    // orientation point is the point between the longest sides
//    orientationPointID = test;
//    cout << "\nsortsides method, orientationpointID = " << orientationPointID;
//}
//
//string SimpleTriangle::testOutput()
//{
//    string result;
//	ostringstream floatStringHelper;
//	
//    for (int i = 0; i < 3; i++)
//    {
//        floatStringHelper << ptsList.at(i).getX() << " / " << ptsList.at(i).getY() << "\n";
//    }
//    floatStringHelper << "\nr1 = " << r1 << " r2 = " << r2 << " r3 = " << r3;
//    floatStringHelper << "\nsorted list:\n side 1 = " << sideList.at(0) << " side 2 = " << sideList.at(1) << " side 3 = " << sideList.at(2);
//    floatStringHelper << "\nsymbolID = " << symbolID;
//    floatStringHelper << "\norientation = " << orientation << endl;
//    
//	result = floatStringHelper.str();
//	return result;						
//}
//
//bool SimpleTriangle::compareWith(SimpleTriangle *B)
//{
//    // check the orientation
//    if (B->orientation != orientation)
//    {
////        printf("\nMatching failed because of wrong orientation\n");
////        return false;
//    }
//    vector<float> hisSides = B->getSides();
//    for (int i = 0; i<3; i++) {
//        float diff = hisSides.at(i) - this->sideList.at(i);
//        float absDiff = fabs(diff);
//        //cout << "\nabsDiff = " << absDiff;
//        if(absDiff > DISTANCE_TOLERANCE) return false;
//    }
//	return true;
////    else return false;
//}
//
//SimpleTriangle* SimpleTriangle::getTransformedTriangle(float aspectRatio)
//{
////    TuioPoint *p1, *p2, *p3;
////    if (aspectRatio < 1)    // x coordinate has to be scaled down
////    {
////        p1 = new TuioPoint(this->ptsList.at(0).getX()/aspectRatio, this->ptsList.at(0).getY());
////        p2 = new TuioPoint(this->ptsList.at(1).getX()/aspectRatio, this->ptsList.at(1).getY());
////        p3 = new TuioPoint(this->ptsList.at(2).getX()/aspectRatio, this->ptsList.at(2).getY());
////    }
////    else {                  // y coordinate has to be scaled up
////        p1 = new TuioPoint(this->ptsList.at(0).getX(), this->ptsList.at(0).getY()*aspectRatio);
////        p2 = new TuioPoint(this->ptsList.at(1).getX(), this->ptsList.at(1).getY()*aspectRatio);
////        p3 = new TuioPoint(this->ptsList.at(2).getX(), this->ptsList.at(2).getY()*aspectRatio);
////    }
//    TuioPoint *p1, *p2, *p3;
//    if (aspectRatio < 1)    // x coordinate has to be scaled down
//    {
//        p1 = new TuioPoint(this->tcurList.at(0)->getX()/aspectRatio, this->tcurList.at(0)->getY());
//        p2 = new TuioPoint(this->tcurList.at(1)->getX()/aspectRatio, this->tcurList.at(1)->getY());
//        p3 = new TuioPoint(this->tcurList.at(2)->getX()/aspectRatio, this->tcurList.at(2)->getY());
//    }
//    else {                  // y coordinate has to be scaled up
//        p1 = new TuioPoint(this->tcurList.at(0)->getX(), this->tcurList.at(0)->getY()*aspectRatio);
//        p2 = new TuioPoint(this->tcurList.at(1)->getX(), this->tcurList.at(1)->getY()*aspectRatio);
//        p3 = new TuioPoint(this->tcurList.at(2)->getX(), this->tcurList.at(2)->getY()*aspectRatio);
//    }
//    return new SimpleTriangle(p1, p2, p3, symbolID);
//}
//
//float SimpleTriangle::getCentroidX()
//{
//    return (tcurList[0]->getX() + tcurList[1]->getX() + tcurList[2]->getX()) / 3;
//}
//
//float SimpleTriangle::getCentroidY()
//{
//    return (tcurList[0]->getY() + tcurList[1]->getY() + tcurList[2]->getY()) / 3;
//}
//
//#pragma mark getter methods
//
//vector<float> SimpleTriangle::getSides()
//{
//    return this->sideList;
//}
//
//TuioPoint SimpleTriangle::getOrientationPoint()
//{
////    return &ptsList.at(orientationPointID);
//    return tcurList.at(orientationPointID)->getPosition();
//}
//
//int SimpleTriangle::getOrientationPointID()
//{
//    return orientationPointID;
//}
//
//vector<TuioCursor*> SimpleTriangle::getCursors()
//{
//    return tcurList;
//}
//
//vector<TuioPoint> SimpleTriangle::getPoints()
//{
//    return ptsList;
//}
//
//vector<int> SimpleTriangle::getCursorIDs()
//{
//    return cursorIDs;
//}
//
