package tuio 
{
	import tuio.TUIO;
	import flash.display.Sprite;

	public class TUIOCursor extends Sprite{
		public function TUIOCursor(debugText:String,color:int,pressure:Number,thewidth:Number, theheight:Number)
		{
			super();
			if(TUIO.bDebug) { 
				graphics.lineStyle( 2, 0xb0b0b0);
				graphics.drawCircle(0 ,0, 10);
			}else{
				//default cursor look (no debug mode)
				graphics.lineStyle( 10, 0xb0b0b0);
				graphics.drawCircle(0 ,0, 20);
			}
		}		
	}
}