package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2World;
	
	import away3d.controllers.FollowController;
	
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusGroup;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Crate;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.view.blittingview.AnimationSequence;
	import citrus.view.blittingview.BlittingArt;
	import citrus.view.starlingview.AnimationSequence;
	
	import feathers.controls.ProgressBar;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import nape.constraint.PulleyJoint;
	
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.text.TextField;
	
	public class GameState extends StarlingState
	{
		[Embed(source="hero_small.png")]
		private var hero_toon:Class;
		
		[Embed(source="hero-pistol.png")]
		private var hero_Gun:Class;
		
		[Embed(source="hero-rifle.png")]
		private var hero_machineGun:Class;
		
		[Embed(source="vampire_small.png")]
		private var enemy_toon:Class;
		
		[Embed(source="werewolf_small.png")]
		private var enemy_toon2:Class;
		
		[Embed(source="hunter_bullet.png")]
		private var _bullet:Class;
		
		[Embed(source="forestBackground.jpg")]
		public var BackgroundPic:Class;
		
		[Embed(source="box-pistol.png")]
		public var pistolCrate:Class;
		
		[Embed(source="box-health.png")]
		public var healthCrate:Class;
		
		[Embed(source="box-rifle.png")]
		public var machineGunCrate:Class;
		
		[Embed(source="vampire_Boss.png")]
		public var vampireBoss:Class;
		
		[Embed(source="Ammo.mp3")]
		public static const SND_AMMO:Class;
		
		[Embed(source="bullet.png")]
		public static var bulletEMBD:Class;
		
		private var _hero:ShootingHero;
		private var _enemies:Array = [];
		private var _bulletcounter:uint = 0;
		private var _crate:Crate;
		private var _crateArray:Array = ["machineGun","pistolGun","health"];
		private var _delayedCall:DelayedCall;
		
		public static var sndAmmo:Sound = new SND_AMMO() as Sound;
		
		
		public function GameState()
		{
			super();
		}
		
		override public function initialize():void
		{
			
			super.initialize();
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			
			var physics:Box2D = new Box2D("box2d");
			physics.view = null;
			//physics.visible = true;
			add(physics);
			
			var background:CitrusSprite = new CitrusSprite("background", {view:Image.fromBitmap(new BackgroundPic())});
			background.x = 0;
			background.y = -270;
			add(background);
			
			_crate = new Crate("crate",{x:Math.random() * 1400 + 20,y:00,width:30,height:30});
			_crate.view = new pistolCrate();
			_crate.name = "pistolGun";
			add(_crate);
			
			var floor:Platform = new Platform("floor", {x:600, y:400, width:2000, height:100});
			//floor.view = new Quad(2000,100,0xff0000);
			add(floor);
			
			var wallRight:Platform = new Platform("rightWall", {x:1560, y:200, width:50, height:800});
			wallRight.view = new Quad(0,800,0xff0000);
			add(wallRight);
			
			var wallLeft:Platform = new Platform("leftWall", {x:0, y:200, width:50, height:800});
			wallLeft.view = new Quad(0,800,0xff0000);
			add(wallLeft);
			
			_hero = new ShootingHero("hero", {x:stage.stageWidth/2, y:150, width:70, height:125});
			_hero.view = new hero_toon();
			_hero.hurtVelocityX = -10;
			_hero.hurtVelocityY = -10;
			_hero.killVelocity = 100;
			_hero.jumpHeight = 15;
			_hero.hurtDuration = 1000;
			_hero.maxVelocity = 5;
			add(_hero);
			
			view.camera.setUp(_hero, new Point(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 1550, 450), new Point(.25, .05));
			
			for(var i:uint= 0; i < 3; i++)
			{					
				var enemy:Enemy = new Enemy("enemy", {x:Math.random() * (i + 1), y:390, width:70, height:130, leftBound:10, rightBound:1560});
				enemy.view = new enemy_toon();
				enemy.hurtDuration = 200;
				_enemies.push(enemy);
				add(enemy);
				
				//				var enemy2:Enemy = new Enemy("enemy", {x:900, y:100, width:70, height:70, leftBound:10, rightBound:1000});
				//				enemy2.view = new enemy_toon2();
				//				enemy2.speed = 3;
				//				_enemies.push(enemy2);
				//				add(enemy2);
			}
			
			// This is calling the crates to spawn every 5 seconds.
			_delayedCall = new DelayedCall(crateSpawnTimer, 20.0);
			_delayedCall.repeatCount = 1;
			Starling.juggler.add(_delayedCall);
			
			//			var textField:TextField = new TextField(100,50,"Kill Count","Arial",18,0xffffff,true);
			//			textField.x = 100;
			//			textField.y = 100;
		}
		
		protected function crateSpawnTimer():void
		{
			// If there is already a crate on the screen I need to remove it, this is called 10 seconds after the crate spwns
			var delayedCall:DelayedCall = new DelayedCall(crateRemoval, 10.0);
			delayedCall.repeatCount = 0;
			Starling.juggler.add(delayedCall);
			
			var i:uint = Math.random() * 3 + 0;
			
			// Creating a new crate.
			_crate = new Crate("crate",{x:Math.random() * 1400 + 20,y:00,width:30,height:30});
			_crate.name = _crateArray[i]; // Randomizing what crate will be deployed.
			
			if(_crate.name == "machineGun")
			{
				_crate.view = new machineGunCrate();
				
			}
			if(_crate.name == "pistolGun")
			{
				_crate.view = new pistolCrate();
				
			}
			if(_crate.name == "health")
			{
				_crate.view = new healthCrate();
			}
			
			add(_crate);
		}
		
		private function crateRemoval():void
		{
			if(_crate)
			{
				remove(_crate);
				crateSpawnTimer();
			}
		}
		
		private function onUpdate():void
		{	
			grabCrate();
			
			for each (var enemy:Enemy in _enemies) 
			{
				var p1:Point = new Point(_hero.x, _hero.y);
				var p2:Point = new Point(enemy.x, enemy.y);
				var distance:Number = Point.distance(p1, p2);
				var radius1:Number = enemy.width / 2;
				var radius2:Number = enemy.width / 2;
				
				if(!enemy.kill)
				{
					if(distance < radius1 + radius2)
					{
						trace(_hero.hurtDuration)
						_hero.hurtDuration -= 100;
						
						if(_hero.hurtDuration < 400)
						{
							// possible blood splats on the screen.
						}
						
						// play hurt noises here
						
						if(_hero.hurtDuration <= 0)
						{
							_hero.kill = true;
							// Go to the game over screen here.
						}
					}
					
					if(ShootingHero.bullet)
					{
						var p3:Point = new Point(ShootingHero.bullet.x, ShootingHero.bullet.y);
						var bulletDistance:Number = Point.distance(p2,p3);
						
						// if the bullet hits the enemy
						if(bulletDistance < radius1 + radius2)
						{
							enemy.kill = true;
							remove(ShootingHero.bullet);
							ShootingHero.bullet.y = 1000000000000;
						}
						
					}	
				}
				
				if(enemy.kill)
				{
					trace(_enemies.indexOf(enemy));
					_enemies.splice(_enemies.indexOf(enemy), 1);
				}
				
				if(_enemies.length <= 0)
				{
					spawnBoss();
				}
			}
		}
		
		private function spawnBoss():void
		{
			
			//			var middlePlatform:Platform = new Platform("Middle", {x:stage.stageWidth/2, y:100, width:200, height:50});
			//			middlePlatform.view = new Quad(0,800,0xff0000);
			//			add(middlePlatform);
			
			var vampBoss:Enemy = new Enemy("enemy", {x:1200, y:390, width:165, height:322, leftBound:10, rightBound:1560});
			vampBoss.view = new vampireBoss;
			//vampBoss.hurtDuration = 2000;
			add(vampBoss);
			
			var p1:Point = new Point(_hero.x, _hero.y);
			var p2:Point = new Point(vampBoss.x, vampBoss.y);				
			var distance:Number = Point.distance(p1, p2);
			var radius1:Number = vampBoss.width / 2;
			var radius2:Number = vampBoss.width / 2;
			
			if(!vampBoss.kill && distance < radius1 + radius2)
			{
				_hero.hurtDuration -= 200;
				
				if(_hero.hurtDuration < 400)
				{
					// possible blood splats on the screen.
				}
				
				// play hurt noises here
				
				if(_hero.hurtDuration <= 0)
				{
					_hero.kill = true;
					// Go to the game over screen here.
				}
			}
			
			if(ShootingHero.bullet)
			{
				var p3:Point = new Point(ShootingHero.bullet.x, ShootingHero.bullet.y);
				var bulletDistance:Number = Point.distance(p2,p3);
				trace(radius1);
				trace(radius2);
				trace(bulletDistance);
				
				if(!vampBoss.kill && bulletDistance < radius1 + radius2)
				{
					trace("HIT BOSS");
					
					vampBoss.kill = true;
					remove(ShootingHero.bullet);
				}
			}
			
			if(vampBoss.kill)
			{
				// Clear all graphics.
				// Create new level with WereWolves.
			}
		}
		
		private function grabCrate():void
		{
			var p1:Point = new Point(_hero.x, _hero.y);
			var p3:Point = new Point(_crate.x, _crate.y);
			var crateDistance:Number = Point.distance(p1, p3);
			var crateRadius1:Number = _hero.width / 2;
			var crateRadius2:Number = _hero.width / 2;
			
			if(!_hero.kill && crateDistance < crateRadius1 + crateRadius2)
			{
				trace("touching crate");
				crateDistance = 12000;
				
				// Set an if conditional to display the hero according to what crate was picked up.
				if(_crate.name == "pistolGun")
				{
					// Play sound effect
					sndAmmo.play(0,0);
					
					_hero.view = new hero_Gun();
					// Remove the crate from the screen.
					remove(_crate);
					
				}
				
				if(_crate.name == "machineGun")
				{
					// Play sound effect
					sndAmmo.play(0,0);
					
					_hero.view = new hero_machineGun();
					// Remove the crate from the screen.
					remove(_crate);
					// Set Noise for picking up a gun.
					
				}
				
				if(_crate.name == "health")
				{
					// Play sound effect
					
					if(_hero.hurtDuration < 1000)
					{
						_hero.hurtDuration += 400;
						remove(_crate);						
					}
					
					if(_hero.hurtDuration > 1000)
					{
						_hero.hurtDuration == 1000;
					}
					
					trace(_hero.hurtDuration);
					// Remove the crate from the screen.
					remove(_crate);
					// Set Noise for picking up HEALTH.
				}
			}
		}
	}
}