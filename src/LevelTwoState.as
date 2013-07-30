package
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import starling.display.Image;
	
	public class LevelTwoState extends StarlingState
	{
		[Embed(source="assets/images/basement.jpg")]
		public var BackgroundPic2:Class;
		
		public function LevelTwoState()
		{
			super();
		}
		
		override public function initialize():void
		{
			var background:CitrusSprite = new CitrusSprite("background", {view:Image.fromBitmap(new BackgroundPic2())});
			background.x = 0;
			background.y = -270;
			add(background);
		}
	}
}