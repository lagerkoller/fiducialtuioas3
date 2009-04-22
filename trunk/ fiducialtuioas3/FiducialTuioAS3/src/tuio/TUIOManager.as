package tuio{
	/**
	 * @class TUIOManager.as
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
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer; 
	 
	/**
	 * This class takes care of Tuio object events from the class TUIO.
	 * 
	 * In order to use it, it must be added to the Flash application after TUIO has been initialized:
	 * TUIO.init(this, "localhost", 3000,"",true);
	 * tuioManager = new TUIOManager(this);
	 * this.addChild(tuioManager);
	 * 
	 * In order to work properly it must be added to stage.
	 * 
	 * TUIOManager just dispatches Tuio object events (in the so called PropEvent class) to the handlers.
	 * Amongst others events are add, remove, move and rotate. 
	 * 
	 * add, move and rotate work just as you would suppose them to work and the event is simply dispatched.
	 * However, remove behaves differently: After TUIO has not found a certain fiducial anymore amongst 
	 * objects on the table, it will simply removed from TUIO's object list. TUIOManager however has a bit 
	 * more 'intelligence': it checks periodly for the presence of a fiducial and dispatches the remove event 
	 * after a certain threshold in order to prevent that there has been a tracking failure by reacTIVision, 
	 * which has not found the fiducial although it is still present on the table. 
	 *  
	 * Usually, it should not be necessary to play around with this class.
	 */
	public class TUIOManager extends Sprite{
		
		//the simulator sends object alive information only periodly around
		//every second. Play around with REMOVE_THRESHOLD in your setup to find 
		//out the most appropriate period. 
		private var REMOVE_THRESHOLD:Number = 1000;
				
		private var propObjectDict:Dictionary;
		private var aliveDict:Dictionary;
		private var removeChecker:Timer;
		
		public function TUIOManager(stageSprite:Sprite){
			
			propObjectDict = new Dictionary();
			aliveDict = new Dictionary();
			removeChecker = new Timer(REMOVE_THRESHOLD, 0);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdd);
			
			removeChecker.addEventListener(TimerEvent.TIMER, timerHandler);
			removeChecker.start();
			
		}
		
		/**
		 * is called when TUIOManager is being added to stage.
		 */
		private function onStageAdd(evt:Event=null):void{
			var tuioConectedCallbacks:Array =  new Array();
			TUIO.evtDispatcher.addEventListener(PropEvent.SET_PROP, onPropSet);
			TUIO.evtDispatcher.addEventListener(PropEvent.ALIVE_PROP, onPropAlive);
		}
		
		
		/**
		 * checks periodly which fiducials are still present on the table. This depends on
		 * the set of objects that have been included in the last Tuio alive message from
		 * the tracking system (e.g. reacTIVsion or TuioSimulator).
		 */
		private function timerHandler(evt:TimerEvent):void{
			
			//save prop states before the modification
			var preAliveArray:Array = new Array();
			for (var f_id in propObjectDict) {
				//trace(f_id+"----------")
				var prop:PropObject = PropObject(propObjectDict[f_id]);
				if(prop.isActiv){
					preAliveArray.push(f_id);
				}else{
					preAliveArray.push(0);
				}
			}
			
			//set all f_ids on 0
			var tempArray:Array = new Array();
			for (var f_id in propObjectDict) {
				tempArray.push(0);
			}
			
			//deactivate all.
			for (var f_id in propObjectDict) {
				var prop:PropObject = PropObject(propObjectDict[f_id]); 
				prop.isActiv = false;
			}
			
		
			//reactivate alive fidus
			for (var f_id in propObjectDict) {
				var prop:PropObject = PropObject(propObjectDict[f_id]); 
				var s_id = prop.s_id;
				for (var alive_s_id in aliveDict){
					if(s_id == alive_s_id){
						prop.isActiv = true;
					}
				}
			}	
			aliveDict = new Dictionary();
			
			
			//save prop states after the modification
			var postAliveArray:Array = new Array();
			for (var f_id in propObjectDict) {
				//trace(f_id+"----------")
				var prop:PropObject = PropObject(propObjectDict[f_id]);
				if(prop.isActiv){
					postAliveArray.push(f_id);
				}else{
					postAliveArray.push(0);
				}
			}
			
			//report deactivated fidus
			for (var i=0; i < postAliveArray.length; i++){
				if( (preAliveArray[i] != postAliveArray[i]) && (postAliveArray[i] == 0)){
					var f_id = preAliveArray[i];
					var prop:PropObject = PropObject(propObjectDict[f_id]);
					prop.dispatchEvent(new PropEvent(PropEvent.REMOVE_PROP, prop.s_id,prop.f_id, prop.xpos, prop.ypos, prop.angle, prop.xspeed, prop.yspeed, prop.rspeed, prop.maccel, prop.raccel, prop.speed, true, true));
				}
			}
		}
		


		public function getProp(id:Number):PropObject{
			if (this.propObjectDict[id] == null){
				
				var evt:PropEvent = new PropEvent(PropEvent.SET_PROP,-1,id);
				propObjectDict[id] = createProp(evt);
			}
			return this.propObjectDict[id];	
		}
		
		
		private function createProp(evt:PropEvent):PropObject{
			//var spr:PropView = new PropView();
			var tmpProp:PropObject = new PropObject(evt.s_id,evt.f_id,evt.xpos,evt.ypos,evt.angle,evt.xspeed,evt.yspeed,evt.rspeed,evt.maccel,evt.raccel,evt.speed);
			return tmpProp;
		}
	
		
		private function onPropSet(evt:PropEvent):void{
			//trace("set ID\t"+ evt.f_id +"");
			
			if (propObjectDict[evt.f_id] == null){
				propObjectDict[evt.f_id] = createProp(evt);
			}
			
			
			var prop:PropObject = this.getProp(evt.f_id);
			prop.set_s_ID(evt.s_id);
			
			
			//check if it has just been set
			if (!prop.isActiv){
				prop.dispatchEvent(new PropEvent(PropEvent.ADD_PROP, evt.s_id,evt.f_id, evt.xpos, evt.ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel, evt.raccel, evt.speed, true, true));
			}
			prop.isActiv = true;
			
			
			var s_id:Number;
			var f_id:Number;
//			var p:Point = posSmooth.smooth(new Point(evt.xpos, evt.ypos));
			var p:Point = new Point(evt.xpos, evt.ypos);	
			var xpos:Number = p.x;
			var ypos:Number = p.y;

			prop.dispatchEvent(new PropEvent(PropEvent.MOVE_PROP,			evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
			prop.dispatchEvent(new PropEvent(PropEvent.ROTATE_PROP, 		evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
			prop.dispatchEvent(new PropEvent(PropEvent.VELOCETY_MOVE_PROP, 	evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
			prop.dispatchEvent(new PropEvent(PropEvent.VELOCETY_ROTATE_PROP,evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
			prop.dispatchEvent(new PropEvent(PropEvent.ACCEL_MOVE_PROP, 	evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
			prop.dispatchEvent(new PropEvent(PropEvent.ACCEL_ROTATE_PROP, 	evt.s_id, evt.f_id, xpos, ypos, evt.angle, evt.xspeed, evt.yspeed, evt.rspeed, evt.maccel,evt.raccel,evt.speed,true,true));
		}
		
		
		
		private function onPropAlive(evt:PropEvent):void{
			var s_id:Number = evt.s_id;
			aliveDict[s_id] = true;
		}
	}
}