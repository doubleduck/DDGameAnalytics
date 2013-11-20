
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#include <ctype.h>
#include <objc/runtime.h>
#import "GameAnalytics.h"
#include "ga.h"
namespace ddgameanalytics 
{
	
	void gaInit(const char *appId, const char *appSignature, const char *appVersion)
	{
		NSString *appid = [[NSString alloc] initWithUTF8String:appId];
		NSString *signature = [[NSString alloc] initWithUTF8String:appSignature];
		NSString *version = [[NSString alloc] initWithUTF8String:appVersion];
		[GameAnalytics setDebugLogEnabled:true];
		[GameAnalytics setGameKey:appid secretKey:signature build:version];
	}
	
	void gaDesignEvent(const char *eventId, float eventValue, const char *area) {
		NSString *event_id = [[NSString alloc] initWithUTF8String:eventId];
		NSString *event_area = [[NSString alloc] initWithUTF8String:area];
		[GameAnalytics logGameDesignDataEvent:event_id withParams:@{@"area" : event_area, @"value" : [NSNumber numberWithFloat:eventValue]}];
	}

	void gaBusinessEvent(const char *eventId, const char *currency, int amount, const char *area) {
		
	}
	
}