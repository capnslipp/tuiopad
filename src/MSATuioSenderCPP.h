/*
 TuioPad http://www.tuio.org/
 An Open Source TUIO App for iOS based on OpenFrameworks
 (c) 2010 by Mehmet Akten <memo@memo.tv> and Martin Kaltenbrunner <modin@yuri.at>
 
 TuioPad is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TuioPad is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TuioPad.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

#include "TuioServer.h"
#include "UdpSender.h"
#include "TcpSender.h"
#include "TuioCursor.h"
#include "ofxiPhone.h"
#include "MyCursorInfo.h"

#define OF_MAX_TOUCHES 10
#define MAX_OBJECT_NUMBER 3

using namespace TUIO;

class TriangleManager;

class MSATuioSenderCPP { 
public:
	bool verbose;
	OscSender		*oscSender;
	TuioServer		*tuioServer;
	
	MSATuioSenderCPP() {
		oscSender	= NULL;
		tuioServer	= NULL;
        triangleManager = NULL;
		//host		= "";
		//port		= 0;
		verbose		= false;
	}
	
	~MSATuioSenderCPP() {
		if (tuioServer) delete tuioServer;
		if (oscSender)  delete oscSender;
	};
	
	void setup(std::string host, int port, int tcp, std::string ip, bool objectProfile = 0, bool cursorProfile = 1);
	void update();
	void close();

	void cursorPressed(float x, float y, int cursorId);
	void cursorReleased(float x, float y, int cursorId);
	void cursorDragged(float x, float y, int cursorId);
	
protected:
	//std::string		host;
	//int				port;
	TuioCursor		*tuioCursor[OF_MAX_TOUCHES];
	MyCursorInfo	myCursor[OF_MAX_TOUCHES];
	TuioTime		currentTime;
    
    TuioObject		*tuioObject[MAX_OBJECT_NUMBER];
    TriangleManager *triangleManager;
    
    bool objectProfileEnabled, cursorProfileEnabled;
};