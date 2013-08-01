package
{
	import citrus.core.starling.StarlingCitrusEngine;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="1280", height="720", frameRate="60", backgroundColor="#ffffff")]
	public class Main extends StarlingCitrusEngine
	{					
		public function Main()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			trace(stage.stageHeight + " x " + stage.stageWidth);
			
			setUpStarling();
			
			state = new GameState();
		}
	}
}