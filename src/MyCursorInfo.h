//
//  MyCursorInfo.h
//  TuioPad
//
//  Created by Oleg Langer on 05.07.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#ifndef TuioPad_MyCursorInfo_h
#define TuioPad_MyCursorInfo_h

class MyCursorInfo {
public:
	float x, y;
	
	bool isAlive;		// is it alive this frame
	bool wasAlive;		// was it alive this frame
	bool moved;			// did it move this frame
    
    bool isUsedInTriangle;
	
	
	MyCursorInfo() {
		isAlive		= false;
		wasAlive	= false;
		moved		= false;
        isUsedInTriangle = false;
	}
    
    MyCursorInfo(float xPos, float yPos) : x(xPos), y(yPos) { 
        isAlive		= false;
		wasAlive	= false;
		moved		= false;
        isUsedInTriangle = false;
    }
    
    ~MyCursorInfo() {
        
    }
};

#endif
