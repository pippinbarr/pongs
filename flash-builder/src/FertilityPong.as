package
{
	import org.flixel.*;
	
	public class FertilityPong extends StandardPong
	{	
		public static const menuName:String = "FERTILITY PONG";

		private var _balls:FlxGroup;
						
		
		public function FertilityPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"AVOID MISSING BALLS FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			// Make the ball
			_balls = new FlxGroup();
			
			var ball:FlxSprite = _balls.recycle(FlxSprite) as FlxSprite;
			ball.makeGraphic(10,10,0xFFFFFFFF);		
			ball.elasticity = 1;
			ball.maxVelocity.x = 300;
			ball.maxVelocity.y = 300;
			
			_balls.add(ball);
			
			remove(_ball);
			
			add(_balls);
			_balls.visible = false;
			
			// And set the starting state...
			_state = INSTRUCTIONS;
			
			OVERRIDE_UPDATE = true;
		}
		
		
		public override function update():void
		{
			super.update();
			
			handleInput();
			
			// We only handle collisions and so on if the game is playing
			if (_state == PLAYING)
			{
				for (var i:int = 0; i < _balls.length; i++)
				{
					if (_balls.members[i].alive)
						checkBall(_balls.members[i]);
					if (_balls.getFirstAlive() == null)
						resetPlay();
				}
				
				FlxG.collide(_balls, _walls, wallHit);
				FlxG.collide(_leftPaddle, _balls, paddleHit);
				FlxG.collide(_rightPaddle, _balls, paddleHit);				
			}
		}
		
		
		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;
			
			// If the ball has gone off the left side of the screen
			// Increase the right hand score, update the text, set point to true
			if (ball.x + ball.width < 0)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				ball.kill();
				
				_rightScore++;
				_lastPoint = PLAYER_2;

				point = true;
			}
				// If the ball has gone off the right side of the screen
				// Increase the left hand score, update the text, set point to true
			else if (ball.x > FlxG.width)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				ball.kill();
				
				_leftScore++;
				_lastPoint = PLAYER_1;
				
				point = true;
			}
			
			setScores(_leftScore,_rightScore);
			
			// If either player is at or over the winning score
			// and is at least two ahead...
			if (gameIsOver())
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				gameOver();
			}
				// Otherwise, if a point was scored, we go into the after point mode which
				// means delaying relaunching the ball
			else if (point && _balls.getFirstExtant() == null)
			{
				resetPlay();
			}
		}

		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);
			// USE A MORE "CONSTANT SPEED"
			var ballDirection:Number = Math.atan2(ball.velocity.y,ball.velocity.x);
			//_ball.velocity.x = Math.cos(_ballDirection) * BALL_SPEED;
			ball.velocity.y = Math.sin(ballDirection) * Globals.BALL_SPEED + (paddle.velocity.y * Globals.PADDLE_BALL_INFLUENCE_FACTOR);
			
			var newBall:FlxSprite = _balls.recycle(FlxSprite) as FlxSprite;
			
			newBall.revive();
			newBall.active = true;
			
			newBall.makeGraphic(10,10,0xFFFFFFFF);
			newBall.x = ball.x;
			newBall.y = ball.y;
			newBall.elasticity = 1;
			
			newBall.velocity.y = -(Math.sin(ballDirection) * Globals.BALL_SPEED + (paddle.velocity.y * Globals.PADDLE_BALL_INFLUENCE_FACTOR));
			
			var newXVelocity:Number = (Math.random() * 40 - 80);
			
			if (newXVelocity < 0 && newXVelocity > -20)
				newXVelocity = -20;
			else if (newXVelocity > 0 && newXVelocity < 20)
				newXVelocity = 20;
			
			newBall.velocity.x = ball.velocity.x + newXVelocity;
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
			
			_balls.setAll("active",false);
		}
		
		
		protected override function resetPlay():void
		{
			_state = PLAYING;
			
			_balls.callAll("kill");
			
			var ball:FlxSprite = _balls.recycle(FlxSprite) as FlxSprite;
			ball.makeGraphic(10,10,0xFFFFFFFF);		
			ball.revive();	
			
			ball.active = true;
			
			activate();
			
			_leftPaddle.active = true;
			_rightPaddle.active = true;
			
			resetBall(ball);
			
			// Launch the ball after a delay
			_timer.start(Globals.BALL_LAUNCH_DELAY,1,launchBall);
		}
		
		
		protected override function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			var ball:FlxSprite = _balls.getFirstAlive() as FlxSprite;
						
			setLaunchVelocity(ball);
		}
		
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_balls.visible = true;
		}
		
		
		protected override function activate():void
		{
			_balls.active = true;
			_leftPaddle.active = true;
			_rightPaddle.active = true;
		}
		
		
		protected override function deactivate():void
		{
			_balls.active = false;
			_leftPaddle.active = false;
			_rightPaddle.active = false;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			this._balls.destroy();
		}
	}
}