package
{
	import org.flixel.*;
	
	[SWF(width="800", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class PixelRPS extends FlxGame
	{
		public function PixelRPS()
		{
			super(200, 150, PlayState, 4, 60, 30, true);
		}
	}
}
