package
{
	import org.flixel.FlxSprite;
	
	public class Kid extends FlxSprite
	{
		public function Kid(X:Number=0, Y:Number=0, graphic:Class=null)
		{
			super(X, Y);
			loadGraphic(graphic, true, false, 20, 21);
			addAnimation("Bounce", [3,0], 3, true);
			addAnimation("Jump", [3,0,1,2], 3, true);
			addAnimation("Shoot", [3,4], 3, false);
			
			play("Jump");
		}
		
		public function bounce():void {
			play("Bounce");
		}
	}
}
