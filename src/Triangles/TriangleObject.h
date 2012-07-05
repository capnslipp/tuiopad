/*
 *  TriangleObject.h
 *  TuioPad
 *
 *  Created by Oleg Langer on 01.06.12
 *  Copyright 2011 Oleg Langer. All rights reserved.
 *
 */
#ifndef TuioPad_TriangleObject_h
#define TuioPad_TriangleObject_h
#include "SimpleTriangle.h"


class TriangleObject
{
private:
    float x, y;
    float angle;
    
public:
	TriangleObject() {
		isAlive = false;
		wasAlive = false;
        angle = 0.0f;
	};
	~TriangleObject(){};
	
    SimpleTriangle *triangle;
    
	bool isAlive;		// is it alive this frame
	bool wasAlive;		// was it alive this frame
	
	void update();
    float getX();
    float getY();
    float getAngle();
    
    int getSymbolID();
    string testOutput();
};


#endif // TuioPad_TriangleObject_h
