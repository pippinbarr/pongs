package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	
	public class NoWallsPong extends StandardPong
	{	
		public static const menuName:String = "PONG SANS FRONTIERES";
		
		
		public function NoWallsPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			remove(_walls);
		}
		
		
		protected override function doCollisions():void
		{
			FlxG.collide(_leftPaddle, _ball, paddleHit);
			FlxG.collide(_rightPaddle, _ball, paddleHit);				
		}
		
		
		protected override function checkBall(ball:FlxSprite):void
		{
			super.checkBall(ball);
			
			if (ball.y + ball.height < 0)
			{
				ball.y = FlxG.height - ball.height;
			}
			else if (ball.y > FlxG.height)
			{
				ball.y = FlxG.height - ball.y;
			}
		}
		
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}