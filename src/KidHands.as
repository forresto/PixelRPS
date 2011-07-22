package
{
	import org.flixel.FlxSprite;
	
	public class KidHands extends FlxSprite
	{
		public function KidHands(X:Number=0, Y:Number=0, graphic:Class=null)
		{
			super(X, Y);
			loadGraphic(graphic, true, false, 20, 10);
			addAnimation("R", [0], 3, false);
			addAnimation("P", [1], 3, false);
			addAnimation("S", [2], 3, false);
			
			play("R");
		}
	}
}
