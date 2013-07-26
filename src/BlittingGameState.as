package
{
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.core.State;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.system.components.ViewComponent;
	import citrus.view.ACitrusView;
	import citrus.view.blittingview.AnimationSequence;
	import citrus.view.blittingview.BlittingArt;
	import citrus.view.blittingview.BlittingView;
	
	public class BlittingGameState extends State
	{
		[Embed(source = 'werewolf_small.png')] private var _heroIdleClass:Class;
		[Embed(source = 'hero_small.png')] private var _heroWalkClass:Class;
		[Embed(source = 'vampire_Boss.png')] private var _heroJumpClass:Class;
		
		public function BlittingGameState()
		{
			super();
		}
			override public function initialize():void 
			{
				
				super.initialize();
				
				var box2D:Box2D = new Box2D("box2D");
				//box2D.visible = true;
				add(box2D);
				
				add(new Platform("P1", {x:320, y:400, width:2000, height:20}));
								
				// Set up your game object's animations like this;
				var heroArt:BlittingArt = new BlittingArt();
				heroArt.addAnimation(new AnimationSequence(_heroIdleClass, "idle", 70, 125, true, true));
				heroArt.addAnimation(new AnimationSequence(_heroWalkClass, "walk", 70, 125, true, true));
				heroArt.addAnimation(new AnimationSequence(_heroJumpClass, "jump", 70, 125, false, true));
				
				// pass the blitting art object into the view.
				var hero:Hero = new Hero("Hero", {x:stage.stageWidth/2, y:150, width:70, height:125, view:heroArt});
				add(hero);
								
				// If you update any properties on the state's view, call updateCanvas() afterwards.

				BlittingView(view).backgroundColor = 0xffffcc88;
				BlittingView(view).updateCanvas(); // Don't forget to call this
			}
			
			// Make sure and call this override to specify Blitting mode.
			override protected function createView():citrus.view.ACitrusView
			{
				
				return new BlittingView(this);
			}
	}
}