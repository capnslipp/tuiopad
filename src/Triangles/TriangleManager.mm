//
//  TriangleHandler.mm
//  TuioPad
//
//  Created by Oleg Langer on 11/17/11.
//  Copyright (c) 2011 Oleg Langer. All rights reserved.
//

#include "TriangleManager.h"
#import "FileManagerHelper.h"

long matchCounter = 0;

TriangleManager::TriangleManager()
{
    for( int i = 0; i < MAX_OBJECT_NUMBER; i++) triangleObject[i] = new TriangleObject();
}

void TriangleManager::addNewCursor(MyCursorInfo *cursorInfo) {
    freePoints.push_back(cursorInfo);
}

void TriangleManager::removeCursor(MyCursorInfo *cursorInfo) {
    vector<MyCursorInfo*>::iterator pos = find (freePoints.begin(), freePoints.end(), cursorInfo);
    if ( pos != freePoints.end() ) 
        freePoints.erase(pos);
        removeTriObjectContainingPoint(cursorInfo);
}

void TriangleManager::update()
{
    if (newTriangleList.size() > 0)
        for (int i = 0; i < newTriangleList.size(); i++) {
            delete newTriangleList.at(i);
        }
    newTriangleList.clear();
    
    if(freePoints.size() >= 3)
	{
        handleNewCursors();
        compareTriangles();
        handleNewTriObjects();
    }
    updateExistingTriObject();
}

void TriangleManager::handleNewCursors()
{
    vector<MyCursorInfo*>::iterator i1, i2, i3;
    for(i1 = freePoints.begin(); i1 != freePoints.end(); ++i1)
    {
        i2 = i1;
        for(++i2; i2 != freePoints.end(); ++i2)
        {
            i3 = i2;
            for(++i3; i3 != freePoints.end(); ++i3)
            {
                SimpleTriangle *temp = new SimpleTriangle(*i1, *i2, *i3);
                newTriangleList.push_back(temp);
            }
        }
    }
}

void TriangleManager::compareTriangles()
{
	if(newTriangleList.size()>0 && definedTriangleList.size()>0)
	{
		for ( int i = 0; i < newTriangleList.size(); i++)
		{
            SimpleTriangle *A = newTriangleList.at(i);
            float aspectRatio;
            if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
                aspectRatio = 1.333333f;
            else 
                aspectRatio = 0.75f;
            for ( int idef = 0; idef < definedTriangleList.size(); idef++)
            {
                SimpleTriangle *B = definedTriangleList.at(idef);                
                if (A->compareWith(B, aspectRatio))
                {
                    A->setSymbolID(B->getSymbolID());
                    // if recognized, put the current triangle to the working list
                    workingTriangleList.push_back(A);
                    // remove used points from freepoints
                    vector<MyCursorInfo*> p = A->getCursors();
                    for(vector<MyCursorInfo*>::iterator it = p.begin(); it != p.end(); it++) {
                        (*it)->isAlive = false;     // mark the cursor dead, so it will be removed
                        (*it)->isUsedInTriangle = true;
                        vector<MyCursorInfo*>::iterator pos = find(freePoints.begin(), freePoints.end(), (*it));
                        if ( pos != freePoints.end() ) freePoints.erase(pos);
                    }
                    // remove this triangle from the new triangle list
                    vector<SimpleTriangle*>::iterator pos = find(newTriangleList.begin(),newTriangleList.end(),A);
                    if ( pos != newTriangleList.end() ) newTriangleList.erase(pos);
				}
            }
		}
		
	}
}

void TriangleManager::handleNewTriObjects()
{
	for ( int i = 0; i < workingTriangleList.size(); i++)
	{
		for (int io = 0; io < MAX_OBJECT_NUMBER; io++) 
		{
			if(!triangleObject[io]->isAlive)	// if the place is free
			{
                triangleObject[io]->triangle = workingTriangleList.at(i);
                triangleObject[io]->isAlive = true;
                triangleObject[io]->update();
				break;
			}
		}
	}
	workingTriangleList.clear();
}

void TriangleManager::updateExistingTriObject()
{
    // NEW TRY TO CHECK EVERY FRAME
    
    for (int i = 0; i < MAX_OBJECT_NUMBER; i++) 
    {
        if(!triangleObject[i]->isAlive || !triangleObject[i]->wasAlive) continue;
        SimpleTriangle *A = triangleObject[i]->triangle;
        float aspectRatio;
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            aspectRatio = 1.333333f;
        else 
            aspectRatio = 0.75f;
        for ( int idef = 0; idef < definedTriangleList.size(); idef++)
        {
            if (definedTriangleList.at(idef)->getSymbolID() != triangleObject[i]->getSymbolID())
                continue;   // continue till the triangle is found
            SimpleTriangle *B = definedTriangleList.at(idef);                
            if (A->compareWith(B, aspectRatio))
            {
                    triangleObject[i]->update();
            }
            else {
                    removeTriObject(i);
            }
        }
    }
    
}

void TriangleManager::removeTriObject(int trObjectID) {
    vector<MyCursorInfo*> curs = triangleObject[trObjectID]->triangle->getCursors();
    for(vector<MyCursorInfo*>::iterator it = curs.begin(); it != curs.end(); ++it) {
        freePoints.push_back(*it);
        (*it)->isUsedInTriangle = false;
        (*it)->isAlive = true;
    }
    triangleObject[trObjectID]->isAlive = false;
    delete triangleObject[trObjectID]->triangle;
}

void TriangleManager::removeTriObjectContainingPoint(MyCursorInfo* cursorInfo) {
	for (int i = 0; i < MAX_OBJECT_NUMBER; i++) {
		if (!triangleObject[i]->isAlive) continue;
		vector<MyCursorInfo*> curs = triangleObject[i]->triangle->getCursors();
		vector<MyCursorInfo*>::iterator pos = find(curs.begin(), curs.end(), cursorInfo);
		if ( pos != curs.end() ) // found triobject containing point -> add all points to freelist
        {
            cursorInfo->isUsedInTriangle = false;
            for(vector<MyCursorInfo*>::iterator it = curs.begin(); it != curs.end(); it++)
                if(it!=pos) {
                    freePoints.push_back(*it);
                    (*it)->isUsedInTriangle = false;
                    (*it)->isAlive = true;
                }
            triangleObject[i]->isAlive = false;
            delete triangleObject[i]->triangle;
        }
	}
}


void TriangleManager::setDefinedTriangleList()
{
    definedTriangleList.clear();
    
    NSDictionary *allObjectsDict = [FileManagerHelper getObjects];
    NSArray *keys = [allObjectsDict allKeys];
    
    for (NSString *s in keys) {
        
        NSString *currentObject = [allObjectsDict objectForKey:s];
        
        NSMutableArray * singleValues = [[[NSMutableArray alloc] initWithArray:[currentObject componentsSeparatedByString:@" "] copyItems: YES] autorelease];

        MyCursorInfo *c1 = new MyCursorInfo((float)[[singleValues objectAtIndex:0] floatValue], (float)[[singleValues objectAtIndex:1] floatValue]);
        MyCursorInfo *c2 = new MyCursorInfo((float)[[singleValues objectAtIndex:2] floatValue], (float)[[singleValues objectAtIndex:3] floatValue]);
        MyCursorInfo *c3 = new MyCursorInfo((float)[[singleValues objectAtIndex:4] floatValue], (float)[[singleValues objectAtIndex:5] floatValue]);

        SimpleTriangle* T = new SimpleTriangle(c1, c2, c3,(int) [s intValue]);
        definedTriangleList.push_back(T);
//        cout << T->testOutput();
    }
    cout << "\ndefinedtrianglesize = " << definedTriangleList.size();
}

TriangleObject* TriangleManager::getObject(int index) {
    return triangleObject[index];
}