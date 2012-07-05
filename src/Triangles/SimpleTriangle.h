//
//  SimpleTriangle.h
//  TuioPad
//
//  Created by Oleg Langer on 01.06.12
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#ifndef TuioPad_SimpleTriangle_h
#define TuioPad_SimpleTriangle_h

#define DISTANCE_TOLERANCE 0.075f
#define ORIENTATION_CLOCKWISE true
#define ORIENTATION_COUNTER_CLOCKWISE false

#import "TuioCursor.h"
#include <vector>
#include <string>


using namespace std;

class MyCursorInfo;


class SimpleTriangle {
public:
    SimpleTriangle(){};
    ~SimpleTriangle(){};

    SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3);
    SimpleTriangle(MyCursorInfo* c1, MyCursorInfo* c2, MyCursorInfo* c3, int symbolID);
    
    
    
    
    void computeParameters();
    void adjustPointsClockwise();
    void sortSides();
    
    float distanceBetweenCursors(MyCursorInfo* c1, MyCursorInfo* c2);
    
    bool compareWith(SimpleTriangle*, float aspectRatio);

//getter/setter
    

    vector<float> getSides();
    vector<MyCursorInfo*> getCursors();
    
    int getSymbolID();
    void setSymbolID(int);
    
    float getCentroidX();
    float getCentroidY();
    MyCursorInfo* getOrientationPoint();
    
//    SimpleTriangle* getTransformedTriangle(float aspectRatio);
    
    
// debugging utilities    
    string testOutput();
    
protected:
    vector<MyCursorInfo*> cursors;
//    vector<MyCursorInfo*> transformedCursors;
    
    float lastAspectRatio;
    
    
    
    
    float r1,r2,r3;     // distances between points
    bool orientation;
    int orientationPointID;
    int symbolID;
    
                   
    vector <float> sideList;
};

#endif






