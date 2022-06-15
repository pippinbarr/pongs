package
{
	import org.flixel.*;
	
	public class ShrinkPong extends StandardPong
	{
		public static const menuName:String = "SHRINK PONG";
		
		private const BALL_SHRINKAGE:Number = 2;
		private const STARTING_BALL_FACTOR:Number = 8;
		
		
		public function ShrinkPong()
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
				"DON'T BE THE ONE TO MAKE THE BALL VANISH\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			_ball.makeGraphic(Globals.BALL_SIZE * STARTING_BALL_FACTOR,Globals.BALL_SIZE * STARTING_BALL_FACTOR,0xFFFFFFFF);
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle,ball);
			
			shrinkBall();
		}
		
		protected override function wallHit(ball:FlxObject, wall:FlxObject):void
		{
			super.wallHit(ball,wall);
			
			shrinkBall();
		}
		
		
		private function shrinkBall():void
		{
			if (_ball.width - BALL_SHRINKAGE > 0) {
				_ball.makeGraphic(_ball.width - BALL_SHRINKAGE, _ball.height - BALL_SHRINKAGE, 0xFFFFFFFF);
			}
			else
			{
				if (_lastHit == PLAYER_1)
				{
					_rightScore++;
				}
				else
				{
					_leftScore++;
				}
				setScores(_leftScore,_rightScore);
				resetPlay();
			}
		}
		
		
		protected override function resetBall(ball:FlxSprite):void
		{
			ball.makeGraphic(Globals.BALL_SIZE * STARTING_BALL_FACTOR, Globals.BALL_SIZE * STARTING_BALL_FACTOR, 0xFFFFFFFF);
			super.resetBall(ball);
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}