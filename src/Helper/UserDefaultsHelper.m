//
//  UserDefaultsHelper.m
//  TuioPad
//
//  Created by Oleg Langer on 19.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDefaultsHelper.h"
#import "MSASettings.h"

@implementation UserDefaultsHelper

+ (float) defaultTolerance {
    NSMutableDictionary *current_settings = [[[NSUserDefaults standardUserDefaults] objectForKey:kSettings_Key] mutableCopy];
    return [[current_settings objectForKey:kSetting_OBJECT_TOLERANCE] floatValue];
}

@end
