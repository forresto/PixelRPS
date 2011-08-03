package
{
	import flash.display.Graphics;
	
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var blueTeam:FlxGroup;
		public var redTeam:FlxGroup;
		public var posts:FlxGroup;
		
		// Layout
		private var leftMargin:uint = 8;
		
		public var numPosts:uint = 10;
		public var teamSize:uint = 5;
		
		private var blueShown:uint = 1;
		private var redShown:uint = 1;
		private var bluePoints:uint = teamSize;
		private var redPoints:uint = teamSize;
		
		// Framerate
		private var stepWait:uint = 15;
		private var frameCount:uint = 0;
		private var introStep:String = "Jump";
		
		private var blueHand:KidHands;
		private var redHand:KidHands;
		
		private var status:FlxText;
		private var blueScore:FlxText;
		private var redScore:FlxText;
		private var blueHandScore:KidHands;
		private var redHandScore:KidHands;
		
		// Interactive
		private var blueShoot:int = -1;
		private var redShoot:int = -1;
		
		// Game over
		private var gameOver:Boolean = false;
		private var fireworksCount:uint = 0;
		
		override public function create():void
		{
			var getReady:String = "";
			switch (FlxG.level) {
				case 0:
					getReady = "RPS Computer Battle";
					break;
				case 1:
					getReady = "Get ready! Blue: ASD";
					break;
				case 2:
					getReady = "Get ready! Red: JKL";
					break;
				case 3:
					getReady = "Ready! Blue: ASD, Red: JKL";
					break;
				default:
					getReady = "RPS Computer Battle";
					break;
			}
			status = new FlxText(0+leftMargin, 0, FlxG.width, getReady)
			add(status);

			blueScore = new FlxText(0+leftMargin, 15, 20, "")
			add(blueScore);

			redScore = new FlxText(120+leftMargin, 15, 20, "")
			add(redScore);

			redTeam = new FlxGroup();
			blueTeam = new FlxGroup();
			posts = new FlxGroup();
			
			for(var i:int = 0; i < numPosts; i++)
			{
				posts.add(new FlxSprite(i*12+10+leftMargin, 52, ImageResources.imgPost));
				var newBlue:Kid = new Kid(i*12+leftMargin, 36, ImageResources.imgBlueKid);
				newBlue.visible = i==0 ? true : false;
				blueTeam.add(newBlue);
				var newRed:Kid = new Kid(110-i*12+leftMargin, 36, ImageResources.imgRedKid);
				newRed.visible = i==0 ? true : false;
				redTeam.add(newRed);
			}
			
			add(posts);
			add(blueTeam);
			add(redTeam);
			
			blueHand = new KidHands(48+leftMargin, 40, ImageResources.imgBlueHands);
			add(blueHand);
			blueHand.visible = false;
			redHand = new KidHands(62+leftMargin, 40, ImageResources.imgRedHands);
			add(redHand);
			redHand.visible = false;
			blueHandScore = new KidHands(44+leftMargin, 15, ImageResources.imgBlueHands);
			add(blueHandScore);
			blueHandScore.visible = false;
			redHandScore = new KidHands(65+leftMargin, 15, ImageResources.imgRedHands);
			add(redHandScore);
			redHandScore.visible = false;
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.switchState(new MenuState());
			}
			
			if (gameOver && FlxG.keys.justPressed("SPACE")){
				FlxG.switchState(new PlayState());
			}
			
			if (FlxG.keys.justPressed("P")){
				stepWait++;
			} else if (FlxG.keys.justPressed("O") && stepWait>1) {
				stepWait--;
			}

			if (FlxG.keys.A) {
				blueShoot = 0;
			} else if (FlxG.keys.S) {
				blueShoot = 1;
			} else if (FlxG.keys.D) {
				blueShoot = 2;
			}
			
			if (FlxG.keys.J) {
				redShoot = 0;
			} else if (FlxG.keys.K) {
				redShoot = 1;
			} else if (FlxG.keys.L) {
				redShoot = 2;
			}

			if (frameCount >= stepWait) {
				// I want to control all of the animation with step() instead of FlxSprite.play()
				step();
				frameCount = 0;
			}
			else {
				frameCount++;
			}
			
		}
		
		private function step():void {
			switch (introStep) {
				case "Jump":
					// Hide hands 
					redHand.visible = false;
					blueHand.visible = false;
					// Hide last loser
					if (blueShown > bluePoints) {
						boom(blueTeam.members[blueShown-1].x+2, blueTeam.members[blueShown-1].y+5, 0xFF0000FF);
						blueTeam.members[blueShown-1].visible = false;
						blueShown--;
						blueHand.x -= 12;
						redHand.x -= 12;
					}
					if (redShown > redPoints) {
						boom(redTeam.members[redShown-1].x+10, redTeam.members[redShown-1].y+5, 0xFFFF0000);
						redTeam.members[redShown-1].visible = false;
						redShown--;
						blueHand.x += 12;
						redHand.x += 12;
					}
					// Reset next shot
					blueShoot = -1;
					redShoot = -1;
					// Show team members until full
					if (blueShown < bluePoints) {
						blueFrame(0);
						if (redShown == redPoints) redFrame(0);
					}
					if (redShown < redPoints) {
						redFrame(0);
						if (blueShown == bluePoints) blueFrame(0);
					}
					introStep = "Jump2";
					break;
				case "Jump2":
					if (blueShown < bluePoints) {
						blueFrame(1);
						if (redShown == redPoints) redFrame(3);
					}
					if (redShown < redPoints) {
						redFrame(1);
						if (blueShown == bluePoints) blueFrame(3);
					}
					introStep = "Jump3";
					break;
				case "Jump3":
					var blueNeedsToLand:Boolean = false; //HACK
					if (blueShown < bluePoints) {
						blueFrame(2);
						blueShown++;
						blueNeedsToLand = true;
						if (redShown == redPoints) redFrame(0);
					}
					if (redShown < redPoints) {
						redFrame(2);
						redShown++;
						if (!blueNeedsToLand && blueShown == bluePoints) blueFrame(0);
					}
					introStep = "Land";
					break;
				case "Land":
					blueFrame(3);
					redFrame(3);
					if (blueShown>0) blueTeam.members[blueShown-1].visible = true;
					if (redShown>0) redTeam.members[redShown-1].visible = true;
					introStep = "Jump";
					
					if (redShown == redPoints && blueShown == bluePoints) {
						introStep = "Ready";
					}
					if (bluePoints == 10 || redPoints == 10) {
						introStep = "Dance";
						gameOver = true;
					}
					break;
				case "Dance":
					allFrame(0);
					introStep = "Dance2";
					break;
				case "Dance2":
					allFrame(3);
					introStep = "Dance";
					// Fireworks
					if (fireworksCount >= 1) {
						fireworksCount = 0;
						boom(Math.floor(Math.random()*(FlxG.width-20))+10, 20, 0xFF000000+Math.floor(Math.random()*0xFFFFFF), false);
					} else {
						fireworksCount++;
					}
					break;
				case "Ready":
					allFrame(0);
					blueTeam.members[blueShown-1].frame = 4;
					redTeam.members[redShown-1].frame = 4;
					blueHand.frame = 0;
					redHand.frame = 0;
					blueHand.visible = true;
					redHand.visible = true;
					introStep = "BounceDown";
					break;
				case "BounceDown":
					allFrame(3, true);
					blueHand.frame = 0;
					redHand.frame = 0;
					blueHand.y += 1;
					redHand.y += 1;
					introStep = "BounceUp";
					status.text = "Saisho wa";
					break;
				case "BounceUp":
					allFrame(0, true);
					blueHand.y -= 1;
					redHand.y -= 1;
					introStep = "BounceDown2";
					break;
				case "BounceDown2":
					allFrame(3, true);
					blueHand.y += 1;
					redHand.y += 1;
					introStep = "BounceUp2";
					status.text = "Guu";
					break;
				case "BounceUp2":
					allFrame(0, true);
					blueHand.y -= 1;
					redHand.y -= 1;
					introStep = "BounceDown3";
					break;
				case "AikoDeshou":
					allFrame(0, true);
					blueShoot = -1;
					redShoot = -1;
					blueHand.frame = 0;
					redHand.frame = 0;
					introStep = "BounceDown3";
					break;
				case "BounceDown3":
					allFrame(3, true);
					blueHand.y += 1;
					redHand.y += 1;
					introStep = "BounceUp3";
					status.text = "Janken";
					break;
				case "BounceUp3":
					allFrame(0, true);
					blueHand.y -= 1;
					redHand.y -= 1;
					introStep = "Shoot";
					// Make sure each has shot if needed
					if ((FlxG.level == 3 || FlxG.level == 1) && blueShoot == -1) {
						// Two or one human blue
						introStep = "BounceDown3";
					}
					if ((FlxG.level == 3 || FlxG.level == 2) && redShoot == -1) {
						// Two or one human red
						introStep = "BounceDown3";
					}
					break;
				case "Shoot":
					allFrame(3, true);
					// Random for Comp players
					if (FlxG.level == 0 || FlxG.level == 1) {
						// Comp or one human blue
						redShoot = Math.floor(Math.random()*3);
					}
					if (FlxG.level == 0 || FlxG.level == 2) {
						// Comp or one human red
						blueShoot = Math.floor(Math.random()*3);
					}
					// Playing hands
					blueHand.frame = blueShoot;
					redHand.frame = redShoot;
					// Scoring hands
					blueHandScore.visible = true;
					redHandScore.visible = true;
					blueHandScore.frame = blueShoot;
					redHandScore.frame = redShoot;
					if (blueHand.frame == redHand.frame) {
						// Tie
						status.text = "Poi!";
						introStep = "AikoDeshou";
					} else if ((blueHand.frame == 0 && redHand.frame == 2) || (blueHand.frame == 1 && redHand.frame == 0) || (blueHand.frame == 2 && redHand.frame == 1)) {
						// Blue wins
						bluePoints++;
						redPoints--;
						blueScore.text = bluePoints.toString();
						redScore.text = redPoints.toString();
						status.text = "Poi! Aoi Blue +";
						introStep = "Jump";
					} else {
						// Red wins
						redPoints++;
						bluePoints--;
						blueScore.text = bluePoints.toString();
						redScore.text = redPoints.toString();
						status.text = "Poi! Aka Red +";
						introStep = "Jump";
					}
					break;
				case "":
					break;
				case "":
					break;
				default:
					break;
			}

		}
		
		private function allFrame(frame:uint, skipLast:Boolean=false):void {
			blueFrame(frame, skipLast);
			redFrame(frame, skipLast);
		}
		private function blueFrame(frame:uint, skipLast:Boolean=false):void {
			var blueTill:uint = skipLast ? blueShown-1 : blueShown;
			for (var i:uint=0; i<blueTill; i++){
				if (i<10) blueTeam.members[i].frame = frame;
			}
		}
		private function redFrame(frame:uint, skipLast:Boolean=false):void {
			var redTill:uint = skipLast ? redShown-1 : redShown;
			for (var i:uint=0; i<redTill; i++){
				if (i<10) redTeam.members[i].frame = frame;
			}
		}
		
		private function boom(x:int, y:int, color:uint=0xFFFFFFFF, shake:Boolean=true):void {
			// Camera shake
			if (shake) {
				var intensity:Number = Math.pow(10, Math.abs(bluePoints-redPoints)/10+.1) / 10;
				FlxG.camera.shake(intensity*.05, intensity*.9);
			}
			
			// Explosion
			var emitter:FlxEmitter = new FlxEmitter(x, y, 60);
			var pixelParticle:FlxParticle;
			for (var i:uint=0; i < 30; i++) {
				pixelParticle = new FlxParticle();
				pixelParticle.makeGraphic(Math.floor(Math.random()*2)+1, Math.floor(Math.random()*2)+1, 0xFFFFFFFF);
				emitter.add(pixelParticle);
				pixelParticle = new FlxParticle();
				pixelParticle.makeGraphic(Math.floor(Math.random()*2)+1, Math.floor(Math.random()*2)+1, color);
				emitter.add(pixelParticle);
			}
			emitter.maxRotation = 0;
			emitter.minRotation = 0;
			add(emitter);
			emitter.start(true, 4);
		}
		
	}
}
