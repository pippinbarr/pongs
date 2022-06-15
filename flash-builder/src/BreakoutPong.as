package
{
	import org.flixel.*;
	
	public class BreakoutPong extends StandardPong
	{	
		public static const menuName:String = "BREAKOUT PONG";

		public function BreakoutPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
		}
		
		protected override function doCollisions():void
		{
			FlxG.collide(_ball, _walls, wallHit);
			FlxG.collide(_leftPaddle, _ball, paddleHit);
			FlxG.collide(_rightPaddle, _ball, paddleHit);	
			FlxG.collide(_ball, _divider, dividerHit);
		}
		
		private function dividerHit(_ball:FlxObject, _dividerBlock:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);

			_dividerBlock.kill();
			_dividerBlock.exists = false;
			
			if (_ball.x > FlxG.width/2)
			{
				_rightScore++;
			}
			else if (_ball.x < FlxG.width/2)
			{
				_leftScore++;
			}
			setScores(_leftScore,_rightScore);
			
			_ballDirection = Math.atan2(_ball.velocity.y,_ball.velocity.x);
			_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED;		
		}
		
		
		protected override function resetPlay():void
		{
			_divider.callAll("revive");
			
			super.resetPlay();
		}
		
		protected override function resetBall(ball:FlxSprite):void
		{
			super.resetBall(ball);
			
			if (_lastPoint == PLAYER_1)
			{
				ball.x = FlxG.width/2 - ball.width*2;
			}
			else if (_lastPoint == PLAYER_2)
			{
				ball.x = FlxG.width/2 + ball.width;
			}
		}
	}
}