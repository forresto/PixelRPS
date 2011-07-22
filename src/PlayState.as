package
{
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
		public var teamShown:uint = 0;
		public var introStep:String = "AddOne";
		
		public var blueHand:KidHands = new KidHands(48, 54, imgBlueHands);
		public var redHand:KidHands = new KidHands(62, 54, imgRedHands);
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"RPS BATTLE GO"));
			
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
		}
		
		override public function update():void
		{
			super.update();
			
			if(introStep=="AddOne" && blueTeam.members[0].frame == 2) {
				// Show team members until full
				introStep = "ComeIn";
				teamShown++;
			}
			if(introStep=="ComeIn" && blueTeam.members[0].frame == 3) {
				blueTeam.members[teamShown].visible = true;
				redTeam.members[teamShown].visible = true;
				introStep = "AddOne";
				
				if (teamShown == teamSize-1) {
					introStep = "BounceNow";
				}
			}
			if(introStep=="BounceNow") {
				// Full, so start bouncing
				blueTeam.callAll("bounce");
				redTeam.callAll("bounce");
				
				blueTeam.members[teamSize-1].play("Shoot");
				redTeam.members[teamSize-1].play("Shoot");
				
				introStep = "ShowHands";
			}
			if(introStep=="ShowHands" && blueTeam.members[teamSize-1].frame == 4) {
				// Add hands
				add(blueHand);
				add(redHand);
				
				introStep = "ReadyOne";
			}
			if(introStep=="ReadyOne" && blueTeam.members[0].frame == 3){
				// One
				blueHand.y += 1;
				redHand.y += 1;
				introStep = "ReadyOneUp";
			}
			if(introStep=="ReadyOneUp" && blueTeam.members[0].frame == 0){
				// One up
				blueHand.y -= 1;
				redHand.y -= 1;
				introStep = "ReadyTwo";
			}
			if(introStep=="ReadyTwo" && blueTeam.members[0].frame == 3){
				// Two
				blueHand.y += 1;
				redHand.y += 1;
				introStep = "ReadyTwoUp";
			}
			if(introStep=="ReadyTwoUp" && blueTeam.members[0].frame == 0){
				// Two up
				blueHand.y -= 1;
				redHand.y -= 1;
				introStep = "Shoot";
			}
			if(introStep=="Shoot" && blueTeam.members[0].frame == 3){
				// Rock, Paper, Scissors
				blueHand.randomFrame();
				redHand.randomFrame();
				
				introStep = "Reset";
			}
			if(introStep=="Reset" && blueTeam.members[0].frame == 0){
				// Reset
				blueHand.frame = 0;
				redHand.frame = 0;
				
				introStep = "ReadyOne";
			}

		}
		
	}
}
