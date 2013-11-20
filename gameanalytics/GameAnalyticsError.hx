/**

 * ...

 * @author Julian Ridley Pryn

 */
package gameanalytics;

class GameAnalyticsError {

	public var message:String;
	public var id:Int;
	public function new(message : String = "", id : Int = 0) {
		this.message = message;
		this.id = id;
	}

}

