/**

 * ...

 * @author Julian Ridley Pryn

 */
package gameanalytics;

import haxe.Json;
import haxe.crypto.Md5;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.*;

class GameAnalytics {

	static var REQUIRED_FIELDS_USER : Array<Dynamic> = ["user_id", "session_id", "build"];
	static var REQUIRED_FIELDS_DESIGN : Array<Dynamic> = ["user_id", "session_id", "build", "event_id"];
	static var REQUIRED_FIELDS_BUSINESS : Array<Dynamic> = ["user_id", "session_id", "build", "event_id", "amount", "currency"];
	static var REQUIRED_FIELDS_ERROR : Array<Dynamic> = ["user_id", "session_id", "build", "message", "severity"];
	//public static const URL:String = "http://logging.gameanalytics.com";
	static public var URL : String = "http://api.gameanalytics.com";
	static public var PORT : Int = 80;
	/**

	 * The version of the REST-API, currently should be always set to “1”.

	 */
	static public var API_VERSION : String = "1";
	/**

	 * Setting DEBUG_MODE to true will cause the Game Analytics wrapper to print additional debug information, such as the status of each submit to the server.

	 */
	static public var DEBUG_MODE : Bool = false;
	/**

	 * When RUN_IN_EDITOR_PLAY_MODE is set to true the Game Analytics wrapper will not submit data to the server while playing the game in the editor.

	 */
	static public var RUN_IN_EDITOR_PLAY_MODE : Bool = false;
	static var public_key : String;
	static var private_key : String;
	static var build : String;
	static var user_id : String;
	static var session_id : String;
	static var initialized : Bool = false;
	static var event_que : Array<Array<Dynamic>> = new Array<Array<Dynamic>>();
	/**

	 * When a new game is added to your Game Analytics account, you will get a public key and a private key which are unique for that game.

	 * @param public_key:String - The public key is used directly in the URL for identifying the game.

	 * @param private_key:String - The private key is used for event authentication.

	 * @param build:String - Describes the current version of the game being played.

	 * @param user_id:String - A unique ID representing the user playing your game. 

	 * @param session_id:String A unique ID representing the current play session. If not used, a unique session-id is generated. 

	 */
	static public function init(public_key : String, private_key : String, build : String, user_id : String, session_id : String = null) : Void {
		GameAnalytics.public_key = public_key;
		GameAnalytics.private_key = private_key;
		GameAnalytics.build = build;
		GameAnalytics.user_id = user_id;
		GameAnalytics.session_id = session_id != (null) ? session_id : Date.now()+ "x" + (Std.int(Math.random() * 1000000) >> 0);
		if(GameAnalytics.public_key == null || GameAnalytics.public_key.length == 0) throw new GameAnalyticsError("'public key' cannot be empty or null.");
		if(GameAnalytics.private_key == null || GameAnalytics.private_key.length == 0) throw new GameAnalyticsError("'private key' cannot be empty or null.");
		if(GameAnalytics.build == null || GameAnalytics.build.length == 0) throw new GameAnalyticsError("'build' cannot be empty or null.");
		if(GameAnalytics.user_id == null || GameAnalytics.user_id.length == 0) throw new GameAnalyticsError("'user_id' cannot be empty or null.");
		if(GameAnalytics.session_id == null || GameAnalytics.session_id.length == 0) throw new GameAnalyticsError("'session_id' cannot be empty or null.");
		initialized = true;
		emptyEventQue();
	}

	/**

	 * Send a new event to Game Analytics.

	 * @param category:String - the category of the event. Either user, design, business or error

	 * @param ...events - Any number of events to send.

	 */
	static public function newEvent(category : String,events:Dynamic) : Void {
		if(!initialized)  {
			addToEventQue([category].concat(events));
			return;
		}
		
		if(category != EventCategory.USER && category != EventCategory.DESIGN && category != EventCategory.BUSINESS && category != EventCategory.ERROR) throw new GameAnalyticsError("Event category type '" + category + "' not recognized. Valid types are: " + [EventCategory.USER, EventCategory.DESIGN, EventCategory.BUSINESS, EventCategory.ERROR]);
		if(events.length == 0) events = [{ }];
		var req_fields : Array<Dynamic> = getRequiredFields(category);
		var event : Dynamic = events;
		if(Reflect.hasField(event,"build")) throw new GameAnalyticsError("Property 'build' is found on the event, but the name is reserved for Build name, which is set at init.");
		if(Reflect.hasField(event,"session_id")) throw new GameAnalyticsError("Property 'session_id' is found on the event, but the name is reserved for Session Id, which is set at init.");
		if(Reflect.hasField(event,"user_id")) throw new GameAnalyticsError("Property 'user_id' is found on the event, but the name is reserved for User Id, which is set at init.");
		event.build = build;
		event.session_id = session_id;
		event.user_id = user_id;
		var i : Int = 0;
		while(i < req_fields.length) {
			if(!Reflect.hasField(event,req_fields[i]))  {
				throw new GameAnalyticsError("Property '" + req_fields[i] + "' is required but not found on event with category type '" + category + "'.");
			}
			i++;
		}

		var request : URLRequest = new URLRequest(URL + "/" + API_VERSION + "/" + public_key + "/" + category);
		var event_json : String;
		try {
			event_json = Json.stringify(events);
		}
		catch(e : Dynamic) {
			throw new GameAnalyticsError("There was an error encoding the event as a JSON object. Error: " + e.message);
		}

		request.data = event_json;
		request.method = URLRequestMethod.POST;
		request.requestHeaders.push(new URLRequestHeader("Authorization", Md5.encode(event_json + private_key)));
		var requestor : URLLoader = new URLLoader();
		requestor.addEventListener(Event.COMPLETE, httpRequestComplete);
		requestor.addEventListener(IOErrorEvent.IO_ERROR, httpRequestIOError);
		requestor.addEventListener(SecurityErrorEvent.SECURITY_ERROR, httpRequestSecurityError);
		log("----");
		log("Sending Game Analytics event:" + ((RUN_IN_EDITOR_PLAY_MODE) ? " (Running in EDITOR PLAY MODE. Not Sending event)" : ""));
		log("	Url: " + request.url);
		log("	Header: " + Md5.encode(event_json + private_key));
		log("	Data: " + request.data);
		log("----");
		if(!RUN_IN_EDITOR_PLAY_MODE) requestor.load(request);
	}

	static function httpRequestComplete(event : Event) : Void {
		log("Game Analytics Request Complete: " + event.target.data);
	}

	static function httpRequestIOError(error : IOErrorEvent) : Void {
		log("There was an error with the Game Analytics Server. " + error.text);
	}

	static function httpRequestSecurityError(error : SecurityErrorEvent) : Void {
		log("There was an error with the Game Analytics Server. " + error.text);
	}

	static function addToEventQue(arg : Array<Dynamic>) : Void {
		event_que.push(arg);
	}

	static function emptyEventQue() : Void {
		var i : Int = 0;
		while (i < event_que.length) {
			Reflect.callMethod(newEvent, newEvent, event_que[i]);
			//newEvent.apply(null, event_que[i]);
			i++;
		}
	}

	/**

	 * Returns an Array of string, which represents the required values of a event of the given category.

	 */
	static function getRequiredFields(category : String) : Array<Dynamic> {
		switch(category) {
		case EventCategory.USER:
			return REQUIRED_FIELDS_USER;
		case EventCategory.DESIGN:
			return REQUIRED_FIELDS_DESIGN;
		case EventCategory.BUSINESS:
			return REQUIRED_FIELDS_BUSINESS;
		case EventCategory.ERROR:
			return REQUIRED_FIELDS_ERROR;
		default:
			throw new GameAnalyticsError("No such category: " + category);
			return [];
		}
	}

	static public function log(args:Dynamic) : Void {
		if(DEBUG_MODE) trace(args);
	}

}

