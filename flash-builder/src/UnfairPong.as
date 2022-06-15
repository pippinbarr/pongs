package
{
	import org.flixel.*;
	
	public class UnfairPong extends StandardPong
	{	
		public static const menuName:String = "UNFAIR PONG";
		
		
		public function UnfairPong()
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
		}
		
		
		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;
			
			// Check if the ball has gone off the screen
			if (ball.x + ball.width < 0)
			{
				if (_rightPaddle.height > _leftPaddle.height)
				{
					_rightScore += 5;
				}
				else {
					_rightScore++;
				}
				_lastPoint = PLAYER_2;
				point = true;
			}
			else if (ball.x > FlxG.width)
			{
				if (_leftPaddle.height > _rightPaddle.height)
				{
					_leftScore += 5;
				}
				else {
					_leftScore++;
				}
				_lastPoint = PLAYER_1;
				point = true;
			}
			
			setScores(_leftScore,_rightScore);
			
			if (point && !gameIsOver())
			{
				postPoint();
			}
		}
		
		
		protected override function handleSpacePressed():void
		{			
			if (FlxG.keys.SPACE && (_state == INSTRUCTIONS || _state == GAMEOVER))
			{
				if (Math.random() > 0.5)
				{
					_leftPaddle.makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT*4, 0xFFFFFFFF);			
					_rightPaddle.makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT/6, 0xFFFFFFFF);
				}
				else
				{
					_leftPaddle.makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT/6, 0xFFFFFFFF);
					_rightPaddle.makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT*4, 0xFFFFFFFF);
				}
			}
			
			super.handleSpacePressed();
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}