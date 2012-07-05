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
		moved = false;
        angle = 0.0f;
	};
    TriangleObject(SimpleTriangle* tr);
	~TriangleObject(){};
	
    
    SimpleTriangle *triangle;
    
	
	bool isAlive;		// is it alive this frame
	bool wasAlive;		// was it alive this frame
	bool moved;			// did it move this frame

	
	void update();
    float getX();
    float getY();
    float getAngle();
    void setTriangle(SimpleTriangle *);
    
    int getSymbolID();
    string testOutput();
};



#endif // TuioPad_TriangleObject_h
