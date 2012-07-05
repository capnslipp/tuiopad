//
//  TriangleManager.h
//  TuioPad
//
//  Created by Oleg Langer on 11/17/11.
//  Copyright (c) 2011 Oleg Langer. All rights reserved.
//

#ifndef TuioPad_TriangleManager_h
#define TuioPad_TriangleManager_h

#include "MSATuioSenderCPP.h"
#include "SimpleTriangle.h"

using namespace std;

class MyCursorInfo;
class TriangleObject;



class TriangleManager
{
public:
    TriangleManager();
    ~TriangleManager(){};
    
    void update();
        
    void addNewCursor(MyCursorInfo* cursorInfo);
    void removeCursor(MyCursorInfo* cursorInfo);
    
    void handleNewCursors();
    void compareTriangles();
    void handleNewTriObjects();
    void updateExistingTriObject();
    
    void removeTriObject(int trObjectID);
    void removeTriObjectContainingPoint(MyCursorInfo* cur);
    
    void setDefinedTriangleList();

    TriangleObject* getObject(int index);
    
private:
    vector <MyCursorInfo*> freePoints;
    vector <MyCursorInfo*> usedPoints;
    vector <SimpleTriangle*> workingTriangleList;
    vector <SimpleTriangle*> newTriangleList;
    vector <SimpleTriangle*> definedTriangleList;
    
     TriangleObject	*triangleObject[MAX_OBJECT_NUMBER];
};


#endif
