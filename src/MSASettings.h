/*
 *  MSASettings.h
 *  TUIO Pad
 *
 *  Created by Mehmet Akten on 20/02/2009.
 *	Updated by Martin Kaltenbrunner 2010
 *  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
 *
 */

#pragma once

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <ifaddrs.h>

#define kSetting_HostIP				@"HostIP"
#define kSetting_Port				@"Port"
#define kSetting_Packet				@"Packet"
#define kSetting_Orientation		@"Orientation"
#define kSetting_PeriodicUpdates	@"PeriodicUpdates"
#define kSetting_FullUpdates		@"FullUpdates"

#define kSettings_Key				@"TuioPadSettings"


@interface MSASettings : NSObject {
	NSMutableDictionary* current;
	NSMutableDictionary* defaults;
}

-(void)loadSettings;
-(void)saveSettings;

-(id)getDefaultFor:(NSString*)key;

-(float)getFloat:(NSString*)key;
-(int)getInt:(NSString*)key;
-(const char*)getCString:(NSString*)key;
-(NSString*)getString:(NSString*)key;

-(void)setFloat:(float)d forKey:(NSString*)key;
-(void)setInt:(int)d forKey:(NSString*)key;
-(void)setCString:(char*)d forKey:(NSString*)key;
-(void)setString:(NSString*)d forKey:(NSString*)key;

-(BOOL)connectedToNetwork;
-(NSString *)getBroadcastAddress;
-(NSString *)getIpAddress;

@end