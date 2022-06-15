package
{
	import org.flixel.*;

	public class BallPong extends StandardPong
	{
		public static const menuName:String = "BALL PONG";

		private var _ballControlLeft:Boolean = (Math.random() < 0.5);

		public function BallPong()
		{
			super();
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";

			if (_ballControlLeft) _leftScoreLabel.text = "BALL";
			else _leftScoreLabel.text = "PADDLES";

			if (_ballControlLeft) _rightScoreLabel.text = "PADDLES";
			else _rightScoreLabel.text = "BALL";
		}


		public override function update():void
		{
			super.update();
		}


		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;

			// If the ball has gone off the left side of the screen
			// Increase the right hand score, update the text, set point to true
			if (ball.x + ball.width < 0)
			{
				if (_ballControlLeft)
				{
					_leftScore++;
				}
				else
				{
					_rightScore++;
				}
				_lastPoint = PLAYER_2;
				point = true;
			}
				// If the ball has gone off the right side of the screen
				// Increase the left hand score, update the text, set point to true
			else if (ball.x > FlxG.width)
			{
				if (_ballControlLeft)
				{
					_leftScore++;
				}
				else
				{
					_rightScore++;
				}

				_lastPoint = PLAYER_1;
				point = true;
			}
			setScores(_leftScore,_rightScore);


			// If either player is at or over the winning score
			// and is at least two ahead...
			if ((_leftScore >= Globals.GAME_OVER_SCORE && _leftScore - 2 >= _rightScore)  ||
				(_rightScore >= Globals.GAME_OVER_SCORE && _rightScore - 2 >= _leftScore))
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				gameOver();
			}
				// Otherwise, if a point was scored, we go into the after point mode which
				// means delaying relaunching the ball
			else if (point)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				resetPlay();
			}
		}


		protected override function paddleHit(_paddle:FlxObject, _ball:FlxObject):void
		{
			super.paddleHit(_paddle,_ball);

			if (!_ballControlLeft)
			{
				setScores(++_leftScore,_rightScore);
			}
			else
			{
				setScores(_leftScore,++_rightScore);
			}
		}


		protected override function handleSpacePressed():void
		{
			// If we're looking at the instructions now, then remove them
			// and add the game components, then launch the ball
			if (_state == INSTRUCTIONS || _state == GAMEOVER)
			{
				if (FlxG.keys.SPACE)
				{
					setScores(0,0);

					_ballControlLeft = (Math.random() < 0.5);
					if (_ballControlLeft)
					{
						_leftScoreLabel.text = "BALL";
						_rightScoreLabel.text = "PADDLES";
					}
					else {
						_leftScoreLabel.text = "PADDLES";
						_rightScoreLabel.text = "BALL";
					}

					swapTitleAndPlayVisibles();
					resetPlay();
				}
				return;
			}
		}


		override protected function handlePaddleInput():void
		{
			// HANDLE PADDLE INPUT
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;
			_ball.velocity.y = 0;

			if (_ballControlLeft)
			{
				if (FlxG.keys.UP && _rightPaddle.y > 0)
				{
					_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
					_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
				}
				else if (FlxG.keys.DOWN && _rightPaddle.y + _rightPaddle.height < FlxG.height)
				{
					_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
					_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
				}
				if (_rightPaddle.y < 0)
				{
					_rightPaddle.y = 0;
					_leftPaddle.y = 0;
				}
				if (_rightPaddle.y + _rightPaddle.height > FlxG.height)
				{
					_rightPaddle.y = FlxG.height - _rightPaddle.height;
					_leftPaddle.y = FlxG.height - _leftPaddle.height;
				}

				// BALL
				if (_ball.velocity.x == 0)
					return;

				if (FlxG.keys.W)
				{
					_ball.velocity.y = -Globals.BALL_SPEED/4;
				}
				else if (FlxG.keys.S)
				{
					_ball.velocity.y = Globals.BALL_SPEED/4;
				}
				if (_ball.y < 0)
					_ball.y = 0;
				if (_ball.y + _ball.height > FlxG.height)
					_ball.y = FlxG.height - _ball.height;
			}
			else if (!_ballControlLeft)
			{
				if (_ball.velocity.x == 0)
					return;

				if (FlxG.keys.W && _leftPaddle.y > 0)
				{
					_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
					_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
				}
				else if (FlxG.keys.S && _leftPaddle.y + _leftPaddle.height < FlxG.height)
				{
					_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
					_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
				}
				if (_leftPaddle.y < 0)
				{
					_rightPaddle.y = 0;
					_leftPaddle.y = 0;
				}
				if (_leftPaddle.y + _leftPaddle.height > FlxG.height)
				{
					_rightPaddle.y = FlxG.height - _rightPaddle.height;
					_leftPaddle.y = FlxG.height - _leftPaddle.height;
				}

				// BALL
				if (FlxG.keys.UP)
				{
					_ball.velocity.y = -Globals.BALL_SPEED/4;
				}
				else if (FlxG.keys.DOWN)
				{
					_ball.velocity.y = Globals.BALL_SPEED/4;
				}
				if (_ball.y < 0)
					_ball.y = 0;
				if (_ball.y + _ball.height > FlxG.height)
					_ball.y = FlxG.height - _ball.height;
			}
		}


		public override function destroy():void
		{
			super.destroy();
		}
	}
}
