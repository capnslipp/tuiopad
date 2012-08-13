//
//  FileManagerHelper.m
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Oleg Langer. All rights reserved.
//

#import "FileManagerHelper.h"

@implementation FileManagerHelper

//The objects are saved as a string with 8 substrings separated by a whitespace according to the following scheme:
//x0 y0 x1 y1 x2 y2 id tolerance
//The tolerance can be a number or "default" string

#pragma mark - saving/deleting objects

+ (void) saveObject:(NSString *)dots withID:(NSString *)objectID {
    NSFileManager *filemgr = [NSFileManager defaultManager];    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:dataFile];
    }
    
    dots = [dots stringByAppendingString:@"default"];
    
    [dict setObject:dots forKey:objectID];
    
    [dict writeToFile:dataFile atomically:YES];
}

+ (NSDictionary*) getObjects {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    return dict;
}

+ (NSMutableArray *) getExistingIDs {
    NSMutableArray *existingIDs = [[[NSMutableArray alloc] init] autorelease];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    if ([filemgr fileExistsAtPath:dataFile])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
        existingIDs = [NSMutableArray arrayWithArray:[dict allKeys]];
    }

    return existingIDs;
}

+ (void) deleteAllObjects {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        [filemgr removeItemAtPath:dataFile error:nil];
    }
}

+ (void) deleteObjectWithId:(NSString *)objectID {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        NSMutableDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
        [dict removeObjectForKey:objectID];
        [dict writeToFile:dataFile atomically:YES];
    }
}

+ (void) overwriteObjectWithID:(NSString *)objectID withObject:(NSString *)dots {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        NSMutableDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
        [dict setValue:dots forKey:objectID];
        [dict writeToFile:dataFile atomically:YES];
    }
}

#pragma mark - save/get object recognition tolerance

+ (void) setCustomRecognitionTolerance:(NSString *)tolerance forObjectWithID:(NSString *)objectID {
    NSFileManager *filemgr = [NSFileManager defaultManager];    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (![filemgr fileExistsAtPath: dataFile])
        return;
    
    dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    
    NSString *objValues = [dict objectForKey:objectID];
    
    NSMutableArray * singleValues = [[[NSMutableArray alloc] initWithArray:[objValues componentsSeparatedByString:@" "] copyItems: YES] autorelease];
    if (singleValues.count == 7) [singleValues removeObjectAtIndex:6];
    objValues = @"";
    for (int i = 0; i < singleValues.count; i++) {
        objValues = [objValues stringByAppendingFormat:@"%@ ", [singleValues objectAtIndex:i]];
    }
    objValues = [objValues stringByAppendingString:tolerance];
    [dict setValue:objValues forKey:objectID];
    
    [dict writeToFile:dataFile atomically:YES];
}

+ (NSString*) getCustomRecognitionTolerance:(NSString *)objectID {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    
    NSString *objValues = [dict objectForKey:objectID];
    NSMutableArray * singleValues = [[[NSMutableArray alloc] initWithArray:[objValues componentsSeparatedByString:@" "] copyItems: YES] autorelease];
    if (singleValues.count != 7)
        return @"default";
    else {
        NSString *retValue = [singleValues objectAtIndex:6];
        if (retValue.length == 0) return @"default";
        return retValue;
    }

}

@end

