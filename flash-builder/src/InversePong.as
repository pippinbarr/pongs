package
{
	import org.flixel.*;
	
	public class InversePong extends StandardPong
	{	
		public static const menuName:String = "INVERSE PONG";
		
		private var _upperLeftPaddle:FlxSprite;
		private var _lowerLeftPaddle:FlxSprite;
		private var _upperRightPaddle:FlxSprite;
		private var _lowerRightPaddle:FlxSprite;
				
		
		public function InversePong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			BALL_SPEED = 1000;
			_ball.maxVelocity.x = BALL_SPEED;
			_ball.maxVelocity.y = BALL_SPEED;

			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"MISS BALL FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			// Make the left paddle
			_upperLeftPaddle = new FlxSprite(10, Globals.PADDLE_START_Y - FlxG.height);
			_upperLeftPaddle.makeGraphic(Globals.PADDLE_WIDTH, FlxG.height, 0xFFFFFFFF);
			_upperLeftPaddle.immovable = true;
			_upperLeftPaddle.elasticity = 1;
			
			_lowerLeftPaddle = new FlxSprite(10, Globals.PADDLE_START_Y + Globals.PADDLE_HEIGHT);
			_lowerLeftPaddle.makeGraphic(Globals.PADDLE_WIDTH, FlxG.height, 0xFFFFFFFF);
			_lowerLeftPaddle.immovable = true;
			_lowerLeftPaddle.elasticity = 1;
			
			// Make the right paddle
			_upperRightPaddle = new FlxSprite(FlxG.width - 10 - Globals.PADDLE_WIDTH, Globals.PADDLE_START_Y - FlxG.height);
			_upperRightPaddle.makeGraphic(Globals.PADDLE_WIDTH, FlxG.height, 0xFFFFFFFF);
			_upperRightPaddle.immovable = true;
			_upperRightPaddle.elasticity = 1;
			
			_lowerRightPaddle = new FlxSprite(FlxG.width - 10 - Globals.PADDLE_WIDTH, Globals.PADDLE_START_Y + Globals.PADDLE_HEIGHT);
			_lowerRightPaddle.makeGraphic(Globals.PADDLE_WIDTH, FlxG.height, 0xFFFFFFFF);
			_lowerRightPaddle.immovable = true;
			_lowerRightPaddle.elasticity = 1;
			
			remove(_leftPaddle);
			remove(_rightPaddle);

			add(_upperLeftPaddle);
			add(_lowerLeftPaddle);
			_upperLeftPaddle.visible = false;
			_lowerLeftPaddle.visible = false;
			add(_upperRightPaddle);
			add(_lowerRightPaddle);
			_upperRightPaddle.visible = false;
			_lowerRightPaddle.visible = false;
		}
		
		
		protected override function doCollisions():void
		{
			FlxG.collide(_ball, _walls, wallHit);
			FlxG.collide(_upperLeftPaddle, _ball, paddleHit);
			FlxG.collide(_lowerLeftPaddle, _ball, paddleHit);
			FlxG.collide(_upperRightPaddle, _ball, paddleHit);
			FlxG.collide(_lowerRightPaddle, _ball, paddleHit);
		}
		
		
		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;
			
			// Check if the ball has gone off the screen
			if (ball.x + ball.width < 0)
			{
				_leftScore++;
				_lastPoint = PLAYER_1;
				point = true;
			}
			else if (ball.x > FlxG.width)
			{
				_rightScore++;
				_lastPoint = PLAYER_2;
				point = true;
			}
			
			setScores(_leftScore,_rightScore);
			
			if (point && !gameIsOver())
			{
				postPoint();
			}
		}
		
		
		protected override function activate():void
		{
			_ball.active = true;
			_upperLeftPaddle.active = true;
			_lowerLeftPaddle.active = true;
			_upperRightPaddle.active = true;
			_lowerRightPaddle.active = true;
		}
		
		protected override function deactivate():void
		{
			_ball.active = false;
			_upperLeftPaddle.active = false;
			_lowerLeftPaddle.active = false;
			_upperRightPaddle.active = false;
			_lowerRightPaddle.active = false;
		}
		
		
		protected override function handlePaddleInput():void
		{
			_upperLeftPaddle.velocity.y = 0;
			_lowerLeftPaddle.velocity.y = 0;
			_upperRightPaddle.velocity.y = 0;
			_lowerRightPaddle.velocity.y = 0;
			
			// RIGHT PADDLE
			if (FlxG.keys.UP)
			{
				_upperRightPaddle.velocity.y = -Globals.PADDLE_SPEED;
				_lowerRightPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.DOWN)
			{
				_upperRightPaddle.velocity.y = Globals.PADDLE_SPEED;
				_lowerRightPaddle.velocity.y = Globals.PADDLE_SPEED;
			}
			
			if (_upperRightPaddle.y + _upperRightPaddle.height < 0)
			{
				_upperRightPaddle.y = 0 - _upperRightPaddle.height;
				_lowerRightPaddle.y = 0 + Globals.PADDLE_HEIGHT;
			}
			if (_lowerRightPaddle.y > FlxG.height)
			{
				_lowerRightPaddle.y = FlxG.height;
				_upperRightPaddle.y = FlxG.height - Globals.PADDLE_HEIGHT - _upperRightPaddle.height;
			}
			
			// LEFT PADDLE
			if (FlxG.keys.W)
			{
				_upperLeftPaddle.velocity.y = -Globals.PADDLE_SPEED;
				_lowerLeftPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.S)
			{
				_upperLeftPaddle.velocity.y = Globals.PADDLE_SPEED;
				_lowerLeftPaddle.velocity.y = Globals.PADDLE_SPEED;
			}
			
			if (_upperLeftPaddle.y + _upperLeftPaddle.height < 0)
			{
				_upperLeftPaddle.y = 0 - _upperLeftPaddle.height;
				_lowerLeftPaddle.y = 0 + Globals.PADDLE_HEIGHT;
			}
			if (_lowerLeftPaddle.y > FlxG.height)
			{
				_lowerLeftPaddle.y = FlxG.height;
				_upperLeftPaddle.y = FlxG.height - Globals.PADDLE_HEIGHT - _upperLeftPaddle.height;
			}
		}
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_upperLeftPaddle.visible = true;
			_lowerLeftPaddle.visible = true;
			_upperRightPaddle.visible = true;
			_lowerRightPaddle.visible = true;
		}
		
		
		public override function destroy():void
		{
			super.destroy();

			this._upperLeftPaddle.destroy();
			this._lowerLeftPaddle.destroy();
			this._upperRightPaddle.destroy();
			this._lowerRightPaddle.destroy();
		}
	}
}