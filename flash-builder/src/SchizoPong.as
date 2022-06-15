package
{
	import org.flixel.*;

	public class SchizoPong extends StandardPong
	{
		//public static const menuName:String = "SCHIZO PONG";
		public static const menuName:String = "IDENTITY PONG";

		private var _flipped:Boolean = (Math.random() < 0.5);
		private var _flipTimer:FlxTimer = new FlxTimer();


		public function SchizoPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_flipTimer.start(Math.random() * 5 + 1,1,flipControls);
		}


		private function flipControls(t:FlxTimer):void
		{
			_flipped = !_flipped;
			_flipTimer.start(Math.random() * 5 + 1,1,flipControls);

		}




		protected override function handlePaddleInput():void
		{
			// Zero the velocities to start
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;

			if (!_flipped)
			{
			// RIGHT PADDLE
			if (FlxG.keys.UP && _rightPaddle.y > 0)
			{
				_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.DOWN && _rightPaddle.y + _rightPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
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
				_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
			}
			else if (FlxG.keys.S && _leftPaddle.y + _leftPaddle.height < FlxG.height)
			{
				_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
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
			else if (_flipped)
			{
				// RIGHT PADDLE
				if (FlxG.keys.W && _rightPaddle.y > 0)
				{
					_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
				}
				else if (FlxG.keys.S && _rightPaddle.y + _rightPaddle.height < FlxG.height)
				{
					_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
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
				if (FlxG.keys.UP && _leftPaddle.y > 0)
				{
					_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
				}
				else if (FlxG.keys.DOWN && _leftPaddle.y + _leftPaddle.height < FlxG.height)
				{
					_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
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
		}


		public override function destroy():void
		{
			super.destroy();

			this._flipTimer.destroy();
		}
	}
}
