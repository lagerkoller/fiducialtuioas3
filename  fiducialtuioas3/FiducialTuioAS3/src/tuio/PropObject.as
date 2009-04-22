package tuio{
	/**
	 * @class PropObject.as
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
	
	import flash.display.Sprite;
	
	
	public class PropObject extends Sprite{

		public var isActiv:Boolean; 
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
		
		public var handler:TUIOPropInterface;
		
		
		public function PropObject(s_id:Number, id:Number, xpos:Number=0, xpos:Number=0, a:Number=0,
								  X:Number=0, Y:Number=0, A:Number=0, m:Number=0, r:Number=0, speed:Number=0){
			//trace("create fid with id:"+id);
			this.isActiv = false; 
			this.s_id = s_id;
			this.f_id = id;
			this.xpos = xpos;
			this.xpos = xpos;
			this.angle = a;
			this.xspeed = X;
			this.yspeed = Y;
			this.rspeed = A;
			this.maccel = m;
			this.raccel = r;
			this.speed = speed;
		}
		
		public function set_s_ID(_s_id:Number){
			this.s_id = _s_id;
		}
		
		public function addTUIOPropEventListeners(_handler:TUIOPropInterface):void{
			
			this.handler = _handler;
			this.addEventListener(PropEvent.ADD_PROP, this.handler.onAdd);
			this.addEventListener(PropEvent.REMOVE_PROP, this.handler.onRemove);
			this.addEventListener(PropEvent.MOVE_PROP, this.handler.onMove);
			this.addEventListener(PropEvent.ROTATE_PROP, this.handler.onRotate);
			this.addEventListener(PropEvent.VELOCETY_MOVE_PROP, this.handler.onMoveVelocety);
			this.addEventListener(PropEvent.VELOCETY_ROTATE_PROP, this.handler.onRotateVelocety);
			this.addEventListener(PropEvent.ACCEL_MOVE_PROP, this.handler.onMoveAccel);
			this.addEventListener(PropEvent.ACCEL_ROTATE_PROP, this.handler.onRotateAccel);
			
		}
		
		public function getTUIOPropEventListeners():TUIOPropInterface{
			return this.handler;
		}
	}
}