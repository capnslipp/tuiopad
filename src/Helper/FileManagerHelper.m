//
//  FileManagerHelper.m
//  TuioPad
//
//  Created by Oleg Langer on 30.06.12.
//  Copyright (c) 2012 Fachhochschule Düsseldorf. All rights reserved.
//

#import "FileManagerHelper.h"

@implementation FileManagerHelper

// new functions

+ (void) saveObject:(NSString *)dots withID:(NSString *)objectID {
    NSFileManager *filemgr = [NSFileManager defaultManager];    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([filemgr fileExistsAtPath: dataFile])
    {
        dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    }
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
    NSMutableArray *existingIDs = [[NSMutableArray alloc] init];
    
    // file handling
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"datafile.dat"];
    
    // Check if the file already exists
    if ([filemgr fileExistsAtPath:dataFile])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFile];
        existingIDs = [NSMutableArray arrayWithArray:[dict allKeys]];
    }
    
    [filemgr release];
    return [existingIDs copy];
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

@end

