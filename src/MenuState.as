package
{
	import flash.ui.Mouse;
	
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private var hands:FlxGroup;
		private var frameCount:uint = 0;
		
		override public function create():void
		{
			hands = new FlxGroup();
			var hand:KidHands;
			for (var i:int = 0; i < 8; i++) {
				// Blue side
				hand = new KidHands(-4, i*15-15, ImageResources.imgBlueHands);
				hand.randomFrame();
				hands.add(hand);
				// Red side
				hand = new KidHands(FlxG.width-16, i*15-15, ImageResources.imgRedHands);
				hand.randomFrame();
				hands.add(hand);
			}
			add(hands);
			
			var kid:Kid;
			for (i=0; i < 4; i++) {
				kid = new Kid(17, i*25+2, ImageResources.imgBlueKid);
				add(kid);
				kid.play("Bounce");
				kid = new Kid(FlxG.width-36, i*25+2, ImageResources.imgRedKid);
				add(kid);
				kid.play("Bounce");
			}
			
			var t:FlxText;
			t = new FlxText(0, 3, FlxG.width,"Pixel RPS");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			t = new FlxText(0, 27, FlxG.width, "Click, then press: \n" +
				"Space: Zero Player \n" +
				"A: Red Player  (ASD) \n" +
				"J: Blue Player  (JKL) \n" +
				"G: Two Player \n" +
				"Esc: Menu \n" +
				"(c)2011  sembiki.com");
			t.alignment = "center";
			add(t);
			
		}

		override public function update():void
		{
			super.update();
			
			if(FlxG.mouse.pressed()) {
				if (40 < FlxG.mouse.screenY && FlxG.mouse.screenY < 50) {
					FlxG.level = 0;
					FlxG.switchState(new PlayState());
				}
				else if (50 < FlxG.mouse.screenY && FlxG.mouse.screenY < 60) {
					FlxG.level = 1;
					FlxG.switchState(new PlayState());
				}
				else if (60 < FlxG.mouse.screenY && FlxG.mouse.screenY < 70) {
					FlxG.level = 2;
					FlxG.switchState(new PlayState());
				}
				else if (70 < FlxG.mouse.screenY && FlxG.mouse.screenY < 80) {
					FlxG.level = 3;
					FlxG.switchState(new PlayState());
				}
			}

			if(FlxG.keys.justPressed("SPACE"))
			{
				FlxG.level = 0;
				FlxG.switchState(new PlayState());
			}
			if(FlxG.keys.justPressed("A"))
			{
				FlxG.level = 1;
				FlxG.switchState(new PlayState());
			}
			if(FlxG.keys.justPressed("J"))
			{
				FlxG.level = 2;
				FlxG.switchState(new PlayState());
			}
			if(FlxG.keys.justPressed("G"))
			{
				FlxG.level = 3;
				FlxG.switchState(new PlayState());
			}
			
			if (frameCount >= 4) {
				frameCount = 0;
				for (var i:int=0; i<hands.length; i++) {
					hands.members[i].y++;
					if (hands.members[i].y >= FlxG.height+15){
						hands.members[i].y = -12;
						hands.members[i].randomFrame();
					} 
				}
			} else {
				frameCount++;
			}

		}
		
	}
}
