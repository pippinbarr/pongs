package
{

	import org.flixel.*;

	[SWF(width = "640", height = "480", backgroundColor = "#000000")]

	public class Pongs extends FlxGame
	{
		public function Pongs()
		{
			super(640,480,ClickToPong,Globals.ZOOM,30,30);

			this.useSoundHotKeys = false;
			FlxG.volume = 1.0;

		}
	}
}
