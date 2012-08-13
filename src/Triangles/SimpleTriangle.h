//
//  SimpleTriangle.h
//  TuioPad
//
//  Created by Oleg Langer on 01.06.12
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#ifndef TuioPad_SimpleTriangle_h
#define TuioPad_SimpleTriangle_h

#include <vector>
#include <string>
#import "MSASettings.h"

using namespace std;

class MyCursorInfo;


class SimpleTriangle {
public:
    SimpleTriangle(){};
    ~SimpleTriangle(){};

    SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3);
    SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3, int symbolID, float tolerance);
    
    void computeParameters();
    void adjustPointsClockwise();
    void sortSides();
    
    float distanceBetweenCursors(MyCursorInfo* c1, MyCursorInfo* c2);
    
    bool compareWith(SimpleTriangle*, float aspectRatio);

    vector<float> getSides();
    vector<MyCursorInfo*> getCursors();

    int getSymbolID();
    void setSymbolID(int);
    float getCentroidX();
    float getCentroidY();
    MyCursorInfo* getOrientationPoint();

    float getMaxSideDifference(SimpleTriangle*, float aspectRatio);
    float getRecognitionTolerance();
    void setRecognitionTolerance(float tolerance);
    
// debugging utilities    
    string testOutput();
protected:
    vector<MyCursorInfo*> cursors;    
    float lastAspectRatio;
 
    float r1,r2,r3;     // used only in testOutput()
    int orientationPointID;
    int symbolID;
                   
    vector <float> sideList;
    
    float recognitionTolerance;
};

#endif






