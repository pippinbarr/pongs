package
{
	import org.flixel.*;

	public class SeriousPong extends StandardPong
	{
		public static const menuName:String = "SERIOUS PONG";

		private const LAUNCHING:uint = 4;

		private var _launchLeft:Boolean = (Math.random() < 0.5);

		[Embed(source="/assets/images/flag1.png")]
		private const FLAG_ONE:Class;
		[Embed(source="/assets/images/flag2.png")]
		private const FLAG_TWO:Class;
		[Embed(source="/assets/images/refugee.png")]
		private const REFUGEE:Class;


		public function SeriousPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"AVOID MISSING REFUGEE FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";

			if (_launchLeft) _leftScoreLabel.text = "ILLEGAL\nRE-ENTRIES";
			else _leftScoreLabel.text = "REFUGEES\nTAKEN IN";

			if (!_launchLeft) _rightScoreLabel.text = "ILLEGAL\nRE-ENTRIES";
			else _rightScoreLabel.text = "REFUGEES\nTAKEN IN";

			_leftPaddle.loadGraphic(FLAG_ONE);
			_rightPaddle.loadGraphic(FLAG_TWO);
			_ball.loadGraphic(REFUGEE);

			_leftPaddle.x = 10;
			_rightPaddle.x = FlxG.width - 10 - _rightPaddle.width;
		}


		public override function update():void
		{
			if (_state == LAUNCHING)
			{
				if (_launchLeft)
				{
					_ball.x = _leftPaddle.x + _leftPaddle.width;
					_ball.y = _leftPaddle.y + _leftPaddle.height/2 - _ball.height/2;
				}
				else
				{
					_ball.x = _rightPaddle.x - _ball.width;
					_ball.y = _rightPaddle.y + _rightPaddle.height/2 - _ball.height/2;
				}
			}

			super.update();
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


		protected override function gameOver():void
		{
			_state = GAMEOVER;

			_timer.stop();

			deactivate();

			if (_leftScore < _rightScore)
			{
				_winnerText.x = 0;
				_resultText.x = 0;
				_winnerBG.x = 0 + 20;
				_winnerBlackFrame.x = 0 + 5;
				_winnerWhiteFrame.x = 0 + 15;
			}
			else if (_rightScore < _leftScore)
			{
				_winnerText.x = FlxG.width/2;
				_resultText.x = FlxG.width/2;
				_winnerBG.x = FlxG.width/2 + 20;
				_winnerBlackFrame.x = FlxG.width/2 + 5;
				_winnerWhiteFrame.x = FlxG.width/2 + 15;

			}
			_winnerText.y = 200;
			_resultText.y = 250;
			_winnerBG.y = 150 - 5;
			_winnerBlackFrame.y = 150 - 15;
			_winnerWhiteFrame.y = 150 - 10;

			_winnerBG.visible = true;
			_winnerBlackFrame.visible = true;
			_winnerWhiteFrame.visible = true;
			_winnerText.visible = true;
			_resultText.visible = true;

			_ball.visible = false;
		}


		protected override function resetPlay():void
		{
			_state = LAUNCHING;

			activate();

			// Put the ball in the middle of the screen
			if (_launchLeft)
			{
				//_ball.x = 20;
				_ball.x = _leftPaddle.x + _leftPaddle.width + _ball.width;
				_ball.y = _leftPaddle.y + (_leftPaddle.height/2) - (_ball.height/2);
			}
			else if (!_launchLeft)
			{
				_ball.x = _rightPaddle.x - _ball.width;
				_ball.y = _rightPaddle.y + (_rightPaddle.height/2) - (_ball.height/2);
			}

			_ball.velocity.x = 0;
			_ball.velocity.y = 0;

			// Launch the ball after a delay
			_timer.start(2,1,launchBall);
		}


		protected override function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;

			if (_launchLeft)
			{
				_ballDirection = 0;
				_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED + (_leftPaddle.velocity.y * Globals.PADDLE_BALL_INFLUENCE_FACTOR);

			}
			else if (!_launchLeft)
			{
				_ballDirection = Math.PI;
				_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED + (_rightPaddle.velocity.y * Globals.PADDLE_BALL_INFLUENCE_FACTOR);
			}
			_ball.velocity.x = Math.cos(_ballDirection) * Globals.BALL_SPEED;
		}


		protected override function handleSpacePressed():void
		{
			super.handleSpacePressed();

			if (FlxG.keys.SPACE && (_state == INSTRUCTIONS || _state == GAMEOVER))
			{
				_launchLeft = (Math.random() < 0.5);

				if (_launchLeft) _leftScoreLabel.text = "ILLEGAL\nRE-ENTRIES";
				else _leftScoreLabel.text = "REFUGEES\nTAKEN IN";

				if (!_launchLeft) _rightScoreLabel.text = "ILLEGAL\nRE-ENTRIES";
				else _rightScoreLabel.text = "REFUGEES\nTAKEN IN";
			}
		}


		public override function destroy():void
		{
			super.destroy();
		}
	}
}
