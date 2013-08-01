package
{
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.view.starlingview.AnimationSequence;
	
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
		
	public class ShootingHero extends Hero
	{
		private var bulletcounter:int = 0;
		public static var bullet:Missile;
		
		[Embed(source="assets/images/bullet.png")]
		public static var bulletEMBD:Class;
		
		[Embed(source="assets/sound/Shoot.mp3")]
		public static var bulletShoot:Class;
		public static var ShootSound:Sound = new bulletShoot() as Sound;
		
//		[Embed(source="assets/sound/Machine_Gun.mp3")]
//		public static var machinegunSound:Class;
//		public static var Machine_Gun_Shot:Sound = new machinegunSound() as Sound;
		
		[Embed(source="assets/sound/Gatling.mp3")]
		public static var gatlingSound:Class;
		public static var Gatling:Sound = new gatlingSound() as Sound;
		
		[Embed(source="assets/sound/Sniper.mp3")]
		public static var sniperGun:Class;
		public static var SniperShot:Sound = new sniperGun() as Sound;
		
		[Embed(source="assets/spritesheets/hero_pistol.xml", mimeType="application/octet-stream")]
		private var _heroPistolConfig:Class;
		
		[Embed(source="assets/spritesheets/hero_pistol.png")]
		private var _heroPistolPng:Class;
		
		private var _Herobitmap:Bitmap;
		private var _Herotexture:Texture;
		private var _Heroxml:XML;
		private var _HerosTextureAtlas:TextureAtlas;
		private var _rifleBullets:Number = 0;
		private var _sniperBullets:Number = 0;
		private var _gatlingBullets:Number = 0;

		public function ShootingHero(name:String, params:Object=null)
		{
			super(name, params);
			
			_ce.input.keyboard.addKeyAction("shoot", citrus.input.controllers.Keyboard.ENTER);
			_ce.input.keyboard.addKeyAction("jump", citrus.input.controllers.Keyboard.UP);
			
			this.hurtVelocityX = -10;
			this.hurtVelocityY = -10;
			this.killVelocity = 80000;
			this.jumpHeight = 15;
			this.hurtDuration = 1000;
			this.maxVelocity = 5;
		}
		
		public function onKeyDown(event:KeyboardEvent):void
		{
			// This Function will need to be specifically called when the machine gun is being used
			// The sound will need to be changed for a machine gun as well.
			// Set a counter to reset the gun back to the pistol after X amounts of bullets (this will keep people playing and picking up the crates)
			
			if(event.keyCode == 13 && this.name == "heroRifle")
			{
				ShootSound.play(0,0);
				
				if(_inverted)
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x - width, y:this.y + 10, width:5, height:48, speed:500, angle:180});
					bullet.view = new bulletEMBD();
					
				}else
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x + width, y:this.y + 10, width:5, height:48, speed:500, angle:0});
					bullet.view = new bulletEMBD();
				}
				
				_rifleBullets++;
				_ce.state.add(bullet);
				
				if(_rifleBullets >= 25)
				{
					_rifleBullets = 0;
					this.name = "heroPistol";
					_Herobitmap = new _heroPistolPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroPistolConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					this.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
				}
			}
			
			if(event.keyCode == 13 && this.name == "heroGatling")
			{
				Gatling.play(0,0);
				
				if(_inverted)
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x - width, y:this.y + 33, width:5, height:48, speed:500, angle:180});
					bullet.view = new bulletEMBD();
					
				}else
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x + width, y:this.y + 33, width:5, height:48, speed:500, angle:0});
					bullet.view = new bulletEMBD();
				}
				
				_gatlingBullets++
				_ce.state.add(bullet);
				
				if(_gatlingBullets >= 40)
				{
					_gatlingBullets = 0;
					this.name = "heroPistol";
					_Herobitmap = new _heroPistolPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroPistolConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					// Hero needs to have the machine gun removed
					this.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
				}
			}
		}
		
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var gs:GameState = new GameState;
			
			if(_ce.input.justDid("shoot") && this.name == "gameOver")
			{
				gs.onRestart();
			}
			
			if(_ce.input.justDid("shoot") && this.name == "nextLevel")
			{
				gs.onNextLevel();
			}
			
			if(bullet)
			{
				if(bullet.x <= 0 || bullet.x >= 1560)
				{
					bullet.destroy();
				}
			}

			if(_ce.input.justDid("shoot") && this.name == "heroPistol")
			{
				ShootSound.play(0,0);
				
				if(_inverted)
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x - width, y:this.y + 10, width:5, height:48, speed:500, angle:180});
					bullet.view = new bulletEMBD();
					
				}else
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x + width, y:this.y + 10, width:5, height:48, speed:500, angle:0});
					bullet.view = new bulletEMBD();
				}
				
				bulletcounter++;
				_ce.state.add(bullet);
			}
			
			if(_ce.input.justDid("shoot") && this.name == "heroSniper")
			{
				SniperShot.play(0,0);
				
				if(_inverted)
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x - width, y:this.y + 10, width:5, height:48, speed:500, angle:180});
					bullet.view = new bulletEMBD();
					
				}else
				{
					bullet = new Missile("bullet"+bulletcounter, {x:x + width, y:this.y + 10, width:5, height:48, speed:500, angle:0});
					bullet.view = new bulletEMBD();
				}
				
				_sniperBullets++;
				_ce.state.add(bullet);
				
				if(_sniperBullets >= 5)
				{
					_sniperBullets = 0;
					this.name = "heroPistol";
					_Herobitmap = new _heroPistolPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroPistolConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					this.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
				}
			}

			updateAnimation();
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("GoodGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("BadGuys");
		}

	}
}