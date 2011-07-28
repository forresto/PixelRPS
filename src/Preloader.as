package
{
	import org.flixel.system.FlxPreloader;

	public class Preloader extends FlxPreloader
	{
		public function Preloader()
		{
			className = "PixelRPS";
			minDisplayTime = 1000;
			super();
		}
	}
}
