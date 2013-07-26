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
			trace("ten");
			
			//state = new BlittingGameState();
			
//			sound.addSound("hurt", {sound:"Splat.mp3"})
//			sound.addSound("health", {sound:"Health.mp3"})
//			sound.addSound("shoot", {sound:"Shoot.mp3"})
//			sound.addSound("ammo", {sound:"Ammo.mp3"})
//			sound.addSound("running", {sound:"Footsteps.mp3"})
//			sound.addSound("almostDead", {sound:"Heartbeat.mp3"})
			
		}
	}
}