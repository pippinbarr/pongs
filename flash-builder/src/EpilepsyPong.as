package
{
	import org.flixel.*;

	public class EpilepsyPong extends StandardPong
	{
		//public static const menuName:String = "EPILEPSY PONG";
		public static const menuName:String = "FLASHING PONG";

		public function EpilepsyPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;
		}


		public override function update():void
		{
			super.update();

			if (_state == PLAYING)
			{
				flipBackground();
			}
		}


		private function flipBackground():void
		{
			if (FlxG.bgColor == 0xFF000000)
			{
				FlxG.bgColor = 0xFFFFFFFF;
			}
			else
			{
				FlxG.bgColor = 0xFF000000;
			}
		}


		public override function destroy():void
		{
			super.destroy();
		}
	}
}
