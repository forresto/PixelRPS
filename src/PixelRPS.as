package
{
	import org.flixel.*;
	import flash.ui.Mouse;
	
	[SWF(width="800", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class PixelRPS extends FlxGame
	{
		public function PixelRPS()
		{
			super(200,150,PlayState,4);
			
			flash.ui.Mouse.show();
		}
	}
}
