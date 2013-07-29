package
{
	import citrus.core.starling.StarlingCitrusEngine;
	
	[SWF (width="1024", height="768", frameRate="60", backgroundColor="#ffffff")]
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