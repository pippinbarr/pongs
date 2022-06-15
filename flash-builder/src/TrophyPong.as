package
{
	import org.flixel.*;


	public class TrophyPong extends StandardPong
	{
		public static const menuName:String = "TROPHY PONG";


		private const P1_ACHIEVEMENT_LEFT:uint = 25;
		private const P2_ACHIEVEMENT_LEFT:uint = FlxG.width/2 + 15;

		private const ACHIEVEMENT_TOP:uint = 90;
		private const ACHIEVEMENT_SPACING:uint = 5;
		private const ACHIEVEMENT_WIDTH:uint = (FlxG.width/2 - 20 - 15) / 2 - ACHIEVEMENT_SPACING;
		private const ACHIEVEMENT_HEIGHT:uint = (FlxG.height - ACHIEVEMENT_TOP) / 5 - ACHIEVEMENT_SPACING;

		private const TITLE_SIZE:uint = 11;
		private const DESCRIPTION_SIZE:uint = 10;
		private const DESCRIPTION_OFFSET:uint = 20;

		private const ACHIEVEMENT_TITLES:Array = new Array(
			"MADE 'EM MISS!",
			"HIGHS AND LOWS!",
			"SPIN DOCTOR!",
			"BIG LEAD!",
			"WELL TRAVELLED!",
			"STRAIGHT MAN!",
			"3-FOR-3!",
			"NO HANDS!",
			"FLYING BLIND!",
			"TOP ACHIEVER!"
		);

		private const ACHIEVEMENT_DESCRIPTIONS:Array = new Array(
			"GOT THE BALL PAST YOUR OPPONENT WITHOUT THEM TOUCHING IT",
			"BOUNCED THE BALL OF THE TOP AND BOTTOM WALLS IN ONE SHOT",
			"APPLIED \"SPIN\" TO THE BALL THREE TIMES IN ONE POINT",
			"GOT AHEAD BY FIVE POINTS",
			"TOUCHED THE TOP AND BOTTOM OF THE SCREEN WITH YOUR PADDLE",
			"MADE A SHOT THAT DIDN'T TOUCH ANY WALLS",
			"WON THREE POINTS IN A ROW",
			"RETURNED THE BALL WITHOUT MOVING THE PADDLE",
			"WON A POINT WITH 6 OR MORE TROPHIES ON SCREEN",
			"GOT ALL THE ACHIEVEMENTS, EVEN THIS ONE"
		);

		private const MADE_EM_MISS:uint = 0;
		private const HIGHS_AND_LOWS:uint = 1;
		private const SPIN_DOCTOR:uint = 2;
		private const BIG_LEAD:uint = 3;
		private const WELL_TRAVELLED:uint = 4;
		private const STRAIGHT_MAN:uint = 5;
		private const THREE_FOR_THREE:uint = 6;
		private const NO_HANDS:uint = 7;
		private const FLYING_BLIND:uint = 8;
		private const TOP_ACHIEVER:uint = 9;

		private var _leftAchievementsObtained:Array = new Array(
			false, false, false, false, false,
			false, false, false, false, false);
		private var _rightAchievementsObtained:Array = new Array(
			false, false, false, false, false,
			false, false, false, false, false);

		private var _leftAchievements:FlxGroup;
		private var _rightAchievements:FlxGroup;


		// TRACKING ACHIEVEMENTS
		private const TOP_WALL:uint = 0;
		private const BOTTOM_WALL:uint = 1;
		private var _wallsHit:Array = new Array(false,false);
		private var _leftPaddleWallsTouched:Array = new Array(false,false);
		private var _rightPaddleWallsTouched:Array = new Array(false,false);

		private var _leftSpinCount:uint = 0;
		private var _rightSpinCount:uint = 0;

		private var _straightMan:Boolean = true;

		private var _leftConsecutivePoints:uint = 0;
		private var _rightConsecutivePoints:uint = 0;

		private var _leftPaddleMoved:Boolean = true;
		private var _rightPaddleMoved:Boolean = true;

		private var _leftPlayerAchievementCount:uint = 0;
		private var _rightPlayerAchievementCount:uint = 0;

		public function TrophyPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_leftAchievements = new FlxGroup();
			_rightAchievements = new FlxGroup();

			remove(_winnerBlackFrame);
			remove(_winnerWhiteFrame);
			remove(_winnerBG);
			remove(_winnerText);
			remove(_resultText);


			add(_leftAchievements);
			add(_rightAchievements);

			add(_winnerBlackFrame);
			add(_winnerWhiteFrame);
			add(_winnerBG);
			add(_winnerText);
			add(_resultText);

		}


		public override function update():void
		{
			super.update();

			checkWellTravelled();

			if (_leftPaddle.velocity.y != 0)
				_leftPaddleMoved = true;
			if (_rightPaddle.velocity.y != 0)
				_rightPaddleMoved = true;
		}


		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			checkStraightMan();

			super.paddleHit(paddle,ball);

			_wallsHit[TOP_WALL] = false;
			_wallsHit[BOTTOM_WALL] = false;

			checkSpinDoctor(paddle);
			checkNoHands();

			_straightMan = true;

			_leftPaddleMoved = false;
			_rightPaddleMoved = false;
		}


		protected override function wallHit(ball:FlxObject, wall:FlxObject):void
		{
			super.wallHit(ball,wall);

			if (wall.y > FlxG.height/2)
			{
				_wallsHit[BOTTOM_WALL] = true;
			}
			else
			{
				_wallsHit[TOP_WALL] = true;
			}

			if (_wallsHit[TOP_WALL] && _wallsHit[BOTTOM_WALL])
			{
				if (_lastHit == PLAYER_1)
				{
					addAchievement(HIGHS_AND_LOWS,PLAYER_1);
				}
				else if (_lastHit == PLAYER_2)
				{
					addAchievement(HIGHS_AND_LOWS,PLAYER_2);
				}
			}

			_straightMan = false;
		}


		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;

			if (ball.x + ball.width < 0)
			{
				_rightScore++;
				_lastPoint = PLAYER_2;
				point = true;

				checkStraightMan();
				checkThreeForThree();
				checkFlyingBlind();
			}
			else if (ball.x > FlxG.width)
			{
				_leftScore++;
				_lastPoint = PLAYER_1;
				point = true;

				checkStraightMan();
				checkThreeForThree();
				checkFlyingBlind();
			}

			setScores(_leftScore,_rightScore);

			if (point && _lastPoint == PLAYER_2 && _lastHit == PLAYER_2)
				addAchievement(MADE_EM_MISS,PLAYER_2);
			else if (point && _lastPoint == PLAYER_1 && _lastHit == PLAYER_1)
				addAchievement(MADE_EM_MISS,PLAYER_1);

			if (_leftScore - _rightScore >= 5)
			{
				addAchievement(BIG_LEAD,PLAYER_1);
			}
			else if (_rightScore - _leftScore >= 5)
			{
				addAchievement(BIG_LEAD,PLAYER_2);
			}

			if (point && !gameIsOver())
			{
				postPoint();
			}
		}



		protected override function resetPlay():void
		{
			super.resetPlay();

			_leftSpinCount = 0;
			_rightSpinCount = 0;

			_leftPaddleMoved = true;
			_rightPaddleMoved = true;

			_straightMan = true;
		}


		protected override function gameOver():void
		{
			super.gameOver();

			_rightPaddleWallsTouched[TOP_WALL] = false;
			_rightPaddleWallsTouched[BOTTOM_WALL] = false;
			_leftPaddleWallsTouched[TOP_WALL] = false;
			_leftPaddleWallsTouched[BOTTOM_WALL] = false;

			_leftPlayerAchievementCount = 0;
			_rightPlayerAchievementCount = 0;
		}


		private function addAchievement(achievement:uint, player:uint):void
		{
			trace("addAchievement: " + achievement + " , " + player);

			if (player == PLAYER_1)
			{
				if (_leftAchievementsObtained[achievement])
					return;
			}
			else if (player == PLAYER_2)
			{
				if (_rightAchievementsObtained[achievement])
					return;
			}

			var bg:FlxSprite = new FlxSprite();
			bg.makeGraphic(ACHIEVEMENT_WIDTH, ACHIEVEMENT_HEIGHT, 0xFFFFFFFF);

			var title:FlxText = new FlxText(0,0,ACHIEVEMENT_WIDTH,"",true);
			title.setFormat("Commodore", TITLE_SIZE, 0xFF000000, "center");
			title.text = ACHIEVEMENT_TITLES[achievement];

			var description:FlxText = new FlxText(0,0,ACHIEVEMENT_WIDTH,"",true);
			description.setFormat("Commodore", DESCRIPTION_SIZE, 0xFF000000, "center");
			description.text = ACHIEVEMENT_DESCRIPTIONS[achievement];

			bg.y = ACHIEVEMENT_TOP + (achievement % 5) * ACHIEVEMENT_HEIGHT + (achievement % 5) * ACHIEVEMENT_SPACING;
			title.y = ACHIEVEMENT_TOP + (achievement % 5) * ACHIEVEMENT_HEIGHT  + (achievement % 5) * ACHIEVEMENT_SPACING;
			description.y = ACHIEVEMENT_TOP + (achievement % 5) * ACHIEVEMENT_HEIGHT  + (achievement % 5) * ACHIEVEMENT_SPACING + DESCRIPTION_OFFSET;

			if (player == PLAYER_1)
			{
				if (achievement < 5)
				{
					bg.x = P1_ACHIEVEMENT_LEFT;
					title.x = P1_ACHIEVEMENT_LEFT;
					description.x = P1_ACHIEVEMENT_LEFT;
				}
				else
				{
					bg.x = P1_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
					title.x = P1_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
					description.x = P1_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
				}

				_leftAchievements.add(bg);
				_leftAchievements.add(title);
				_leftAchievements.add(description);

				_leftAchievementsObtained[achievement] = true;

				_leftPlayerAchievementCount++;
			}
			else if (player == PLAYER_2)
			{
				if (achievement < 5)
				{
					bg.x = P2_ACHIEVEMENT_LEFT;
					title.x = P2_ACHIEVEMENT_LEFT;
					description.x = P2_ACHIEVEMENT_LEFT;
				}
				else
				{
					bg.x = P2_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
					title.x = P2_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
					description.x = P2_ACHIEVEMENT_LEFT + ACHIEVEMENT_WIDTH + ACHIEVEMENT_SPACING;
				}
				_rightAchievements.add(bg);
				_rightAchievements.add(title);
				_rightAchievements.add(description);

				_rightAchievementsObtained[achievement] = true;

				_rightPlayerAchievementCount++;
			}

			checkTopAchiever();
		}


		private function checkSpinDoctor(paddle:FlxObject):void
		{
			if (paddle.velocity.y != 0)
			{
				if (_lastHit == PLAYER_1)
				{
					_leftSpinCount++;
					if (_leftSpinCount == 3)
					{
						addAchievement(SPIN_DOCTOR,PLAYER_1);
					}
				}
				if (_lastHit == PLAYER_2)
				{
					_rightSpinCount++;
					if (_rightSpinCount == 3)
					{
						addAchievement(SPIN_DOCTOR,PLAYER_2);
					}
				}
			}
		}

		private function checkWellTravelled():void
		{
			if (_leftPaddle.y == 0)
			{
				_leftPaddleWallsTouched[TOP_WALL] = true;
			}
			else if (_leftPaddle.y + _leftPaddle.height == FlxG.height)
			{
				_leftPaddleWallsTouched[BOTTOM_WALL] = true;
			}
			if (_rightPaddle.y == 0)
			{
				_rightPaddleWallsTouched[TOP_WALL] = true;
			}
			else if (_rightPaddle.y + _rightPaddle.height == FlxG.height)
			{
				_rightPaddleWallsTouched[BOTTOM_WALL] = true;
			}

			if (_leftPaddleWallsTouched[TOP_WALL] && _leftPaddleWallsTouched[BOTTOM_WALL])
			{
				addAchievement(WELL_TRAVELLED,PLAYER_1);
			}
			if (_rightPaddleWallsTouched[TOP_WALL] && _rightPaddleWallsTouched[BOTTOM_WALL])
			{
				addAchievement(WELL_TRAVELLED,PLAYER_2);
			}
		}


		private function checkStraightMan():void
		{
			if (_straightMan && _lastHit == PLAYER_1)
			{
				addAchievement(STRAIGHT_MAN,PLAYER_1);
			}
			else if (_straightMan && _lastHit == PLAYER_2)
			{
				addAchievement(STRAIGHT_MAN,PLAYER_2);
			}
		}


		private function checkThreeForThree():void
		{
			if (_lastPoint == PLAYER_1)
			{
				_leftConsecutivePoints++;
				_rightConsecutivePoints = 0;
				if (_leftConsecutivePoints == 3)
					addAchievement(THREE_FOR_THREE,PLAYER_1);
			}
			else if (_lastPoint == PLAYER_2)
			{
				_rightConsecutivePoints++;
				_leftConsecutivePoints = 0;
				if (_rightConsecutivePoints == 3)
					addAchievement(THREE_FOR_THREE,PLAYER_2);
			}
		}


		private function checkNoHands():void
		{
			if (!_leftPaddleMoved && _lastHit == PLAYER_1)
			{
				addAchievement(NO_HANDS,PLAYER_1);
			}
			else if (!_rightPaddleMoved && _lastHit == PLAYER_2)
			{
				addAchievement(NO_HANDS,PLAYER_2);
			}
		}


		private function checkFlyingBlind():void
		{
			if (_lastPoint == PLAYER_1 && _leftPlayerAchievementCount >= 5)
				addAchievement(FLYING_BLIND,PLAYER_1);
			else if (_lastPoint == PLAYER_2 && _rightPlayerAchievementCount >= 5)
				addAchievement(FLYING_BLIND,PLAYER_2);
		}


		private function checkTopAchiever():void
		{
			if (_leftPlayerAchievementCount >= 9)
				addAchievement(TOP_ACHIEVER,PLAYER_1);
			if (_rightPlayerAchievementCount >= 9)
				addAchievement(TOP_ACHIEVER,PLAYER_2);
		}

		public override function destroy():void
		{
			super.destroy();
		}
	}
}
