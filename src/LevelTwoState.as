package
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class LevelTwoState extends StarlingState
	{	
		[Embed(source="assets/spritesheets/vampire.xml", mimeType="application/octet-stream")]
		private var _vampireConfig:Class;
		
		[Embed(source="assets/spritesheets/vampire.png")]
		private var _vampirePng:Class;
		
		[Embed(source="assets/spritesheets/vampire_boss.xml", mimeType="application/octet-stream")]
		private var _vampireBossConfig:Class;
		
		[Embed(source="assets/spritesheets/vampire_boss.png")]
		private var _vampireBossPng:Class;
		
		[Embed(source="assets/images/vampire_boss_hud.png")]
		private var _vampireBossHealth:Class;
		
		[Embed(source="assets/spritesheets/hero_sniper.xml", mimeType="application/octet-stream")]
		private var _heroSniperConfig:Class;
		
		[Embed(source="assets/spritesheets/hero_sniper.png")]
		private var _heroSniperPng:Class;
		
		[Embed(source="assets/spritesheets/hero_gatling.xml", mimeType="application/octet-stream")]
		private var _heroGatlingConfig:Class;
		
		[Embed(source="assets/spritesheets/hero_gatling.png")]
		private var _heroGatlingPng:Class;
		
		[Embed(source="assets/spritesheets/hero_pistol.xml", mimeType="application/octet-stream")]
		private var _heroPistolConfig:Class;
		
		[Embed(source="assets/spritesheets/hero_pistol.png")]
		private var _heroPistolPng:Class;
		
		[Embed(source="assets/spritesheets/hero_rifle.xml", mimeType="application/octet-stream")]
		private var _heroRifleConfig:Class;
		
		[Embed(source="assets/spritesheets/hero_rifle.png")]
		private var _heroRiflePng:Class;
		
		[Embed(source="assets/images/basement.jpg")]
		public var BackgroundPic:Class;
		
		[Embed(source="assets/images/crate_pistol.jpg")]
		public var defaultPistol:Class;
		
		[Embed(source="assets/images/crate_health.jpg")]
		public var healthCrate:Class;
		
		[Embed(source="assets/images/crate_rifle.jpg")]
		public var machineGunCrate:Class;
		
		[Embed(source="assets/images/crate_sniper.jpg")]
		public var sniperCrate:Class;
		
		[Embed(source="assets/images/crate_gatling.jpg")]
		public var gatlingCrate:Class;
		
		[Embed(source="assets/images/HUD.png")]
		public var HealthBar:Class;
		
		[Embed(source="assets/images/startscreen.jpg")]
		public var startScreen:Class;
		
		[Embed(source="assets/images/loadscreen.jpg")]
		public var loadScreen:Class;
		
		[Embed(source="assets/images/winscreen.jpg")]
		public var winScreen:Class;
		
		[Embed(source="assets/images/endscreen.jpg")]
		public var endScreen:Class;
		
		[Embed(source="assets/sound/Ammo.mp3")]
		public static const SND_AMMO:Class;
		
		[Embed(source="assets/sound/Splat.mp3")]
		public static const Bite:Class;
		
		[Embed(source="assets/sound/Kill_Streak.mp3")]
		public static const Boss:Class;
		
		[Embed(source="assets/sound/Health.mp3")]
		public static const Health:Class;
		
		[Embed(source="assets/sound/levelTwoMusic.mp3")]
		public static const MusicSongs:Class;
		
		[Embed(source="assets/sound/Heartbeat.mp3")]
		public static const heartbeat:Class;
		
		[Embed(source="assets/sound/vampBossLaugh.mp3")]
		public static const gameOver:Class;
		
		private var _hero:ShootingHero;
		private var _enemies:Array = [];
		private var _crate:CitrusSprite;
		private var _crateArray:Array = ["machineGun", "health", "firstPistol", "gatling", "sniper"];
		private var _delayedCall:DelayedCall;
		private var _enemyCounter:Number = 0;
		public static var sndAmmo:Sound = new SND_AMMO() as Sound;
		public static var BossSpeech:Sound = new Boss() as Sound;
		public static var heartbeating:Sound = new heartbeat() as Sound;
		public static var HealthSound:Sound = new Health as Sound;
		public static var Musics:Sound = new MusicSongs as Sound;
		public static var gameOverSound:Sound = new gameOver as Sound;
		private var _Herobitmap:Bitmap;
		private var _Herotexture:Texture;
		private var _Heroxml:XML;
		private var _HerosTextureAtlas:TextureAtlas;
		private var _enemybitmap:Bitmap;
		private var _enemytexture:Texture;
		private var _enemyxml:XML;
		private var _enemysTextureAtlas:TextureAtlas;
		private var _spawning:Boolean = true;
		private var _hud:CitrusSprite;
		private var _bossHud:CitrusSprite;
		private var _bossHealthFill:Platform;
		private var _healthFill:Platform;
		private var _bossSpawn:Boolean = false;
		private var _wolfBoss:OurEnemy;
		private var _heroHurt:Boolean = true;
		
		public function LevelTwoState()
		{
			super();
		}
		
		override public function initialize():void
		{
			
			super.initialize();
			
			var soundTrans:SoundTransform = new SoundTransform(1)
			Musics.play(0,0,soundTrans);
			
			onStart();
		}
		
		private function onStart():void
		{
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			
			_Herobitmap = new _heroPistolPng();
			_Herotexture = Texture.fromBitmap(_Herobitmap);
			_Heroxml= XML(new _heroPistolConfig());
			_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
			
			_enemybitmap = new _vampirePng();
			_enemytexture = Texture.fromBitmap(_enemybitmap);
			_enemyxml= XML(new _vampireConfig());
			_enemysTextureAtlas = new TextureAtlas(_enemytexture, _enemyxml);
			
			var physics:Box2D = new Box2D("box2d");
			physics.view = null;
			//physics.visible = true;
			add(physics);
			
			var background:CitrusSprite = new CitrusSprite("background", {view:Image.fromBitmap(new BackgroundPic())});
			background.x = 0;
			background.y = -270;
			add(background);
			
			_crate = new CitrusSprite("crate", {view:Image.fromBitmap(new defaultPistol())});
			_crate.name = "firstPistol";
			_crate.x = Math.random() * 1400 + 20;
			_crate.y = 365;
			add(_crate);
			
			var floor:Platform = new Platform("floor", {x:600, y:460, width:2500, height:100});
			add(floor);
			
			var wallRight:Platform = new Platform("rightWall", {x:1560, y:200, width:50, height:800, oneWay:true});
			add(wallRight);
			
			var wallLeft:Platform = new Platform("leftWall", {x:0, y:200, width:50, height:800, oneWay:true});
			add(wallLeft);
			
			
			_healthFill = new Platform("healthbar", {x:260, y:-200, width:200, height:20});
			_healthFill.view = new Quad(250,25,0xaa5555);
			add(_healthFill);
			
			_hud = new CitrusSprite("hud", {view:Image.fromBitmap(new HealthBar())});
			_hud.x = 10;
			_hud.y = -250;
			add(_hud);
			
			_hero = new ShootingHero("hero", {x:stage.stageWidth/2, y:150, width:70, height:125});
			_hero.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
			_hero.hurtDuration = 1000;
			_hero.name = "heroPistol";
			add(_hero);
			
			view.camera.setUp(_hero, new Point(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 1550, 450), new Point(.25, .05));
			
			for(var i:uint= 0; i < 2; i++)
			{					
				var enemy:OurEnemy = new OurEnemy("BadGuys", {x:-150, y:390, width:70, height:130, leftBound:10, rightBound:1560});
				enemy.view = new AnimationSequence(_enemysTextureAtlas,["walk","idle"], "idle");
				enemy..hurtDuration = 10;
				_enemies.push(enemy);
				add(enemy);
			}
			
			for(var j:uint= 0; j < 1; j++)
			{					
				var enemy2:OurEnemy = new OurEnemy("BadGuys", {x:1750, y:390, width:70, height:130, leftBound:10, rightBound:1560});
				enemy2.view = new AnimationSequence(_enemysTextureAtlas,["walk","idle"], "idle");
				enemy2.hurtDuration = 10;
				_enemies.push(enemy2);
				add(enemy2);
			}
			
			// This is calling the crates to spawn every 5 seconds.
			_delayedCall = new DelayedCall(crateSpawnTimer, 10.0);
			_delayedCall.repeatCount = 0;
			Starling.juggler.add(_delayedCall);
		}
		
		protected function crateSpawnTimer():void
		{			
			var i:uint = Math.random() * 5 + 0;
			
			remove(_crate);
			
			// Creating a new crate.
			_crate = new CitrusSprite("crate",{view:Image.fromBitmap(new defaultPistol())});
			_crate.name = _crateArray[i]; // Randomizing what crate will be deployed.
			_crate.x = Math.random() * 1400 + 20;
			_crate.y = 365;
			
			if(_crate.name == "machineGun")
			{
				_crate.view = new machineGunCrate();
			}
			if(_crate.name == "pistolGun")
			{
				_crate.view = new defaultPistol();
			}
			
			if(_crate.name == "health")
			{
				_crate.view = new healthCrate();
			}
			
			if(_crate.name == "gatling")
			{
				_crate.view = new gatlingCrate();
			}
			
			if(_crate.name == "sniper")
			{
				_crate.view = new sniperCrate();
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
			
			if(_hero.x <= 30)
			{
				_hero.x = 30;
			}
			
			if(_hero.x >= 1520)
			{
				_hero.x = 1520;
			}
			
			if(_hero.x > 610)
			{
				_hud.x = _hero.x - 600;
			}
			
			if(_hero.x > 890)
			{
				_hud.x = 290;
			}
			
			_healthFill.x = _hud.x + 15 + _healthFill.width;
			
			if(_hero.hurtDuration <= 800)
			{
				_healthFill.view = new Quad(200,25,0xaa5555);
				_healthFill.x = _hud.x - 10 + _healthFill.width;
				
			}
			
			if(_hero.hurtDuration <= 600)
			{
				_healthFill.view = new Quad(200,25,0xaa5555);
				_healthFill.x = _hud.x - 60 + _healthFill.width;
			}
			
			if(_hero.hurtDuration <= 400)
			{
				_healthFill.view = new Quad(100,25,0xaa5555);
				_healthFill.x = _hud.x - 80 + _healthFill.width;
			}
			
			if(_hero.hurtDuration <= 200)
			{
				_healthFill.view = new Quad(50,25,0xaa5555);
				_healthFill.x = _hud.x - 120 + _healthFill.width;
				
				if(_heroHurt)
				{
					heartbeating.play(0,0);
					_heroHurt = false;
				}
			}
			
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
						_hero.hurtDuration -= 4;
					}
					
					if(ShootingHero.bullet)
					{
						var p3:Point = new Point(ShootingHero.bullet.x, ShootingHero.bullet.y);
						var bulletDistance:Number = Point.distance(p2,p3);
						
						// if the bullet hits the enemy
						if(bulletDistance < radius1 + radius2 && _hero.name == "heroSniper")
						{
							enemy.kill = true;
							remove(ShootingHero.bullet);
							ShootingHero.bullet.y = 1000000000000;
							_enemyCounter++;
							
							if(enemy.hurtDuration <= 0)
							{
								enemy.kill = true;
								spawnEnemy();
							}
						}
						
						if(bulletDistance < radius1 + radius2 && _hero.name == "heroGatling")
						{
							enemy.hurtDuration -= 8;
							remove(ShootingHero.bullet);
							ShootingHero.bullet.y = 1000000000000;
							_enemyCounter++;
							
							if(enemy.hurtDuration <= 0)
							{
								enemy.kill = true;
								spawnEnemy();
							}
						}
						
						if(bulletDistance < radius1 + radius2 && _hero.name == "heroPistol")
						{
							enemy.hurtDuration -= 4;
							remove(ShootingHero.bullet);
							ShootingHero.bullet.y = 1000000000000;
							_enemyCounter++;
							
							if(enemy.hurtDuration <= 0)
							{
								enemy.kill = true;
								spawnEnemy();
							}
						}
						
						if(bulletDistance < radius1 + radius2 && _hero.name == "heroRifle")
						{
							enemy.hurtDuration -= 6;
							remove(ShootingHero.bullet);
							ShootingHero.bullet.y = 1000000000000;
							_enemyCounter++;
							
							if(enemy.hurtDuration <= 0)
							{
								enemy.kill = true;
								spawnEnemy();
							}
						}
					}	
				}
				
				if(enemy.kill)
				{
					_enemies.splice(_enemies.indexOf(enemy), 1);
				}
			}
			
			if(_bossSpawn)
			{
				var p8:Point = new Point(_hero.x, _hero.y);
				var p9:Point = new Point(_wolfBoss.x, _wolfBoss.y);
				var p10:Point = new Point(ShootingHero.bullet.x,ShootingHero.bullet.y);
				var bulletDistance2:Number = Point.distance(p9,p10);
				var distance2:Number = Point.distance(p8, p9);
				var radius:Number = _wolfBoss.width;
				
				if(_hero.x > 610)
				{
					_bossHud.x = _hero.x + 280;
				}
				
				if(_hero.x > 890)
				{
					_bossHud.x = 1200;
				}
				
				_bossHealthFill.x = _bossHud.x - 70 + _bossHealthFill.width;
				
				if(!_wolfBoss.kill)
				{
					if(distance2 < radius)
					{
						_hero.hurtDuration -= 20;
					}
				}
				
				if(!_wolfBoss.kill)
				{
					if(_wolfBoss.hurtDuration <= 250)
					{
						_bossHealthFill.view = new Quad(240,25,0xaa5555);
						_bossHealthFill.x = _bossHud.x + _bossHealthFill.width;
					}
					
					if(_wolfBoss.hurtDuration <= 200)
					{
						_bossHealthFill.view = new Quad(200,25,0xaa5555);
						_bossHealthFill.x = _bossHud.x + _bossHealthFill.width;
					}
					
					if(_wolfBoss.hurtDuration <= 150)
					{
						_bossHealthFill.view = new Quad(150,25,0xaa5555);
						_bossHealthFill.x = _bossHud.x + _bossHealthFill.width;
					}
					
					if(_wolfBoss.hurtDuration <= 100)
					{
						_bossHealthFill.view = new Quad(50,25,0xaa5555);
						_bossHealthFill.x = _bossHud.x + 50 + _bossHealthFill.width;
					}
				}
				
				if(ShootingHero.bullet)
				{
					if(!_wolfBoss.kill && bulletDistance2 < radius)
					{
						remove(ShootingHero.bullet);
						_wolfBoss.hurtDuration -= 2;
						ShootingHero.bullet.y = 1000000000000;
						
						if(_wolfBoss.hurtDuration <= 0)
						{
							_wolfBoss.kill = true;
							
							if(_wolfBoss.hurtDuration <= 0)
							{	
								_hero.x = 10;
								_hero.name = "gameOver";
								
								this.killAllObjects();
								_delayedCall.reset(crateSpawnTimer, 100000000);
								
								_hero = new ShootingHero("hero", {x:stage.stageWidth/2, y:150, width:70, height:125});
								_hero.name = "gameOver";
								add(_hero);
								
								var youWin:CitrusSprite = new CitrusSprite("youWin", {view:Image.fromBitmap(new winScreen())});
								youWin.x = 0;
								youWin.y = -320;
								add(youWin);
							}
						}
					}
				}
			}
			
			if(_hero.hurtDuration <= 0)
			{
				_hero.x = 10;
				_hero.name = "gameOver";
				this.killAllObjects();
				
				gameOverSound.play(0,0);
				
				_delayedCall.reset(crateSpawnTimer, 100000000);
				
				_hero = new ShootingHero("hero", {x:stage.stageWidth/2, y:150, width:70, height:125});
				_hero.name = "gameOver";
				add(_hero);
				
				var endScreen2:CitrusSprite = new CitrusSprite("endScreen", {view:Image.fromBitmap(new endScreen())});
				endScreen2.x = 0;
				endScreen2.y = -320;
				add(endScreen2);
			}
		}
		
		public function onRestart():void
		{
			CitrusEngine.getInstance().state = new GameState;
		}
		
		private function spawnEnemy():void
		{
			if(_spawning)
			{
				for(var i:uint= 0; i < 1; i++)
				{					
					var enemy:OurEnemy = new OurEnemy("BadGuys", {x:Math.random() * -200 - 50, y:390, width:70, height:130, leftBound:10, rightBound:1560});
					enemy.view = new AnimationSequence(_enemysTextureAtlas,["walk","idle"], "idle");
					enemy.speed = Math.random() * 3 + 1;
					enemy.hurtDuration = 15;
					_enemies.push(enemy);
					add(enemy);
				}
				
				for(var j:uint= 0; j < 1; j++)
				{					
					var enemy2:OurEnemy = new OurEnemy("BadGuys", {x:Math.random() * 30 + 1750, y:390, width:70, height:130, leftBound:10, rightBound:1560});
					enemy2.view = new AnimationSequence(_enemysTextureAtlas,["walk","idle"], "idle");
					enemy2.hurtDuration = 15;
					enemy2.speed = Math.random() * 3 + 1;
					_enemies.push(enemy2);
					add(enemy2);
				}
				
				if(_enemyCounter >= 36)
				{
					_spawning = false;
				}
				
			}
			
			if(_enemies.length == 1)
			{
				spawnBoss();
			}
		}
		
		private function spawnBoss():void
		{
			_bossSpawn = true;
			
			BossSpeech.play(0,0);
			
			_enemybitmap = new _vampireBossPng();
			_enemytexture = Texture.fromBitmap(_enemybitmap);
			_enemyxml= XML(new _vampireBossConfig());
			_enemysTextureAtlas = new TextureAtlas(_enemytexture, _enemyxml);
			
			_wolfBoss = new OurEnemy("BadGuys", {x:1750, y:390, width:70, height:130, leftBound:10, rightBound:1560});
			_wolfBoss.view = new AnimationSequence(_enemysTextureAtlas,["walk","idle"], "idle");
			_wolfBoss.speed = 8;
			_wolfBoss.hurtDuration = 300;
			add(_wolfBoss);
			
			_bossHealthFill = new Platform("bosshealthbar", {x:900, y:-200, width:200, height:20});
			_bossHealthFill.view = new Quad(250,25,0xaa5555);
			add(_bossHealthFill);
			
			_bossHud = new CitrusSprite("hud", {view:Image.fromBitmap(new _vampireBossHealth())});
			_bossHud.x = 900;
			_bossHud.y = -250;
			add(_bossHud);
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
				_crate.x = 100000000;
				_crate.y = 100000000;
				
				if(_crate.name == "firstPistol")
				{
					sndAmmo.play(0,0);
					
					_Herobitmap = new _heroPistolPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroPistolConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					_hero.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
					_hero.name = "heroPistol";
					
					remove(_crate);
					_ce.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _hero.onKeyDown);
					
				}
				
				if(_crate.name == "machineGun")
				{
					// Play sound effect
					sndAmmo.play(0,0);
					
					_Herobitmap = new _heroRiflePng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroRifleConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					_hero.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
					_hero.name = "heroRifle";
					
					// This is calling the function to shoot as a machine gun. Which is in the ShootingHero class
					_ce.stage.addEventListener(KeyboardEvent.KEY_DOWN, _hero.onKeyDown);
					
					// Remove the crate from the screen.
					remove(_crate);
					
				}
				
				if(_crate.name == "sniper")
				{
					// Play sound effect
					sndAmmo.play(0,0);
					
					_Herobitmap = new _heroSniperPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroSniperConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					_hero.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
					_hero.name = "heroSniper";
					
					// Remove the crate from the screen.
					remove(_crate);
				}
				
				if(_crate.name == "gatling")
				{
					// Play sound effect
					sndAmmo.play(0,0);
					
					_Herobitmap = new _heroGatlingPng();
					_Herotexture = Texture.fromBitmap(_Herobitmap);
					_Heroxml= XML(new _heroGatlingConfig());
					_HerosTextureAtlas = new TextureAtlas(_Herotexture, _Heroxml);
					_hero.view = new AnimationSequence(_HerosTextureAtlas,["walk", "duck", "idle", "jump", "hurt"], "idle");
					_hero.name = "heroGatling";
					
					// This is calling the function to shoot as a machine gun. Which is in the ShootingHero class
					_ce.stage.addEventListener(KeyboardEvent.KEY_DOWN, _hero.onKeyDown);
					
					// Remove the crate from the screen.
					remove(_crate);
				}
				
				if(_crate.name == "health")
				{
					// Play sound effect
					HealthSound.play(0,0);
					
					if(_hero.hurtDuration < 1000)
					{
						_hero.hurtDuration += 400;
						onUpdate();
						remove(_crate);				
					}
					
					if(_hero.hurtDuration >= 1000)
					{
						_hero.hurtDuration == 1000;
						_healthFill.view = new Quad(250,25,0xaa5555);
						_healthFill.x = _hud.x + 15 + _healthFill.width;
						onUpdate();
					}
					
					onUpdate();
					// Remove the crate from the screen.
					remove(_crate);
				}
			}
		}
	}
}