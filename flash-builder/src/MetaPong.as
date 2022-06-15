package
{
	import org.flixel.*;

	public class MetaPong extends StandardPong
	{
		public static const menuName:String = "PONG PONG";

		[Embed(source="/assets/images/PongCabinet.png")]
		private const CABINET:Class;
		[Embed(source="/assets/images/dial.png")]
		private const LEFT_DIAL:Class;
		[Embed(source="/assets/images/dial2.png")]
		private const RIGHT_DIAL:Class;

		private const OFFSET:uint = 46;
		private const SCREEN_LEFT:uint = 206;
		private const SCREEN_TOP:uint = 162;
		private const SCREEN_HEIGHT:uint = 96;
		private const SCREEN_WIDTH:uint = 132;

		private var _cabinet:FlxSprite;
		private var _leftDial:FlxSprite;
		private var _rightDial:FlxSprite;
		private var _screenBG:FlxSprite;

		public function MetaPong()
		{
		}


		public override function create():void
		{
			OVERRIDE_CREATE = true;

			super.create();

			FlxG.bgColor = 0xFF000000;

			// META PONG

			_cabinet = new FlxSprite(OFFSET,0);
			_cabinet.loadGraphic(CABINET);
			add(_cabinet);
			_cabinet.visible = false;

			_leftDial = new FlxSprite(211,385);
			_leftDial.loadRotatedGraphic(LEFT_DIAL);
			add(_leftDial);
			_leftDial.visible = false;

			_rightDial = new FlxSprite(404,385);
			_rightDial.loadRotatedGraphic(LEFT_DIAL);
			add(_rightDial);
			_rightDial.visible = false;

			_screenBG = new FlxSprite(SCREEN_LEFT + OFFSET,SCREEN_TOP);
			_screenBG.makeGraphic(SCREEN_WIDTH,SCREEN_HEIGHT,0xFF404941);
			add(_screenBG);
			_screenBG.visible = false;



			// Make the left paddle
			_leftPaddle = new FlxSprite(SCREEN_LEFT + 2 + OFFSET, SCREEN_TOP + SCREEN_HEIGHT/2).makeGraphic(2, 6, 0xFFFFFFFF);
			_leftPaddle.immovable = true;
			_leftPaddle.elasticity = 1;
			_leftPaddle.maxVelocity.y = 50;

			// Make the right paddle
			_rightPaddle = new FlxSprite(SCREEN_LEFT + SCREEN_WIDTH - 4 + OFFSET, SCREEN_TOP + SCREEN_HEIGHT/2).makeGraphic(2, 6, 0xFFFFFFFF);
			_rightPaddle.immovable = true;
			_rightPaddle.elasticity = 1;
			_rightPaddle.maxVelocity.y = 50;

			// Make the ball
			_ball = new FlxSprite(FlxG.width/2, FlxG.height/2).makeGraphic(2,2, 0xFFFFFFFF);
			_ball.elasticity = 1;
			_ball.maxVelocity.x = 50;
			_ball.maxVelocity.y = 50;

			// Set up the upper and lower walls for bouncing and put them in a group for colliding
			_walls = new FlxGroup;

			_topWall = new FlxTileblock(0, SCREEN_TOP - 100, FlxG.width, 100);
			_topWall.makeGraphic(FlxG.width, 100, 0xffababab);
			_walls.add(_topWall);

			_bottomWall = new FlxTileblock(0, SCREEN_TOP + SCREEN_HEIGHT, FlxG.width, 100);
			_bottomWall.makeGraphic(FlxG.width, 100, 0xffababab);
			_walls.add(_bottomWall);

			// Set up the dividing line
			_divider = new FlxGroup();
			for (var i:uint = 0; i < 16; i++)
			{
				var block:FlxSprite = new FlxSprite(SCREEN_LEFT + SCREEN_WIDTH/2 + OFFSET, i * 6 + + 2 + SCREEN_TOP);
				block.makeGraphic(1,3,0xFFFFFFFF);
				block.immovable = true;
				block.elasticity = 1;
				_divider.add(block);
			}

			// Set up the scoring indicators
			_leftScoreText = new FlxText(SCREEN_LEFT + OFFSET + SCREEN_WIDTH/2 - 200 - 5,SCREEN_TOP,200,_leftScore.toString(),true);
			_leftScoreText.setFormat("Commodore",12,0xFFFFFF,"right");

			_rightScoreText = new FlxText(SCREEN_LEFT + OFFSET + SCREEN_WIDTH/2 + 5,SCREEN_TOP,200,_rightScore.toString(),true);
			_rightScoreText.setFormat("Commodore",12,0xFFFFFF,"left");

			_leftScoreLabel = new FlxText(FlxG.width/2 - 200 - 50,80,200,"",true);
			_leftScoreLabel.setFormat("Commodore",18,0xFFFFFF,"right");

			_rightScoreLabel = new FlxText(FlxG.width/2 + 50,80,200,"",true);
			_rightScoreLabel.setFormat("Commodore",18,0xFFFFFF,"left");

			_titleText = new FlxText(64,64,FlxG.width,"STANDARD PONG",true);
			_titleText.setFormat("Commodore",32,0xFFFFFF,"left");
			add(_titleText);
			_titleText.text = menuName;

			_instructionsText = new FlxText(64,128,FlxG.width - 128,_instructionsString,true);
			_instructionsText.setFormat("Commodore",16,0xFFFFFF,"left");
			add(_instructionsText);
			_instructionsText.text = "" +
				"DEPOSIT QUARTER\n" +
				"BALL WILL SERVE AUTOMATICALLY\n" +
				"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
				"PLAYER 1: [A] / [D] TO TURN DIAL\n\n" +
				"PLAYER 2: [LEFT] / [RIGHT] TO TURN DIAL\n\n" +
				"[SPACE] TO INSERT QUARTER\n[ESCAPE] TO QUIT";


			_winnerText = new FlxText(0,0,FlxG.width/2,_winnerString,true);
			_winnerText.setFormat("Commodore",32,0xFFFFFF,"center");
			_winnerText.visible = false;

			_resultText = new FlxText(0,0,FlxG.width/2,_resultString,true);
			_resultText.setFormat("Commodore",18,0xFFFFFF,"center");
			_resultText.visible = false;

			_winnerBlackFrame = new FlxSprite(0,0);
			_winnerBlackFrame.makeGraphic(FlxG.width/2 - 20,FlxG.height/2 - 0,0xFF000000);
			_winnerBlackFrame.visible = false;

			_winnerWhiteFrame = new FlxSprite(0,0);
			_winnerWhiteFrame.makeGraphic(FlxG.width/2 - 30,FlxG.height/2 - 10,0xFFFFFFFF);
			_winnerWhiteFrame.visible = false;

			_winnerBG = new FlxSprite(0,0);
			_winnerBG.makeGraphic(FlxG.width/2 - 40,FlxG.height/2 - 20,0xFF000000);
			_winnerBG.visible = false;


			// We will want to use a timer
			_timer = new FlxTimer();

			add(_leftScoreText);
			_leftScoreText.visible = false;
			add(_rightScoreText);
			_rightScoreText.visible = false;
			add(_leftPaddle);
			_leftPaddle.visible = false;
			add(_rightPaddle);
			_rightPaddle.visible = false;
			add(_divider);
			_divider.visible = false;
			add(_walls);
			_walls.visible = false;
			add(_ball);
			_ball.visible = false;

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
		}


		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;

			// If the ball has gone off the left side of the screen
			// Increase the right hand score, update the text, set point to true
			if (ball.x + ball.width < SCREEN_LEFT + OFFSET)
			{
				_rightScore++;
				_lastPoint = PLAYER_2;
				point = true;
			}
				// If the ball has gone off the right side of the screen
				// Increase the left hand score, update the text, set point to true
			else if (ball.x > SCREEN_LEFT + OFFSET + SCREEN_WIDTH)
			{
				_leftScore++;
				_lastPoint = PLAYER_1;
				point = true;
			}
			setScores(_leftScore,_rightScore);

			 if (point)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				resetPlay();
			}
		}


		protected override function gameOver():void
		{
			super.gameOver();

			// SHOULD DO SOMETHING IN HERE TO MAKE WINNING LOOK RIGHT
		}


		protected override function resetBall(ball:FlxSprite):void
		{
			ball.x = SCREEN_LEFT + OFFSET + SCREEN_WIDTH/2 - ball.width;
			ball.y = SCREEN_TOP + SCREEN_HEIGHT/2;

			// Zero its velocity
			ball.velocity.x = 0;
			ball.velocity.y = 0;
		}


		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();

			_walls.visible = false;
			_leftDial.visible = true;
			_rightDial.visible = true;
			_cabinet.visible = true;
			_screenBG.visible = true;
		}

		protected override function handlePaddleInput():void
		{
			// Zero the velocities to start
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;

			// RIGHT PADDLE
			if (FlxG.keys.RIGHT)
				_rightDial.angle += 10;
			else if (FlxG.keys.LEFT)
				_rightDial.angle -= 10;
			if (FlxG.keys.RIGHT && _rightPaddle.y > 0)
			{
				_rightPaddle.velocity.y = -75;
			}
			else if (FlxG.keys.LEFT && _rightPaddle.y + _rightPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y = 75;
			}
			if (_rightPaddle.y < SCREEN_TOP)
			{
				_rightPaddle.y = SCREEN_TOP;
			}
			if (_rightPaddle.y + _rightPaddle.height > SCREEN_TOP + SCREEN_HEIGHT)
			{
				_rightPaddle.y = SCREEN_TOP + SCREEN_HEIGHT - _rightPaddle.height;
			}

			// LEFT PADDLE
			if (FlxG.keys.A)
				_leftDial.angle -= 10;
			else if (FlxG.keys.D)
				_leftDial.angle += 10;
			if (FlxG.keys.A && _leftPaddle.y > 0)
			{
				_leftPaddle.velocity.y = -75;
			}
			else if (FlxG.keys.D && _leftPaddle.y + _leftPaddle.height < FlxG.height)
			{
				_leftPaddle.velocity.y = 75;
			}
			if (_leftPaddle.y < SCREEN_TOP)
			{
				_leftPaddle.y = SCREEN_TOP;
			}
			if (_leftPaddle.y + _leftPaddle.height > SCREEN_TOP + SCREEN_HEIGHT)
			{
				_leftPaddle.y = SCREEN_TOP + SCREEN_HEIGHT - _leftPaddle.height;
			}
		}


		public override function destroy():void
		{
			super.destroy();

			_cabinet.destroy();
			_leftDial.destroy();
			_rightDial.destroy();
			_screenBG.destroy();
		}
	}
}
