package
{
	import org.flixel.*;
	
	public class GhostPong extends StandardPong
	{	
		public static const menuName:String = "GHOST PONG";

		
		public function GhostPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_leftPaddle.alpha = 0.5;
			_rightPaddle.alpha = 0.5;
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		protected override function doCollisions():void
		{
			FlxG.collide(_ball, _walls, wallHit);
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}