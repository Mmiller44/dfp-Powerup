package
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	
	import flash.events.GameInputEvent;
	import flash.ui.GameInput;
	import flash.utils.setTimeout;
	
	import io.arkeus.ouya.ControllerInput;
	import io.arkeus.ouya.controller.OuyaController;
	
	[SWF (frameRate="60", backgroundColor="#ffffff")]
	public class Main extends StarlingCitrusEngine
	{					
		public function Main()
		{
			super();
			
			setUpStarling();
			
			state = new GameState();					
		}

	}
}