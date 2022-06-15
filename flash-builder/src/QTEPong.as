package
{
	import org.flixel.*;

	public class QTEPong extends StandardPong
	{
		public static const menuName:String = "QTE PONG";

		private const QTE:uint = 4;

		private var _qteKeyIndex:int = -1;

		private var _keys:Array = new Array(
			"A", "B", "C", "D", "E", "F",
			"G", "H", "I", "J", "K", "L",
			"M", "N", "O", "P", "Q", "R",
			"T", "U", "V", "X", "Y", "Z");

		private var _letters:Array = new Array(
			"(A)", "(B)", "(C)", "(D)", "(E)", "(F)", "(G)", "(H)", "(I)",
			"(J)", "(K)", "(L)", "(M)", "(N)", "(O)", "(P)", "(Q)", "(R)",
			"(T)", "(U)", "(V)", "(X)", "(Y)", "(Z)");

		private const NOT_TRIGGERED:uint = 0;
		private const TRIGGERED:uint = 1;
		private const SUCCESS:uint = 2;
		private const FAILURE:uint = 3;

		private var _qteState:uint = NOT_TRIGGERED;

		private var _qteText:FlxText;

		private var _qteTimer:FlxTimer;

		public function QTEPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_qteText = new FlxText(0,FlxG.height/2 - 24,FlxG.width/2,"",true);
			_qteText.setFormat("Commodore",48,0xFFFFFF,"center");
			add(_qteText);
			_qteText.visible = false;

			_qteTimer = new FlxTimer();
		}


		public override function update():void
		{
			super.update();
		}


		protected override function checkBall(ball:FlxSprite):void
		{
			if ((ball.x < 40 || ball.x + ball.width > FlxG.width - 40) && _qteState == NOT_TRIGGERED)
			{
				triggerQTE();
			}

			super.checkBall(ball);
		}


		private function triggerQTE():void
		{
			_state = QTE;
			_qteState = TRIGGERED;

			deactivate();

			if (_ball.x < FlxG.width/2)
			{
				_qteText.x = 0;
			}
			else if (_ball.x > FlxG.width/2)
			{
				_qteText.x = FlxG.width/2;
			}

			_qteKeyIndex = Math.floor(Math.random() * _keys.length);
			_qteText.text = _letters[_qteKeyIndex];
			_qteText.visible = true;

			_qteTimer.start(1,1,qteFailed);
		}


		private function qteFailed(t:FlxTimer):void
		{
			_qteText.visible = false;

			if (_ball.x < FlxG.width/2)
			{
				if (_ball.y > FlxG.height/2)
					_leftPaddle.y = 0;
				else
					_leftPaddle.y = FlxG.height - _leftPaddle.height;
			}
			else if (_ball.x > FlxG.width/2)
			{
				if (_ball.y > FlxG.height/2)
					_rightPaddle.y = 0;
				else
					_rightPaddle.y = FlxG.height - _rightPaddle.height;
			}

			_state = PLAYING;
			activate();
		}


		private function qteSucceeded():void
		{
			_qteText.visible = false;

			if (_ball.x < FlxG.width/2)
			{
				_leftPaddle.y = _ball.y + _ball.height/2 - _leftPaddle.height/2;
			}
			else if (_ball.x > FlxG.width/2)
			{
				_rightPaddle.y = _ball.y + _ball.height/2 - _rightPaddle.height/2;
			}

			_state = PLAYING;
			activate();

			_qteTimer.start(1,1,resetTrigger);
		}


		private function resetTrigger(t:FlxTimer):void
		{
			_qteState = NOT_TRIGGERED;
		}


		protected override function resetPlay():void
		{
			super.resetPlay();

			this._qteState = NOT_TRIGGERED;
		}




		protected override function handleInput():void
		{
			super.handleInput();

			handleQTEInput();
		}


		private function handleQTEInput():void
		{
			if (_state == QTE)
			{
				if (FlxG.keys.pressed(_keys[_qteKeyIndex]))
				{
					// Success!
					_qteTimer.stop();
					qteSucceeded();
				}
				else if (_keys.any())
				{
					// Failure by wrong key
					_qteTimer.stop();
					qteFailed(null);
				}
				return;
			}
		}



		public override function destroy():void
		{
			super.destroy();

			this._qteText.destroy();
			this._qteTimer.destroy();
		}
	}
}
