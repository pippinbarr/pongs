package
{
	import org.flixel.*;

	public class StandardPong extends FlxState
	{
		protected const INSTRUCTIONS:uint = 0;
		protected const PLAYING:uint = 1;
		protected const AFTER_POINT:uint = 2;
		protected const GAMEOVER:uint = 3;

		protected var _state:uint = INSTRUCTIONS;

		protected var BALL_SPEED:Number = Globals.BALL_SPEED;
		protected var PADDLE_SPEED:Number = Globals.PADDLE_SPEED;
		protected var PADDLE_INFLUENCE:Number = Globals.PADDLE_BALL_INFLUENCE_FACTOR;
		protected const PLAYER_1:uint = 0;
		protected const PLAYER_2:uint = 1;
		protected const NONE:uint = 2;

		protected var _lastPoint:uint = Math.floor(Math.random() * 2);
		protected var _lastHit:uint = NONE;

		protected var _leftPaddle:FlxSprite;
		protected var _rightPaddle:FlxSprite;
		protected var _ball:FlxSprite;

		protected var _ballDirection:Number; // Angle in radians the ball is moving along

		protected var _walls:FlxGroup;
		protected var _topWall:FlxTileblock;
		protected var _bottomWall:FlxTileblock;

		protected var _divider:FlxGroup;

		protected var _leftScore:int = 0;
		protected var _leftScoreText:FlxText;
		protected var _rightScore:int = 0;
		protected var _rightScoreText:FlxText;

		protected var _leftScoreLabel:FlxText;
		protected var _rightScoreLabel:FlxText;

		protected var _titleText:FlxText;
		protected var _instructionsText:FlxText;
		protected var _instructionsString:String = "" +
			"PLAYER 1: [W] / [S] TO MOVE\n\n" +
			"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
			"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
			"[SPACE] TO START\n[ESCAPE] TO QUIT";
		protected var _winnerText:FlxText;
		protected var _winnerString:String = "" +
			"WINNER\n\n";
		protected var _winnerBG:FlxSprite;
		protected var _winnerBlackFrame:FlxSprite;
		protected var _winnerWhiteFrame:FlxSprite;

		protected var _resultText:FlxText;
		protected var _resultString:String = "" +
			"[SPACE] TO RESTART\n" +
			"[ESCAPE] TO EXIT";

		protected var _timer:FlxTimer;


		protected var OVERRIDE_UPDATE:Boolean = false;
		protected var OVERRIDE_CREATE:Boolean = false;

		public function StandardPong()
		{
			super();
		}


		public override function create():void
		{
			super.create();

			if (OVERRIDE_CREATE)
				return;

			FlxG.bgColor = 0xFF000000;

			// Make the left paddle
			_leftPaddle = new FlxSprite(10, 220).makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT, 0xFFFFFFFF);
			_leftPaddle.immovable = true;
			_leftPaddle.elasticity = 1;

			// Make the right paddle
			_rightPaddle = new FlxSprite(FlxG.width - 20, 220).makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT, 0xFFFFFFFF);
			_rightPaddle.immovable = true;
			_rightPaddle.elasticity = 1;

			// Make the ball
			_ball = new FlxSprite(-20, 214).makeGraphic(Globals.BALL_SIZE, Globals.BALL_SIZE, 0xFFFFFFFF);
			_ball.elasticity = 1;
			_ball.maxVelocity.x = 350;
			_ball.maxVelocity.y = 350;

			// Set up the upper and lower walls for bouncing and put them in a group for colliding
			_walls = new FlxGroup;

			_topWall = new FlxTileblock(0, -100, FlxG.width, 100);
			_topWall.makeGraphic(FlxG.width, 100, 0xffababab);
			_walls.add(_topWall);

			_bottomWall = new FlxTileblock(0, FlxG.height, FlxG.width, 100);
			_bottomWall.makeGraphic(FlxG.width, 100, 0xffababab);
			_walls.add(_bottomWall);

			// Set up the dividing line
			_divider = new FlxGroup();
			for (var i:uint = 0; i < 24; i++)
			{
				var block:FlxSprite = new FlxSprite(FlxG.width/2 - 5, i * 20 + 5);
				block.makeGraphic(10,10,0xFFFFFFFF);
				block.immovable = true;
				block.elasticity = 1;
				_divider.add(block);
			}

			// Set up the scoring indicators
			_leftScoreText = new FlxText(FlxG.width/2 - 200 - 50,0,200,_leftScore.toString(),true);
			_leftScoreText.setFormat("Commodore",84,0xFFFFFF,"right");

			_rightScoreText = new FlxText(FlxG.width/2 + 50,0,200,_rightScore.toString(),true);
			_rightScoreText.setFormat("Commodore",84,0xFFFFFF,"left");

			_leftScoreLabel = new FlxText(FlxG.width/2 - 200 - 50,80,200,"",true);
			_leftScoreLabel.setFormat("Commodore",18,0xFFFFFF,"right");

			_rightScoreLabel = new FlxText(FlxG.width/2 + 50,80,200,"",true);
			_rightScoreLabel.setFormat("Commodore",18,0xFFFFFF,"left");

			_titleText = new FlxText(64,64,FlxG.width,"STANDARD PONG",true);
			_titleText.setFormat("Commodore",32,0xFFFFFF,"left");
			add(_titleText);

			_instructionsText = new FlxText(64,128,FlxG.width - 128,_instructionsString,true);
			_instructionsText.setFormat("Commodore",16,0xFFFFFF,"left");
			add(_instructionsText);

			_winnerBlackFrame = new FlxSprite(0,0);
			_winnerBlackFrame.makeGraphic(FlxG.width/2 - 20,FlxG.height/2 - 0,0xFF000000);
			_winnerBlackFrame.visible = false;

			_winnerWhiteFrame = new FlxSprite(0,0);
			_winnerWhiteFrame.makeGraphic(FlxG.width/2 - 30,FlxG.height/2 - 10,0xFFFFFFFF);
			_winnerWhiteFrame.visible = false;

			_winnerBG = new FlxSprite(0,0);
			_winnerBG.makeGraphic(FlxG.width/2 - 40,FlxG.height/2 - 20,0xFF000000);
			_winnerBG.visible = false;

			_winnerText = new FlxText(0,0,FlxG.width/2,_winnerString,true);
			_winnerText.setFormat("Commodore",32,0xFFFFFF,"center");
			_winnerText.visible = false;

			_resultText = new FlxText(0,0,FlxG.width/2,_resultString,true);
			_resultText.setFormat("Commodore",18,0xFFFFFF,"center");
			_resultText.visible = false;

			// We will want to use a timer
			_timer = new FlxTimer();

			add(_leftScoreText);
			_leftScoreText.visible = false;
			add(_rightScoreText);
			_rightScoreText.visible = false;

			_leftScoreLabel.visible = false;
			add(_leftScoreLabel);
			_rightScoreLabel.visible = false;
			add(_rightScoreLabel);

			add(_ball);
			_ball.visible = false;

			add(_leftPaddle);
			_leftPaddle.visible = false;
			add(_rightPaddle);
			_rightPaddle.visible = false;

			add(_divider);
			_divider.visible = false;
			add(_walls);
			_walls.visible = false;

			add(_winnerBlackFrame);
			add(_winnerWhiteFrame);
			add(_winnerBG);
			add(_winnerText);
			add(_resultText);


			// And set the starting state...
			_state = INSTRUCTIONS;
		}


		public override function update():void
		{
			super.update();

			if (OVERRIDE_UPDATE) return;

			handleInput();

			// We only handle collisions and so on if the game is playing
			if (_state == PLAYING)
			{
				doCollisions();
				checkBall(_ball);
				checkGameOver();
			}
		}


		protected function doCollisions():void
		{
			FlxG.collide(_ball, _walls, wallHit);
			FlxG.collide(_leftPaddle, _ball, paddleHit);
			FlxG.collide(_rightPaddle, _ball, paddleHit);
		}


		protected function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;

			// Check if the ball has gone off the screen
			if (ball.x + ball.width < 0)
			{
				_rightScore++;
				_lastPoint = PLAYER_2;
				point = true;
			}
			else if (ball.x > FlxG.width)
			{
				_leftScore++;
				_lastPoint = PLAYER_1;
				point = true;
			}

			setScores(_leftScore,_rightScore);

			if (point && !gameIsOver())
			{
				postPoint();
			}
		}


		protected function postPoint():void
		{
			FlxG.play(Assets.POINT_SOUND,0.5);
			resetPlay();
		}


		protected function checkGameOver():void
		{
			// If either player is at or over the winning score
			// and is at least two ahead...
			if (gameIsOver())
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				gameOver();
			}
		}


		protected function gameIsOver():Boolean
		{
			return (_leftScore >= Globals.GAME_OVER_SCORE && _leftScore - 2 >= _rightScore)  ||
				   (_rightScore >= Globals.GAME_OVER_SCORE && _rightScore - 2 >= _leftScore)
		}


		protected function wallHit(_ball:FlxObject, _wall:FlxObject):void
		{
			FlxG.play(Assets.WALL_SOUND);
		}


		protected function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);

			if (paddle.x > FlxG.width/2)
				_lastHit = PLAYER_2;
			else if (paddle.x < FlxG.width/2)
				_lastHit = PLAYER_1;

			var ballDirection:Number = Math.atan2(ball.velocity.y,ball.velocity.x);

			//ball.velocity.y = Math.sin(ballDirection) * BALL_SPEED + (paddle.velocity.y * PADDLE_INFLUENCE);
			ball.velocity.y += paddle.velocity.y;

			if (ball.x + ball.width > paddle.x && ball.x < paddle.x + paddle.width)
			{
				trace("SPECIAL CASE!");
				trace("ball.velocity.y = " + ball.velocity.y + ", paddle.velocity.y = " + paddle.velocity.y);
				// We have one of those "end impact" situations so move the ball away faster
				if (ball.velocity.y < 0 && ball.velocity.y > paddle.velocity.y)
				{
					trace("BOTH GOING UP");
					// Need the ball to go faster downwards!
					ball.velocity.y += (paddle.velocity.y - ball.velocity.y - 10);
				}
				else if (ball.velocity.y > 0 && ball.velocity.y < paddle.velocity.y)
				{
					trace("BOTH GOING DOWN");
					ball.velocity.y += (paddle.velocity.y - ball.velocity.y + 10);
				}
			}
		}


		protected function gameOver():void
		{
			_state = GAMEOVER;

			_timer.stop();

			deactivate();

			if (_leftScore > _rightScore)
			{
				_winnerText.x = 0;
				_resultText.x = 0;
				_winnerBG.x = 0 + 20;
				_winnerBlackFrame.x = 0 + 5;
				_winnerWhiteFrame.x = 0 + 15;
			}
			else if (_rightScore > _leftScore)
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


		protected function activate():void
		{
			_ball.active = true;
			_leftPaddle.active = true;
			_rightPaddle.active = true;
		}

		protected function deactivate():void
		{
			_ball.active = false;
			_leftPaddle.active = false;
			_rightPaddle.active = false;
		}


		protected function resetPlay():void
		{
			trace("resetPlay()");

			_timer.stop();

			_state = PLAYING;
			_lastHit = NONE;

			activate();

			resetBall(_ball);

			// Launch the ball after a delay
			_timer.start(Globals.BALL_LAUNCH_DELAY,1,launchBall);
		}


		protected function resetBall(ball:FlxSprite):void
		{
			trace("resetBall()");

			// Put the ball in the middle of the screen
			ball.x = FlxG.width/2 - ball.width/2;
			ball.y = FlxG.height/2 - ball.height/2;

			// Zero its velocity
			ball.velocity.x = 0;
			ball.velocity.y = 0;
		}


		protected function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;

			FlxG.play(Assets.WALL_SOUND);

			setLaunchVelocity(_ball);
		}


		protected function setLaunchVelocity(ball:FlxSprite):void
		{
			if (_lastPoint == PLAYER_2)
			{
				_ballDirection = (Math.random() * Math.PI/4) - Math.PI/8;
			}
			else if (_lastPoint == PLAYER_1)
			{
				_ballDirection = (Math.random() * Math.PI/4) + Math.PI - Math.PI/8;
			}
			ball.velocity.x = Math.cos(_ballDirection) * BALL_SPEED;
			ball.velocity.y = Math.sin(_ballDirection) * BALL_SPEED;
		}


		protected function handleInput():void
		{
			handleEscapePressed();
			handleSpacePressed();
			handlePaddleInput();
		}

		protected function handleEscapePressed():void
		{
			if (FlxG.keys.ESCAPE)
			{
				FlxG.switchState(new MenuState);
			}
		}


		protected function handleSpacePressed():void
		{
			// If we're looking at the instructions now, then remove them
			// and add the game components, then launch the ball
			if (_state == INSTRUCTIONS || _state == GAMEOVER)
			{
				if (FlxG.keys.SPACE)
				{
					trace("handleSpacePressed()");

					setScores(0,0);
					swapTitleAndPlayVisibles();
					resetPlay();
				}
				return;
			}
		}


		protected function swapTitleAndPlayVisibles():void
		{
			trace("swapTitleAndPlayVisibles()");

			_titleText.visible = false;
			_instructionsText.visible = false;

			_winnerText.visible = false;
			_resultText.visible = false;
			_winnerBlackFrame.visible = false;
			_winnerWhiteFrame.visible = false;
			_winnerBG.visible = false;

			_leftScoreText.visible = true;
			_rightScoreText.visible = true;
			_leftScoreLabel.visible = true;
			_rightScoreLabel.visible = true;

			_divider.visible = true;
			_walls.visible = true;

			_leftPaddle.visible = true;
			_rightPaddle.visible = true;
			_ball.visible = true;
		}


		protected function setScores(P1:int,P2:int):void
		{
			_leftScore = P1;
			_leftScoreText.text = _leftScore.toString();
			_rightScore = P2;
			_rightScoreText.text = _rightScore.toString();
		}


		protected function handlePaddleInput():void
		{
			// HANDLE PADDLE INPUT

			// Zero the velocities to start
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;

			// RIGHT PADDLE
			if (FlxG.keys.UP && _rightPaddle.y > 0)
			{
				_rightPaddle.velocity.y = -PADDLE_SPEED;
			}
			else if (FlxG.keys.DOWN && _rightPaddle.y + _rightPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y = PADDLE_SPEED;
			}
			if (_rightPaddle.y < 0)
			{
				_rightPaddle.y = 0;
			}
			if (_rightPaddle.y + _rightPaddle.height > FlxG.height)
			{
				_rightPaddle.y = FlxG.height - _rightPaddle.height;
			}

			// LEFT PADDLE
			if (FlxG.keys.W && _leftPaddle.y > 0)
			{
				_leftPaddle.velocity.y = -PADDLE_SPEED;
			}
			else if (FlxG.keys.S && _leftPaddle.y + _leftPaddle.height < FlxG.height)
			{
				_leftPaddle.velocity.y = PADDLE_SPEED;
			}
			if (_leftPaddle.y < 0)
			{
				_leftPaddle.y = 0;
			}
			if (_leftPaddle.y + _leftPaddle.height > FlxG.height)
			{
				_leftPaddle.y = FlxG.height - _leftPaddle.height;
			}
		}




		public override function destroy():void
		{
			super.destroy();

			this._ball.destroy();
			this._walls.destroy();
			this._divider.destroy();
			this._leftPaddle.destroy();
			this._rightPaddle.destroy();
			this._leftScoreText.destroy();
			this._rightScoreText.destroy();
			this._titleText.destroy();
			this._instructionsText.destroy();
			this._timer.destroy();
			this._winnerText.destroy();
			this._resultText.destroy();
			this._winnerBG.destroy();
			this._winnerBlackFrame.destroy();
			this._winnerWhiteFrame.destroy();
		}
	}
}
