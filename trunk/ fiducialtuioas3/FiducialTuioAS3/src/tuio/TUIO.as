package tuio 
{		
	
	//import app.core.element.FocusButton;import flash.display.DisplayObject;	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	//import app.core.element.Wrapper;

	public class TUIO
	{		
		private static var FLOSCSocket:XMLSocket;		
		private static var FLOSCSocketHost:String;			
		private static var FLOSCSocketPort:Number;	
				
		public static var thestage:Stage;
		public static var blobObjectArray:Array;
		public static var bDebug:Boolean;
		
		private static var idArray:Array; 				
		private static var debugText:TextField;		
		private static var xmlPlaybackURL:String; 
		private static var xmlPlaybackLoader:URLLoader;
		private static var playbackXML:XML;
		private static var recordedXML:XML;		
		private static var bInitialized:Boolean;
		private static var bRecording:Boolean;		
		private static var bPlayback:Boolean;	
		private static var myService:NetConnection;
    	private static var responder:Responder;
		private static var eventListeners:Array;
		
		private static var LONG_PRESS_TIME:Number = 4000;
		
		public static var evtDispatcher:EventDispatcher;
		
		private static var _connected:Boolean = false;
    	private static var _conectedCallbacks:Array;
    	
	public static function init (s:DisplayObjectContainer, host:String, port:Number, debugXMLFile:String, dbug:Boolean = true, conectedCallbacks:Array=null):void
	{
			if(bInitialized){return;}	
			
			thestage = s.stage;
			thestage.align = "TL";
			thestage.scaleMode = "noScale";				
			FLOSCSocketHost=host;			
			FLOSCSocketPort=port;					       
			myService = new NetConnection();	
			
			xmlPlaybackURL = debugXMLFile;
			bDebug = dbug;				
			bInitialized = true;
			bRecording = false;		
			bPlayback = false;									
			blobObjectArray = new Array();
			idArray = new Array();
			
			_conectedCallbacks = conectedCallbacks;
				
			eventListeners = new Array();
			evtDispatcher = new EventDispatcher();
			
			/*
			var t:Timer = new Timer(2000);
			t.addEventListener(TimerEvent.TIMER, function(){
						blobObjectArray = new Array();
						trace("Delete "+blobObjectArray);
					});
			t.start();
			*/
			
			try
			{
				FLOSCSocket = new XMLSocket();	
				FLOSCSocket.addEventListener(Event.CLOSE, closeHandler);
				FLOSCSocket.addEventListener(Event.CONNECT, connectHandler);
				FLOSCSocket.addEventListener(DataEvent.DATA, dataHandler);
				FLOSCSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				FLOSCSocket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				FLOSCSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);	
				FLOSCSocket.connect(host, port);				
			} 
			catch(e:Error){trace("could not establish FLOSC connection")}			
			if(bDebug)
			{
				activateDebugMode();				
			}else{		
				recordedXML = new XML();	
				recordedXML = <OSCPackets></OSCPackets>;
				bRecording = false;			
			}			
		}
		
		public static function addEventListener(e:EventDispatcher) : void
		{
			eventListeners.push(e);
		}
		
		public static function processMessage(msg:XML) : void
		{
			var node:XML;
			var timeBefore:Number = new Date().getTime();		
			
			for each(node in msg.MESSAGE)
			{
				
				if(node.ARGUMENT[0])
				{
					var type:String;
		
				
					if(node.@NAME == "/tuio/2Dobj")
					{
						type = node.ARGUMENT[0].@VALUE;		
						if(type == "set")
						{
							var s_id:Number;
							var f_id:Number;
							var xpos:Number;
							var ypos:Number;
							var angle:Number;
							var xspeed:Number;
							var yspeed:Number;
							var rspeed:Number;
							var maccel:Number;
							var raccel:Number;
							var speed:Number;
							
							try
							{	
								s_id = node.ARGUMENT[1].@VALUE;
								f_id = Number(node.ARGUMENT[2].@VALUE);
								xpos = Number(node.ARGUMENT[3].@VALUE)* thestage.stageWidth;
								ypos = Number(node.ARGUMENT[4].@VALUE) * thestage.stageHeight;				
								angle = Number(node.ARGUMENT[5].@VALUE);
								xspeed = Number(node.ARGUMENT[6].@VALUE);
								yspeed = Number(node.ARGUMENT[7].@VALUE);
								rspeed = Number(node.ARGUMENT[8].@VALUE);
								maccel = Number(node.ARGUMENT[9].@VALUE);
								raccel = Number(node.ARGUMENT[10].@VALUE);	
								speed = Math.sqrt((xspeed*xspeed)+(yspeed*yspeed));
							
								
								evtDispatcher.dispatchEvent(new PropEvent(PropEvent.SET_PROP,s_id,f_id,xpos,ypos,angle,xspeed,yspeed,rspeed,maccel,raccel,speed,true,true));
								
							} catch (e:Error){
								trace("Error Objekt parsing");
							}						
						}
						// this is to check if the marker is still there
						else if (type=="alive"){
							for each(var arg:XML in node.ARGUMENT){
								var sID:Number = arg.@VALUE;
								evtDispatcher.dispatchEvent(new PropEvent(PropEvent.ALIVE_PROP,sID));
							}
						}
					}
					
					//--------Touch-------
					else if(node.@NAME == "/tuio/2Dcur"){
						
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set"){
							
							var id:int;	
							var x:Number;
							var y:Number;
							var X:Number;
							var Y:Number;
							var m:Number;
							var wd:Number = 0;
							var ht:Number = 0;
							try {
								id = node.ARGUMENT[1].@VALUE;
								x = Number(node.ARGUMENT[2].@VALUE) * thestage.stageWidth;
								y = Number(node.ARGUMENT[3].@VALUE) *  thestage.stageHeight;
								X = Number(node.ARGUMENT[4].@VALUE);
								Y = Number(node.ARGUMENT[5].@VALUE);
								m = Number(node.ARGUMENT[6].@VALUE);
								
								if(node.ARGUMENT[7])
									wd = Number(node.ARGUMENT[7].@VALUE) * thestage.stageWidth;							
								if(node.ARGUMENT[8])
									ht = Number(node.ARGUMENT[8].@VALUE) * thestage.stageHeight;
							} catch (e:Error){
								trace("Error parsing");
							}
							var stagePoint:Point = new Point(x,y);
							
							
								var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);
								var dobj:Object = null;
							
								if(displayObjArray.length > 0)								
									dobj = displayObjArray[displayObjArray.length-1];	
																				
								var tuioobj : Object = getObjectById(id);
								if(tuioobj == null){
									//trace("TouchEvent x: "+stagePoint.x+" y: "+stagePoint.y);
									tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, wd, ht, dobj);
									thestage.addChild(tuioobj.spr);								
									blobObjectArray.push(tuioobj);
									tuioobj.notifyCreated();
								}else{
									tuioobj.spr.x = x;
									tuioobj.spr.y = y;
									tuioobj.oldX = tuioobj.x;
									tuioobj.oldY = tuioobj.y;
									tuioobj.x = x;
									tuioobj.y = y;
									tuioobj.width = wd;
									tuioobj.height = ht;
									tuioobj.area = wd * ht;								
									tuioobj.dX = X;
									tuioobj.dY = Y;
									tuioobj.setObjOver(dobj);
									
									var d:Date = new Date();																
									if(!( int(Y*1000) == 0 && int(Y*1000) == 0)){
										tuioobj.notifyMoved();
									}
									
									if( int(Y*250) == 0 && int(Y*250) == 0) {
										if(Math.abs(d.time - tuioobj.lastModifiedTime) > LONG_PRESS_TIME){
											for(var ndx:int=0; ndx<eventListeners.length; ndx++){
												eventListeners[ndx].dispatchEvent(tuioobj.getTouchEvent(TouchEvent.LONG_PRESS));
											}
											tuioobj.lastModifiedTime = d.time;																		
										}
									}
								}
								try{
									if(tuioobj.obj && tuioobj.obj.parent){					
										var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
										tuioobj.obj.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, ((int)(x)), ((int)(y)), ((int)(localPoint.x)), ((int)(localPoint.y)), tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dcur", id, 0, 0));
									}
								} catch (e:Error){
									trace("(" + e + ") Dispatch event failed " + tuioobj.ID);
								}
							}
						
						if(type == "alive"){
							//set all elements initially to not existing
							for each (var obj1:TUIOObject in blobObjectArray)
							{
								obj1.isAlive = false;
							}
							//set all elements that are contained within the alive message to existing
							for each(var aliveItem:XML in node.ARGUMENT)
							{
								if(aliveItem.@TYPE == "i"){
									var tmpTuioObj:TUIOObject = getObjectById(aliveItem.@VALUE);
									
									
									if (tmpTuioObj){
										//hotspot ignore
										var p:Point = new Point(tmpTuioObj.x,tmpTuioObj.y);
										//trace("isAlive "+aliveItem.@VALUE+" pos: "+p);
										tmpTuioObj.isAlive = true;
									}
								}
							}
						}
					}
				}
			}
			if (bDebug){
				debugText.text = "";
			}
			
			for (var i:Number=0; i<blobObjectArray.length; i++ ){	
				if(!blobObjectArray[i].isAlive){
					blobObjectArray[i].kill();
					thestage.removeChild(blobObjectArray[i].spr);
					blobObjectArray.splice(i, 1);
					i--;

				}else{
					if(bDebug){
						var tmp:Number = (int(blobObjectArray[i].area)/-100000);
						debugText.appendText("  " + (i + 1) +" - " +blobObjectArray[i].ID +
											 "  X:" + int(blobObjectArray[i].x) + 
											 "  Y:" + int(blobObjectArray[i].y) +
											 "  A:" + int(tmp) + "  \n");						
						debugText.x = thestage.stageWidth-200;
						debugText.y = 25;
						
						
						var deb:TextField = new TextField();
						deb.x = -40;
						try{
							Sprite(blobObjectArray[i].spr).removeChildAt(0);
						}catch (e:Error){}
						Sprite(blobObjectArray[i].spr).addChild(deb);
						deb.text = "ID:"+int(blobObjectArray[i].ID)+"\nX: "+int(blobObjectArray[i].x)+"\nY: "+int(blobObjectArray[i].y);
						
						var whiteTextFormat:TextFormat = new TextFormat();
						whiteTextFormat.color = 0xb0b0b0;
						deb.setTextFormat(whiteTextFormat);
					}
				}
			}
		}
		
		
		public static function listenForObject(id:Number, reciever:Object):void
		{
			var tmpObj:TUIOObject = getObjectById(id);			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}
		}
		
		public static function getObjectById(id:Number): TUIOObject
		{
			if(id == 0)
			{
				return new TUIOObject("mouse", 0, thestage.mouseX, thestage.mouseY, 0, 0, 0, 0, 10, 10, null);
			}
			for(var i:Number=0; i<blobObjectArray.length; i++)
			{
				if(blobObjectArray[i].ID == id)
				{
					return blobObjectArray[i];
				}
			}
			return null;
		}
		
		
        private static function activateDebugMode():void 
        {
			
  				var format:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
				debugText = new TextField();       
				debugText.defaultTextFormat = format;
				debugText.autoSize = TextFieldAutoSize.LEFT;
				debugText.background = true;	
				debugText.backgroundColor = 0x000000;	
				debugText.border = true;	
				debugText.borderColor = 0x333333;	
				thestage.addChild( debugText );						
				thestage.setChildIndex(debugText, thestage.numChildren-1);	
		
				recordedXML = <OSCPackets></OSCPackets>;	
			
        }	
        
        private static function xmlPlaybackLoaded(evt:Event) : void
        {
			trace("Playing from XML file...");
			playbackXML = new XML(xmlPlaybackLoader.data);			
		}
		
		private static function frameUpdate(evt:Event) : void
		{
			if(playbackXML && playbackXML.OSCPACKET && playbackXML.OSCPACKET[0])
			{
				processMessage(playbackXML.OSCPACKET[0]);
				delete playbackXML.OSCPACKET[0];
			}
		}		
		
		private static function toggleDebug(e:Event) : void
		{ 
			if(!bDebug){
			bDebug=true;		
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.parent.alpha=0.85;
			}
			else{
			bDebug=false;
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.parent.alpha=0.5;	
			}
		}
		
		public static function startSocket() : void
		{ 	
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
		}
		public static function stopSocket() : void
		{ 	
			FLOSCSocket.close();
		}
		private static function toggleRecord(e:Event) : void
		{ 	
			var responder : Responder = new Responder(saveSession_Result, onFault);
			
			if(!bRecording){
			bRecording = true;
			e.target.parent.alpha=1.0;			
			trace(e.target.parent);
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record ON ----------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			myService.call("touchlib.clearSession", responder);
			}
			else{
			bRecording = false;
			e.target.parent.alpha=0.25;
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record OFF ---------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			myService.call("touchlib.saveSession", responder, recordedXML.toXMLString());
			trace('-------------------------------------- Recording END ------------------------------------------------');
			}
		}
			
		private static function saveSession_Result(result:String) : void
		{	
			debugText.x = debugText.y = 5;
			debugText.text = result;
		}
			
		private static function togglePlayback(e:Event) : void
		{ 	
			if(xmlPlaybackURL != "")
				 {	
				 	xmlPlaybackLoader = new URLLoader();
					xmlPlaybackLoader.addEventListener("complete", xmlPlaybackLoaded);
					xmlPlaybackLoader.load(new URLRequest(xmlPlaybackURL));			
					thestage.addEventListener(Event.ENTER_FRAME, frameUpdate);
				 }
		}
		
        private static function dataHandler(event:DataEvent):void 
        {           			
			if(bRecording)
			recordedXML.appendChild( XML(event.data) );			
			processMessage(XML(event.data));
        }     			
        private static function onFault(e:Event ) : void
		{
//			trace("There was a problem: " + e.type);
			_connected = false;
		}
     	private static function connectHandler(event:Event):void 
     	{
//            trace("connectHandler: " + event);
            _connected = true;
            for each(var callbackMethod:Function in _conectedCallbacks){
            	callbackMethod();
            }
        }       
        private static function ioErrorHandler(event:IOErrorEvent):void 
        {
//            trace("ioErrorHandler: " + event);
            _connected = false;
        }
        private static function progressHandler(event:ProgressEvent):void 
        {
//           	trace("Debug XML Loading..." + event.bytesLoaded + " out of: " + event.bytesTotal);
        }
        private static function closeHandler(event:Event):void 
        {
//            trace("closeHandler: " + event);
            _connected = false;
        }
        private static function securityErrorHandler(event:SecurityErrorEvent):void 
        {
//            trace("securityErrorHandler: " + event);
			_connected = false;
        }  
        public static function get connected():Boolean{
        	return _connected;
        }
    }
}