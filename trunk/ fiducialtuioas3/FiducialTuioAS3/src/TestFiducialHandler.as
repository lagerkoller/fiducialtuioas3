package{
	/**
	 * @class TestFiducialHandler.as
	 * @namespace 
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
	import flash.events.IOErrorEvent;
	
	import tuio.PropEvent;
	import tuio.TUIOPropInterface;
	
	/**
	 * TestFiducialHandler shows how a Handler for fiducial events can be implemented in this
	 * framework.
	 * 
	 * The handler must implement the interface TUIOPropInterface in order to work with TuioManager
	 * and PropEvents.
	 * 
	 * This example will just draw a bigger circle at the position of the Tuio object. Another little 
	 * circle will be added on top of the bigger circle in order to show the rotation a Tuio object.
	 * 
	 */
	public class TestFiducialHandler extends Sprite implements TUIOPropInterface{
		private var testItem:Sprite;
		
		/**
		 * rotation in Flash starts at -90 degrees. The simulator starts at 0
		 * degrees. This variable represents that difference.
		 */
		private var ROTATION_PHASE_SHIFT:Number = 90;
		
		/**
		 * BOUNCE_THRESHOLD contains the minimum distance that a fiducial must be
		 * moved on the table in order that the object is being moved in this handler.
		 * This is necessary because reacTIVision is constantly sending move events,
		 * which causes the graphics on the table to shiver. This is not necessary in
		 * the simulator. However, for completeness it is included here.
		 */
		private var BOUNCE_THRESHOLD:Number = 10;
		private var lastXVal:Number = 0;
		private var lastYVal:Number = 0;
		
		public function TestFiducialHandler(){
		}
		
		private function ioError(e:IOErrorEvent):void{
			trace(this, "error while loading: "+e.target);
		}
		
		/**
		 * will be executed everytime a fiducial to which this handler is applied is being
		 * added on the table/simulator.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onAdd(evt:PropEvent){
			testItem = new Sprite();
			testItem.graphics.beginFill(0xF77503);
			testItem.graphics.drawCircle(0,0, 25);
			testItem.graphics.endFill();
			var secondTestItem:Sprite = new Sprite();
			secondTestItem.graphics.beginFill(0x03A8A2);
			secondTestItem.graphics.drawCircle(0,0, 5);
			secondTestItem.graphics.endFill();
			secondTestItem.x = 32;
			secondTestItem.y = 0;
			testItem.addChild(secondTestItem);
			addChild(testItem);
			
			testItem.x = evt.xpos;
			testItem.y = evt.ypos;
			testItem.rotation = evt.angle*360/(2*Math.PI)+ROTATION_PHASE_SHIFT
		}
		
		/**
		 * will be executed everytime a fiducial to which this handler is applied is being
		 * removed from the table/simulator.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onRemove(evt:PropEvent)
		{
			try{
				removeChild(testItem);
			}catch(error:Error){
				trace(this, "error when trying to remove:", error.message);
			}
			testItem = null;
		}
		
		/**
		 * will be executed everytime a fiducial to which this handler is applied is being
		 * moved on the table / in the simulator.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onMove(evt:PropEvent){
			
			//prevent shivering of object on the actual table:
			//object may only be moved if a certain movement 
			//threshold has been exceeded (try without on a mt
			//table and you'll see)
			var distance:Number = Math.sqrt((int(evt.xpos) - lastXVal)*(int(evt.xpos) - lastXVal) +  (int(evt.ypos) - lastYVal) * (int(evt.ypos) - lastYVal))
			
			if(distance > BOUNCE_THRESHOLD){
				testItem.x = int(evt.xpos);
				testItem.y = int(evt.ypos);
				lastXVal = int(evt.xpos);
				lastYVal = int(evt.ypos);
			}
		}
		
		/**
		 * will be executed everytime a fiducial to which this handler is applied is being
		 * rotated on the table / in the simulator.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onRotate(evt:PropEvent)
		{
			testItem.rotation = evt.angle*360/(2*Math.PI)+ROTATION_PHASE_SHIFT;
		}
		
		/**
		 * standard Tuio property that is not used in this handler.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onMoveVelocety(evt:PropEvent){}
		
		/**
		 * standard Tuio property that is not used in this handler.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onRotateVelocety(evt:PropEvent){}
		
		/**
		 * standard Tuio property that is not used in this handler.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onMoveAccel(evt:PropEvent){}
		
		/**
		 * standard Tuio property that is not used in this handler.   
		 * (This is a method from TUIOPropInterface that must be implemented in a Tuio object 
		 * handler.)
		 */
		public function onRotateAccel(evt:PropEvent){}
		
	}
}