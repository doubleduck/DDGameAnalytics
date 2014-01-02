package co.doubleduck;

import flash.Lib;
#if android
import openfl.utils.JNI;
#elseif ios

#else
import gameanalytics.EventCategory;
import gameanalytics.GameAnalytics;
#end


@:allow(co.doubleduck.DDGameAnalytics) class DDGameAnalytics 
{
	
	// Android JNI Handlers
	#if android
	static var jni_init_event:Dynamic;
	static var jni_design_event:Dynamic;
	static var jni_business_event:Dynamic;
	static var jni_error_event:Dynamic;
	#end

	#if ios
	#elseif android
	#else
	static public var defaultUserId:String = "desktopUser";
	#end
	static public var enabled:Bool = true;

	public static function designEvent(eventId:String, eventValue:Float, area:String = ""):Void{
		if (!enabled) {
			return;
		}
		#if android
			if (jni_design_event== null) {

				jni_design_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "designEvent", "(Ljava/lang/String;FLjava/lang/String;)V");

			}
			jni_design_event(eventId, eventValue, area);
		#elseif ios
			ga_design_event(eventId, eventValue, area);
		#else

			GameAnalytics.newEvent(EventCategory.DESIGN, {event_id: eventId, value: eventValue, area: area});

		#end


	}

	public static function businessEvent(eventId:String, currency:String, amount:Int, area:String = ""):Void{
		if (!enabled) {
			return;
		}
		#if android
			if (jni_business_event== null) {

				jni_business_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "businessEvent", "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V");

			}
			jni_business_event(eventId, currency, amount, area);
		#elseif ios
			trace("ios business event: id = " + eventId + " currency = " + currency + " amount = " + amount);
			ga_business_event(eventId, currency, amount, area);
		#else

			GameAnalytics.newEvent(EventCategory.BUSINESS, {event_id: eventId, currency: currency, amount: amount, area: area});

		#end

	}
	
	public static function errorEvent(message:String, severity:String, area:String = ""):Void {
		if (!enabled) {
			return;
		}
		#if android
			if (jni_error_event == null) {
				jni_error_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "errorEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			}
			jni_error_event(message, severity, area);
			
		#elseif ios
			ga_error_event(message, severity, area);
		#else
			GameAnalytics.newEvent(EventCategory.ERROR, { severity: severity, message:message, area:area } );
		#end
	}

	
	public static function init(appID:String, appSecret:String, version:String = "1.0", platform:String = "desktop") {
		if (!enabled) {
			return;
		}
		#if ios
		ga_init(appID, appSecret, version);
		#elseif android
			if (jni_init_event == null) {
				jni_init_event = JNI.createStaticMethod ("co/doubleduck/extensions/GameAnalyticsExt", "initGA", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			}
			jni_init_event(appID, appSecret, version);
		#else
			GameAnalytics.DEBUG_MODE = true;
			GameAnalytics.init(appID, appSecret, version, defaultUserId);
			GameAnalytics.newEvent(EventCategory.USER, {platform: platform});
		#end
	}

	
	#if ios
	static var ga_init            = Lib.load("ddgameanalytics","ga_init",3);
	static var ga_design_event    = Lib.load("ddgameanalytics", "ga_design_event", 3);
	static var ga_error_event     = Lib.load("ddgameanalytics", "ga_error_event", 3);
	static var ga_business_event  = Lib.load("ddgameanalytics","ga_business_event", 4);
	#end
	
	
}
