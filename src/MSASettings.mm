/*
 *  MSASettings.mm
 *  TUIO Pad
 *
 *  Created by Mehmet Akten on 20/02/2009.
 *  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
 *
 */

#include "MSASettings.h"


#include <netdb.h>
#include <arpa/inet.h>



NSString* detectHost() {
	char hostname[64];
	gethostname(hostname, 64);
	sprintf(hostname, "%s.local", hostname);
	struct hostent *hp = gethostbyname(hostname);
	NSString *ip;
	if(hp) {
		NSLog(@"found hostname %s", hostname);
		struct in_addr *addr = (struct in_addr *)(hp->h_addr_list[0]);
		addr->s_addr |= 0xFF000000;
		char *szIP = inet_ntoa(*addr);
		ip = [NSString stringWithFormat:@"%s", szIP];
	} else {
		NSLog(@"cannot find hostname %s", hostname);
		ip = @"192.168.0.255";
	}
	return ip;
}



@implementation MSASettings



#pragma mark ----- Getters -----

-(id)getDefaultFor:(NSString*)key {
	return [defaults objectForKey:key];
}


-(float)getFloat:(NSString*)key {
	return [[current objectForKey:key] floatValue];
}

-(int)getInt:(NSString*)key {
	return [[current objectForKey:key] intValue];
}

-(NSString*)getString:(NSString*)key {
	return [current objectForKey:key];
}

-(const char*)getCString:(NSString*)key {
	return [[current objectForKey:key] UTF8String];
}




#pragma mark ----- Setters -----

-(void)setFloat:(float)d forKey:(NSString*)key {
	[current setObject:[NSNumber numberWithFloat:d] forKey:key];
	[self saveSettings];
}


-(void)setInt:(int)d forKey:(NSString*)key {
	[current setObject:[NSNumber numberWithInt:d] forKey:key];
	[self saveSettings];
}

-(void)setString:(NSString*)d forKey:(NSString*)key {
	[current setObject:d forKey:key];
	[self saveSettings];
}


-(void)setCString:(char*)d forKey:(NSString*)key {
	[current setObject:[NSString stringWithCString:d] forKey:key];
	[self saveSettings];
}




#pragma mark ----- Save & load -----

-(void)loadSettings {
	NSLog(@"MSASettings::loadSettings");
	[current release];
	current = [[[NSUserDefaults standardUserDefaults] objectForKey:kSettings_Key] mutableCopy];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(void)saveSettings {
	NSLog(@"MSASettings::saveSettings");
	[[NSUserDefaults standardUserDefaults] setObject:current forKey:kSettings_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark ----- System -----

-(void)awakeFromNib {
	NSLog(@"MSASettings::awakeFromNib");
	defaults = [[NSDictionary alloc] initWithObjectsAndKeys:
				detectHost(), kSetting_HostIP,
				[NSNumber numberWithInt:3333], kSetting_Port,
				[NSNumber numberWithInt:0], kSetting_Orientation, 
				[NSNumber numberWithInt:0], kSetting_Verbosity, 
				nil];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:defaults forKey:kSettings_Key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
	[self loadSettings];
}


-(void)dealloc {
	NSLog(@"MSASettings::dealloc");
	[defaults release];
	[current release];
	[super dealloc];
}



@end
