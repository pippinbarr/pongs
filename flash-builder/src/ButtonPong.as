package
{
	import org.flixel.*;

	public class ButtonPong extends StandardPong
	{
		public static const menuName:String = "B.U.T.T.O.N. PONG";

		private const BUTTON:uint = 4;

		private var _buttonStrings:Array = new Array(
		"HOLD YOUR BREATH FOR THE DURATION OF THIS POINT",
		"PLAY THIS POINT WITH YOUR EYES CLOSED",
		"INTERFERE WITH YOUR OPPONENT TO WIN THIS POINT",
		"LOSE THIS POINT ON PURPOSE",
		"PLAY THIS POINT WITH YOUR NON-DOMINANT HAND",
		"PLAY THIS POINT FACING AWAY AND LOOKING BACK OVER YOUR SHOULDER",
		"BLINK RAPIDLY THROUGHOUT THIS POINT",
		"LOUDLY COUNT BACKWARDS FROM 100 DURING THIS POINT",
		"PLAY THIS POINT WITH YOUR NOSE TOUCHING THE SCREEN",
		"PLAY THIS POINT USING YOUR NOSE",
		"CHANT \"LOSE! LOSE! LOSE!\" WHILE PLAYING THIS POINT",
		"HAVE A CONVERSATION ABOUT YOUR WORST JOB DURING THIS POINT",
		"PLAY THIS POINT STANDING UP",
		"PLAY THIS POINT SITTING ON THE GROUND",
		"PLAY THIS POINT USING YOUR FEET",
		"PLAY THIS POINT TRYING TO COVER YOUR OPPONENT'S EYES",
		"PLAY THIS POINT CONTROLLING THE OTHER PADDLE",
		"PLAY THIS POINT WHILE DOING AN IMPRESSION OF MICHAEL CAINE",
		"PLAY THIS POINT WHILE DOING AN IMPRESSION OF AL PACINO",
		"PLAY THIS POINT LIKE BILLY MITCHELL WOULD PLAY THIS POINT",
		"PLAY THIS POINT LIKE CHUCK NORRIS",
		"PLAY THIS POINT LIKE JESUS",
		"LOUDLY SING THE \"I LIKE TO MOVE IT MOVE IT\" SONG DURING THIS POINT",
		"PLAY THIS POINT LIKE KEYBOARD CAT",
		"PLAY THIS POINT IN SLOW MOTION",
		"DON'T PLAY THIS POINT",
		"DECLARE YOURSELF THE WINNER AFTER THIS POINT",
		"TAKE FIVE STEPS BACK FROM THE COMPUTER AND THEN PLAY THIS POINT",
		"PLAY THIS POINT SCREAMING LIKE ONE OF THOSE LOUD TENNIS PLAYERS",
		"FAKE A HEART ATTACK OR STROKE DURING THIS POINT",
		"SPELL 'ANTIDISESTABLISHMENTARIANISM' OUT LOUD DURING THIS POINT",
		"WIN THIS POINT",
		"TAKE THIS POINT FAR TOO SERIOUSLY",
		"KEEP ASKING YOUR OPPONENT WHAT THE TIME IS DURING THIS POINT",
		"IMAGINE YOU ARE ON A WHITE, SANDY BEACH DURING THIS POINT",
		"SLAP YOURSELF IN THE FACE EVERY TIME THE BALL BOUNCES DURING THIS POINT",
		"COMPOSE A HAIKU ABOUT THIS POINT DURING THIS POINT",
		"ACCEPT THAT FREE WILL IS AN ILLUSION DURING THIS POINT",
		"THINK ABOUT ALL THE OTHER STUFF YOU SHOULD REALLY BEING DOING DURING THIS POINT",
		"ARGUE ABOUT POLITICS DURING THIS POINT",
		"PLAY THIS POINT LIKE NO ONE'S WATCHING",
		"COMPLIMENT YOUR OPPONENT'S APPEARANCE DURING THIS POINT",
		"DISTRACT YOUR OPPONENT DURING THIS POINT",
		"TELL A JOKE DURING THIS POINT",
		"PLAY THIS POINT LOOKING AWAY AND USING YOUR PERIPHERAL VISION",
		"PLAY THIS POINT AS IF YOUR LIFE DEPENDED ON IT",
		"PLAY THIS POINT WHILE DISCUSSING THE TROLLEY PROBLEM",
		"PLAY THIS POINT WHILE MOVING YOUR HEAD LIKE THE CROWD AT A TENNIS MATCH",
		"SHOUT \"BOOM-SHAKALAKA!\" EACH TIME YOU HIT THE BALL IN THIS POINT");

		private var _buttonTimer:FlxTimer = new FlxTimer();


		public function ButtonPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;
			_instructionsText.text += "\n\n(AND, OF COURSE, BRUTALLY UNFAIR TACTICS ARE TOTALLY OKAY NOW.)";
		}


		public override function update():void
		{
			super.update();
		}


		protected override function postPoint():void
		{
			FlxG.play(Assets.POINT_SOUND,0.5);

			_state = BUTTON;
			_timer.start(1,1,displayButtonRule);
		}


		private function displayButtonRule(t:FlxTimer):void
		{
			_ball.x = FlxG.width/2 - _ball.width/2;
			_ball.y = FlxG.height/2 - _ball.height/2;

			_instructionsText.visible = true;
			_winnerText.visible = false;
			_resultText.visible = false;

			_leftScoreText.visible = false;
			_rightScoreText.visible = false;
			_leftPaddle.visible = false;
			_rightPaddle.visible = false;
			_divider.visible = false;
			_walls.visible = false;
			_ball.visible = false;

			_instructionsText.text = _buttonStrings[Math.floor(Math.random() * _buttonStrings.length)];
			_buttonTimer.start(3,1,startPlay);
		}


		private function startPlay(t:FlxTimer):void
		{
			swapTitleAndPlayVisibles();
			resetPlay();
		}


		protected override function handleSpacePressed():void
		{
			if (_state == INSTRUCTIONS || _state == GAMEOVER)
			{
				if (FlxG.keys.SPACE)
				{
					setScores(0,0);

					_state = BUTTON;
					_titleText.visible = false;

					displayButtonRule(null);
				}
				return;
			}
		}




		public override function destroy():void
		{
			super.destroy();

			this._buttonTimer.destroy();
		}
	}
}
