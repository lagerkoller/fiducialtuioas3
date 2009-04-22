package {
	/**
	 * @class FiducialTuioAS3.as
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
	
	import tuio.PropObject;
	import tuio.TUIO;
	import tuio.TUIOManager;
	
	/**
	 * Example implementation for a Flash Actionscript 3 swf that uses fiducials as interaction means.  
	 */
	 
	[SWF(frameRate="30", backgroundColor="0xF3F5F0")]
	public class FiducialTuioAS3 extends Sprite{
		
		/**
		 * Manager for Tuio object events.
		 */		
		public var tuioManager:TUIOManager;
		
		/**
		 * initializes Tuio listeners. TUIO is the standard Tuio socket listener and
		 * TUIOManager is responsible for the management of Tuio objects and the dispatching
		 * of Tuio object events. testFidu4() creates a listener for the reacTIVision 
		 * fiducial #4.
		 */
		public function FiducialTuioAS3(){
			TUIO.init(this, "localhost", 3000,"",true);
			//TUIOManager dispatches all the fiducial events
			tuioManager = new TUIOManager(this);
			this.addChild(tuioManager);
				
			testFidu4();
		}
		
		/**
		 * demoes how a listener object for the reacTIVision fiducial #4 can
		 * be implemented:
		 * 1. Tell the TUIOManager that it should dispatch events of fiducial #4
		 * to testProp.
		 * 2. testPropHandler is an example handler for fiducial (prop) events
		 * 3. testPropHandler must be added to stage
		 * 4. by applying testPropHandler to testProp all fiducial events for
		 * testProp (and thus for fiducial #4) will be dispatched to testPropHandler.
		 */
		public function testFidu4():void{
			var testProp:PropObject = tuioManager.getProp(4);
			var testPropHandler:TestFiducialHandler = new TestFiducialHandler();
			addChild(testPropHandler);
			testProp.addTUIOPropEventListeners(testPropHandler);
		}
	}
}