package
{
	import org.flixel.*;
	
	public class TwoDPong extends StandardPong
	{	
		public static const menuName:String = "2D PONG";		
		
		public function TwoDPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [A] / [S] / [D] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] / [LEFT] / [RIGHT] TO MOVE\n\n" +
				"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			BALL_SPEED = 350;
		}
		
		

		
		protected override function doCollisions():void
		{
			super.doCollisions();
			
			_leftPaddle.immovable = false;
			_rightPaddle.immovable = false;
			FlxG.overlap(_leftPaddle,_rightPaddle, FlxObject.separate);
			_leftPaddle.immovable = true;
			_rightPaddle.immovable = true;
		}
		
				
		private function paddleCollision(paddle:FlxObject, paddle2:FlxObject):void
		{
			paddle.immovable = false;
			paddle2.immovable = false;
			var separated:Boolean = FlxObject.separate(paddle,paddle2);
			paddle.immovable = true;
			paddle2.immovable = true;
		}
		
		
		protected override function handlePaddleInput():void
		{	
			// Zero the velocities to start
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;
			_leftPaddle.velocity.x = 0;
			_rightPaddle.velocity.x = 0;
			
			// RIGHT PADDLE
			if (FlxG.keys.UP && _rightPaddle.y > 0)
			{
				_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.DOWN && _rightPaddle.y + _rightPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
			}
			
			if (FlxG.keys.LEFT)
			{
				_rightPaddle.velocity.x = -Globals.PADDLE_SPEED/2;
			}
			else if (FlxG.keys.RIGHT)
			{
				_rightPaddle.velocity.x = Globals.PADDLE_SPEED/2;
			}
			if (_rightPaddle.y < 0)
			{
				_rightPaddle.y = 0;
			}
			if (_rightPaddle.y + _rightPaddle.height > FlxG.height)
			{
				_rightPaddle.y = FlxG.height - _rightPaddle.height;
			}
			if (_rightPaddle.x < 10)
				_rightPaddle.x = 10;
			if (_rightPaddle.x + _rightPaddle.width > FlxG.width - 10)
				_rightPaddle.x = FlxG.width - 10 - _rightPaddle.width;
			
			// LEFT PADDLE
			if (FlxG.keys.W && _leftPaddle.y > 0)
			{
				_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.S && _leftPaddle.y + _leftPaddle.height < FlxG.height)
			{
				_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
			}
			if (FlxG.keys.A)
			{
				_leftPaddle.velocity.x = -Globals.PADDLE_SPEED/2;
			}
			else if (FlxG.keys.D)
			{
				_leftPaddle.velocity.x = Globals.PADDLE_SPEED/2;
			}
			if (_leftPaddle.y < 0)
			{
				_leftPaddle.y = 0;
			}
			if (_leftPaddle.y + _leftPaddle.height > FlxG.height)
			{
				_leftPaddle.y = FlxG.height - _leftPaddle.height;
			}
			if (_leftPaddle.x < 10)
				_leftPaddle.x = 10;
			if (_leftPaddle.x + _leftPaddle.width > FlxG.width - 10)
				_leftPaddle.x = FlxG.width - 10 - _leftPaddle.width;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}