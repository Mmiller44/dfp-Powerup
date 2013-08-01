package
{
	import citrus.core.starling.StarlingCitrusEngine;
	
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