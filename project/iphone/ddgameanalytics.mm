
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
		[GameAnalytics setDebugLogEnabled:false];
		[GameAnalytics setGameKey:appid secretKey:signature build:version];
	}
	
	void gaDesignEvent(const char *eventId, float eventValue, const char *area) {
		NSString *event_id = [[NSString alloc] initWithUTF8String:eventId];
		NSString *event_area = [[NSString alloc] initWithUTF8String:area];
		[GameAnalytics logGameDesignDataEvent:event_id withParams:@{@"area" : event_area, @"value" : [NSNumber numberWithFloat:eventValue]}];
	}

	void gaErrorEvent(const char *message, const char *severity, const char *area) {
		NSString *event_message = [[NSString alloc] initWithUTF8String:message];
		NSString *event_severity = [[NSString alloc] initWithUTF8String:severity];
		NSString *event_area = [[NSString alloc] initWithUTF8String:area];
		[GameAnalytics logQualityAssuranceDataEvent:event_message withParams:@{@"area" : event_area, @"message" : event_message}];
	}

	void gaBusinessEvent(const char *eventId, const char *currency, int amount, const char *area) {
		NSString *event_id = [[NSString alloc] initWithUTF8String:eventId];
		NSString *event_currency = [[NSString alloc] initWithUTF8String:currency];
		NSString *event_area = [[NSString alloc] initWithUTF8String:area];
		[GameAnalytics logBusinessDataEvent:event_id currencyString: event_currency amountNumber: [NSNumber numberWithInt:amount] area: event_area x:@0.0f y:@0.0f z:@0.0f]; 
	}
	
}