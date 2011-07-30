package
{
	import org.flixel.*;
	
	[SWF(width="450", height="300", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class PixelRPS extends FlxGame
	{
		public function PixelRPS()
		{
			super(150, 100, MenuState, 3, 60, 30, true);
		}
	}
}
