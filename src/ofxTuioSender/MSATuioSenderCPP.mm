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


#include "MSATuioSenderCPP.h"


void MSATuioSenderCPP::cursorPressed(float x, float y, int cursorId) {
	myCursor[cursorId].x		= x;
	myCursor[cursorId].y		= y;
	myCursor[cursorId].isAlive	= true;
}


void MSATuioSenderCPP::cursorDragged(float x, float y, int cursorId) {
	myCursor[cursorId].x		= x;
	myCursor[cursorId].y		= y;
	myCursor[cursorId].isAlive	= true;
	myCursor[cursorId].moved	= true;
}


void MSATuioSenderCPP::cursorReleased(float x, float y, int cursorId) {
	myCursor[cursorId].x		= x;
	myCursor[cursorId].y		= y;
	myCursor[cursorId].isAlive	= false;
}


void MSATuioSenderCPP::setup(std::string host, int port) {
	if(this->host.compare(host) == 0 && this->port == port) return;
	
	if(verbose) printf("MSATuioSenderCPP::setup(host: %s, port: %i\n", host.c_str(), port);
	this->host = host;
	this->port = port;
	if(tuioServer) delete tuioServer;
	tuioServer = new TuioServer((char*)host.c_str(), port);
	tuioServer->enableFullUpdate();
	currentTime = TuioTime::getSessionTime();	
}


void MSATuioSenderCPP::update() {
	if(tuioServer == NULL) return;
	
	currentTime = TuioTime::getSessionTime();
	tuioServer->initFrame(currentTime);
	for(int i=0; i<OF_MAX_TOUCHES; i++) {
		
		float x = myCursor[i].x;
		float y = myCursor[i].y;
		
		if(myCursor[i].isAlive && !myCursor[i].wasAlive) {
			if(verbose) printf("MSATuioSenderCPP - addTuioCursor %i %f, %f\n", i, x, y);
			tuioCursor[i] = tuioServer->addTuioCursor(x,y);	
			
		} else if(!myCursor[i].isAlive && myCursor[i].wasAlive) {
			if(verbose) printf("MSATuioSenderCPP - removeTuioCursor %i %f, %f\n", i, x, y);
			
			if(tuioCursor[i]) tuioServer->removeTuioCursor(tuioCursor[i]);
			else printf("** WEIRD: Trying to remove tuioCursor %i but it's null\n", i);
			
		} else if(myCursor[i].isAlive && myCursor[i].wasAlive && myCursor[i].moved) {
			myCursor[i].moved = false;
			if(verbose) printf("MSATuioSenderCPP - updateTuioCursor %i %f, %f\n", i, x, y);
			if(tuioCursor[i]) tuioServer->updateTuioCursor(tuioCursor[i], x, y);
			else printf("** WEIRD: Trying to update tuioCursor %i but it's null\n", i);
			
		}
		
		myCursor[i].wasAlive = myCursor[i].isAlive;
	}
	tuioServer->stopUntouchedMovingCursors();
	tuioServer->commitFrame();
}





