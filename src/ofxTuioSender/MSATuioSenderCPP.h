/***********************************************************************
 
 Copyright (c) 2009, Memo Akten, www.memo.tv
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ***********************************************************************/


#pragma once

#include "TuioServer.h"
#include "UdpSender.h"
#include "TuioCursor.h"
#include "ofxiPhone.h"

using namespace TUIO;

class MyCursorInfo {
public:
	float x, y;
	
	bool isAlive;		// is it alive this frame
	bool wasAlive;		// was it alive this frame
	bool moved;			// did it move this frame
	
	
	MyCursorInfo() {
		isAlive		= false;
		wasAlive	= false;
		moved		= false;
	}
};



class MSATuioSenderCPP { 
public:
	bool verbose;
	OscSender		*oscSender;
	TuioServer		*tuioServer;
	
	MSATuioSenderCPP() {
		oscSender	= NULL;
		tuioServer	= NULL;
		host		= "";
		port		= 0;
		verbose		= false;
	}
	
	~MSATuioSenderCPP() {
		delete oscSender;
		delete tuioServer;
	};
	
	void setup(std::string host, int port);
	void update();

	void cursorPressed(float x, float y, int cursorId);
	void cursorReleased(float x, float y, int cursorId);
	void cursorDragged(float x, float y, int cursorId);
	
protected:
	std::string		host;
	int				port;
	TuioCursor		*tuioCursor[OF_MAX_TOUCHES];
	MyCursorInfo	myCursor[OF_MAX_TOUCHES];
	TuioTime		currentTime;
};