package
{
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class ShootingHero extends Hero
	{
		private var bulletcounter:int = 0;
		public static var bullet:Missile;
		
		[Embed(source="bullet.png")]
		public static var bulletEMBD:Class;
		
		public function ShootingHero(name:String, params:Object=null)
		{
			super(name, params);
			
			_ce.input.keyboard.addKeyAction("shoot", citrus.input.controllers.Keyboard.A)
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if(_ce.input.justDid("shoot"))
			{
				
				if(_inverted){
					bullet = new Missile("bullet"+bulletcounter, {x:x - width, y:this.y + 10, width:5, height:48, speed:500, angle:180});
					bullet.view = new bulletEMBD();
					
					//trace("pow");
				}else{
					bullet = new Missile("bullet"+bulletcounter, {x:x + width, y:this.y + 10, width:5, height:48, speed:500, angle:0});
					bullet.view = new bulletEMBD();

					//trace("bam");
				}
				
				bulletcounter++;
				_ce.state.add(bullet);
			}
			
			updateAnimation();
		}
	}
}