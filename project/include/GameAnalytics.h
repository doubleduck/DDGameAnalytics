//
//  GameAnalytics.h
//  GameAnalytics
//
//  Created by Aleksandras Smirnovas on 2/2/13.
//  Copyright (c) 2013 Aleksandras Smirnovas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAnalytics : NSObject

/*!
 *  @abstract Starts a GameAnalytics session using the Game and Sectret Keys for this Application
 *
 *  @param gameKey Your appliations's game key.
 *
 *  @note Go to the https://beta.gameanalytics.com/ to register for your game and secret keys.
 *
 *  @param secretKey Your appliations's secret key
 *
 *  @param build Specifies the App Version that will be used to group Analytics data.
 *
 */

+ (void)setGameKey:(NSString *)gameKey secretKey:(NSString *)secretKey build:(NSString *)build;

/*!
 *  @abstract User data
 *
 *  @note Used for tracking demographic information about individual users (players).
 *
 *                        Type        Required	 Description
 *  @param gender         char        No          The gender of the user (M/F).
 *  @param birth_year     integer     No          The year the user was born.
 *  @param country        string      No          The ISO2 country code the user is playing from.
 *  @param state          string      No          The code of the country state the user is playing from.
 *  @param friend_count   integer     No          The number of friends in the users network.
 *
 */
+ (void)logUserDataWithParams:(NSDictionary *)params;


/*!
 *  @abstract Game design data
 *
 *  @note Used to tracking game design events, for example level completion time.
 *
 *                      Type         Required	  Description
 *  @param  event_id    string       Yes          Identifies the event.
 *  @param  area        string       No           Indicates the area or game level where the event occurred.
 *  @param  x           float        No           X-position where the event occurred.
 *  @param  y           float        No           Y-position where the event occurred.
 *  @param  z           float        No           Z-position where the event occurred.
 *
 *  @param value        float        No           Numeric value which may be used to enhance the event_id.
 *
 */
+ (void)logGameDesignDataEvent:(NSString *)eventID withParams:(NSDictionary *)params;

/*!
 *  @abstract Business data
 *
 *  @note Used to track business related events, such as purchases of virtual items.
 *
 *                      Type        Required	  Description
 *  @param  event_id    string       Yes          Identifies the event.
 *  @param  area        string       No           Indicates the area or game level where the event occurred.
 *  @param  x           float        No           X-position where the event occurred.
 *  @param  y           float        No           Y-position where the event occurred.
 *  @param  z           float        No           Z-position where the event occurred.
 *
 *  @param currency     string       No           A custom string for identifying the currency. For example "USD", "US Dollars" or "GA Dollars". Conversion between different real currencies should be done before sending the amount to the API.
 *  @param amount       integer      No           Numeric value which corresponds to the cost of the purchase in the monetary unit divided by 100. For example, if the currency is "USD", the amount should be specified in cents.
 *
 */
+ (void)logBusinessDataEvent:(NSString *)eventID withParams:(NSDictionary *)params;

/*!
 *  @abstract Quality Assurance data
 *
 *  @note Used for tracking events related to quality assurance, such as crashes, system specifications, etc.
 *
 *                      Type        Required	  Description
 *  @param  event_id    string       Yes          Identifies the event.
 *  @param  area        string       No           Indicates the area or game level where the event occurred.
 *  @param  x           float        No           X-position where the event occurred.
 *  @param  y           float        No           Y-position where the event occurred.
 *  @param  z           float        No           Z-position where the event occurred.
 *
 *  @param message      string       No           Used to describe the event in further detail.
 *
 */
+ (void)logQualityAssuranceDataEvent:(NSString *)eventID withParams:(NSDictionary *)params;

/*!
 *  @abstract Updates session ID
 *
 */
+ (void)updateSessionID;



/* Optional Settings */

/*!
 *  @abstract Set custom user ID, if you don't want to use default OpenUDID.
 *
 *  @param value    string  Custom user ID
 *
 */
+ (void)setCustomUserID:(NSString *)userID;

/*!
 *  @abstract Get user ID.
 *
 */
+ (NSString *)getUserID;

/*!
 *  @abstract Enable debug logs to console.
 *
 *  @discussion
 *  Enabling this option will cause the Game Analytics wrapper to print additional debug information,
 *  such as the status of each submit to the server.
 *
 *  @note The default setting for this method is NO.
 *
 *  @param value @c YES to show debug logs, @c NO to omit.
 *
 */
+ (void)setDebugLogEnabled:(BOOL)value;

/*!
 *  @abstract Enable archive Data for offline usage.
 *
 *  @discussion
 *  If enabled data will be archived when an internet connection is not available.
 *  The number of events to be archived is limited.
 *  The next time an internet connection is available any archived data will be sent.
 *
 *  @note The default setting for this method is NO.
 *
 *  @param value @c YES to show debug logs, @c NO to omit.
 *
 */
+ (void)setArchiveDataEnabled:(BOOL)value;

/*!
 *  @abstract Set maximum number of events to be archived.
 *
 *  @note The default setting for this method is 100.
 *
 *  @param limit
 *
 */
+ (void)setArchiveDataLimit:(NSInteger)limit;

/*!
 *  @abstract Clear all pending events.
 *
 *  @discussion
 *  Use this call clear all pending events when archive Data for offline usage is enabled.
 *
 */
+ (void)clearEvents;

/*!
 *  @abstract Enable batch requests
 *
 *  @discussion
 *  Batching allows you to pass several log requests in a single HTTP request.
 *  Call sendBatch to send data.
 *
 *  @note The default setting for this method is NO.
 *
 *  @param value @c YES to enable batch requests, @c NO to send individual log requests.
 *
 */
+ (void)setBatchRequestsEnabled:(BOOL)value;

/*!
 *  @abstract Send new batch requests.
 *
 *  @discussion
 *  Use this call when BatchRequests is enabled only.
 *  The method returns TRUE if API server is reachable (user is online)
 *  or FALSE if user is offline and data wasn't sent.
 *
 */
+ (BOOL)sendBatch;

/*!
 *
 *  @abstract Submit While Roaming
 *
 *  @discussion
 *  If enabled, data will be submitted to the GameAnalytics servers
 *  while the mobile device is roaming (internet connection via carrier data network).
 *
 *  @note The default setting for this method is NO (enabled).
 *
 *  @param value @c YES to enable submiting while roaming, @c NO disable.
 *
 */
+ (void)setSubmitWhileRoaming:(BOOL)value;

@end