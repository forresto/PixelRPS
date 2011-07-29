package
{
	import flash.display.Graphics;
	
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="../assets/post.png")] private var imgPost:Class;
		[Embed(source="../assets/blue.png")] private var imgBlueKid:Class;
		[Embed(source="../assets/red.png")] private var imgRedKid:Class;
		[Embed(source="../assets/blue-hands.png")] private var imgBlueHands:Class;
		[Embed(source="../assets/red-hands.png")] private var imgRedHands:Class;
		
		public var blueTeam:FlxGroup;
		public var redTeam:FlxGroup;
		public var posts:FlxGroup;
		
		public var numPosts:uint = 10;
		public var teamSize:uint = 5;
		
		private var blueShown:uint = 1;
		private var redShown:uint = 1;
		private var bluePoints:uint = teamSize;
		private var redPoints:uint = teamSize;
		
		private var frameCount:uint = 0;
		private var introStep:String = "Jump";
		
		private var blueHand:KidHands = new KidHands(48, 54, imgBlueHands);
		private var redHand:KidHands = new KidHands(62, 54, imgRedHands);
		
		private var status:FlxText;
		private var blueScore:FlxText;
		private var redScore:FlxText;
		
		override public function create():void
		{
			status = new FlxText(0, 0, FlxG.width, "RPS BATTLE GO")
			add(status);

			blueScore = new FlxText(0, 15, 20, "")
			add(blueScore);

			redScore = new FlxText(100, 15, 20, "")
			add(redScore);

			redTeam = new FlxGroup();
			blueTeam = new FlxGroup();
			posts = new FlxGroup();
			
			for(var i:int = 0; i < numPosts; i++)
			{
				posts.add(new FlxSprite(i*12+10, 66, imgPost));
				var newBlue:Kid = new Kid(i*12, 50, imgBlueKid);
				newBlue.visible = i==0 ? true : false;
				blueTeam.add(newBlue);
				var newRed:Kid = new Kid(110-i*12, 50, imgRedKid);
				newRed.visible = i==0 ? true : false;
				redTeam.add(newRed);
			}
			
			add(posts);
			add(blueTeam);
			add(redTeam);
			
			add(redHand);
			add(blueHand);
			redHand.visible = false;
			blueHand.visible = false;
			
		}
		
		override public function update():void
		{
			super.update();
			if (frameCount >= 15) {
				// I want to control all of the animation here instead of FlxSprite.play()
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
						boom(blueTeam.members[blueShown-1].x, blueTeam.members[blueShown-1].y+5, 0xFF0000FF);
						blueTeam.members[blueShown-1].visible = false;
						blueShown--;
						blueHand.x -= 12;
						redHand.x -= 12;
					}
					if (redShown > redPoints) {
						boom(redTeam.members[redShown-1].x+5, redTeam.members[redShown-1].y+5, 0xFFFF0000);
						redTeam.members[redShown-1].visible = false;
						redShown--;
						blueHand.x += 12;
						redHand.x += 12;
					}
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
					}
					break;
				case "Dance":
					allFrame(0);
					introStep = "Dance2";
					break;
				case "Dance2":
					allFrame(3);
					introStep = "Dance";
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
					break;
				case "BounceUp2":
					allFrame(0, true);
					blueHand.y -= 1;
					redHand.y -= 1;
					introStep = "BounceDown3";
					break;
				case "AikoDeshou":
					allFrame(0, true);
					introStep = "BounceDown3";
					break;
				case "BounceDown3":
					allFrame(3, true);
					blueHand.y += 1;
					redHand.y += 1;
					introStep = "BounceUp3";
					break;
				case "BounceUp3":
					allFrame(0, true);
					blueHand.y -= 1;
					redHand.y -= 1;
					introStep = "Shoot";
					break;
				case "Shoot":
					allFrame(3, true);
					blueHand.randomFrame();
					redHand.randomFrame();
					//blueHand.frame = redHand.frame;
					if (blueHand.frame == redHand.frame) {
						// Tie
						status.text = "Tie...";
						introStep = "AikoDeshou";
					} else if ((blueHand.frame == 0 && redHand.frame == 2) || (blueHand.frame == 1 && redHand.frame == 0) || (blueHand.frame == 2 && redHand.frame == 1)) {
						// Blue wins
						bluePoints++;
						redPoints--;
						blueScore.text = bluePoints.toString();
						redScore.text = redPoints.toString();
						status.text = "Blue wins!";
						introStep = "Jump";
					} else {
						// Red wins
						redPoints++;
						bluePoints--;
						blueScore.text = bluePoints.toString();
						redScore.text = redPoints.toString();
						status.text = "Red wins!";
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
		
		private function boom(x:int, y:int, color:uint=0xFFFFFFFF):void {
			
			var emitter:FlxEmitter = new FlxEmitter(x, y, 40);
			var pixelParticle:FlxParticle;
			for (var i:uint=0; i < 20; i++) {
				pixelParticle = new FlxParticle();
				pixelParticle.makeGraphic(2, 2, 0xFFFFFFFF);
				emitter.add(pixelParticle);
				pixelParticle = new FlxParticle();
				pixelParticle.makeGraphic(2, 2, color);
				emitter.add(pixelParticle);
			}
			add(emitter);
			emitter.start(true, 4);
		}
		
	}
}
