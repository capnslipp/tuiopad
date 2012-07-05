//
//  FileManagerHelper.h
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerHelper : NSObject


+(NSMutableArray*) getExistingIDs;
+(void) saveObject:(NSString*)dots withID:(NSString *)objectID;
+(NSDictionary*) getObjects;
+(void) deleteAllObjects;

+(void) deleteObjectWithId:(NSString*)objectID;
+(void) overwriteObjectWithID:(NSString*) objectID withObject:(NSString*)dots;

@end
