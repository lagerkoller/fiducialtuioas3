package tuio{
	/**
	 * @class PropEvent.as
	 * @namespace tuio
	 * @author Frederic Friess and Johannes Luderschmidt (http://johannesluderschmidt.de/tuio-actionscript-3-open-source-fiducial-object-interaction-implementation/552/)
	 * NOTE: Creative Commons Attribution 3.0 License (http://creativecommons.org/licenses/by/3.0/)
	 * You are free: to Share — to copy, distribute and transmit the work
	 * You are free: to Remix — to adapt the work
	 * Under the following conditions: 
	 * Attribution. You must attribute the work in the manner specified by the author or licensor 
	 * (but not in any way that suggests that they endorse you or your use of the work).
	 * 
	 * Feel free to download and modify the code for any use as long as our name is in there somewhere.
	 * You may also use it in comercial projects without any licensing fees. 
	 */
	 
	import flash.events.Event;
	
	/**
	 * contains events that are dispatched when there is a modification of Tuio objects
	 * is taking place on the table. 
	 */
	public class PropEvent extends Event {
		public static const SET_PROP:String = "set_prop";
		public static const ALIVE_PROP:String = "alive_prop";
		
		public static const ADD_PROP:String = "add_prop";
		//public static const CHANGE_PROP:String = "change_prop";
		public static const REMOVE_PROP:String = "remove_prop";
		
		public static const MOVE_PROP:String = "move_prop";
		public static const ROTATE_PROP:String = "rotate_prop";
		public static const VELOCETY_MOVE_PROP:String = "velocety_move_prop";
		public static const VELOCETY_ROTATE_PROP:String = "velocety_rotate_prop";
		public static const ACCEL_MOVE_PROP:String = "velocety_move_prop";
		public static const ACCEL_ROTATE_PROP:String = "velocety_rotate_prop";
						
		public var s_id:Number;
		public var f_id:Number;
		public var xpos:Number;
		public var ypos:Number;
		public var angle:Number;
		public var xspeed:Number;
		public var yspeed:Number;
		public var rspeed:Number;
		public var maccel:Number;
		public var raccel:Number;
		public var speed:Number;
		
		public function PropEvent(type:String,
								  sID:Number=-1, id:Number=-1, x:Number=0, y:Number=0, a:Number=0,
								  X:Number=0, Y:Number=0, A:Number=0, m:Number=0, r:Number=0, speed:Number=0,
								  bubbles:Boolean=true, cancelable:Boolean=true) {
			this.s_id = sID;
			this.f_id = id;
			this.xpos = x;
			this.ypos = y;
			this.angle = a;
			this.xspeed = X;
			this.yspeed = Y;
			this.rspeed = A;
			this.maccel = m;
			this.raccel = r;
			this.speed = speed;
			super(type,bubbles,cancelable);
			
		}
	}
}