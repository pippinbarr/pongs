package
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	
	public class TrackAndPong extends StandardPong
	{
		public static const menuName:String = "TRACK & PONG";
		
		private const MAX_KEY_DELAY:Number = 0.12;
		
		private var _leftActive:Boolean = false;
		private var _leftLastKey:uint = Keyboard.D;
		private var _leftTimeSincePress:Number = 1000;
		
		private var _rightActive:Boolean = false;
		private var _rightLastKey:uint = Keyboard.RIGHT;
		private var _rightTimeSincePress:Number = 1000;
		
		
		public function TrackAndPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: RAPIDLY ALTERNATE [A] AND [D] TO MOVE\n\n" +
				"PLAYER 2: RAPIDLY ALTERNATE [LEFT] AND [RIGHT] TO MOVE\n\n" +
				"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";	
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (PLAYING)
			{
				updateLeftAI();
				updateRightAI();
				
				_leftTimeSincePress += FlxG.elapsed;
				_rightTimeSincePress += FlxG.elapsed;
				
				if (_leftTimeSincePress > MAX_KEY_DELAY)
				{
					_leftActive = false;
				}
				if (_rightTimeSincePress > MAX_KEY_DELAY)
				{
					_leftActive = false;
				}
			}

		}
		
		
		private function updateLeftAI():void
		{
			_leftPaddle.velocity.y = 0;
			
			if (!_leftActive)
				return;
			
			var leftPaddleCenter:Number = _leftPaddle.y + _leftPaddle.height/2;
			
			var leftPaddleVelocity:Number = Globals.PADDLE_SPEED - (_leftTimeSincePress * 1);
			if (leftPaddleVelocity <= 0)
				return;
			
			trace("VELOCITY SET TO: " + leftPaddleVelocity);
			
			if (_ball.velocity.x < 0)
			{
				// BALL COMING SO INTERCEPT
				if (leftPaddleCenter < _ball.y - 10)
				{
					_leftPaddle.velocity.y = leftPaddleVelocity; // _leftPaddle.maxVelocity.y - int(Math.random() * 300);
				}
				else if (leftPaddleCenter > _ball.y + 10)
				{
					_leftPaddle.velocity.y = -leftPaddleVelocity; //-_leftPaddle.maxVelocity.y + int(Math.random() * 300);
				}
			}
			else
			{
				// BALL NOT COMING, SO RETURN TO MIDDLE
				if (leftPaddleCenter > FlxG.height/2 + 10)
				{
					_leftPaddle.velocity.y = -leftPaddleVelocity; //_leftPaddle.maxVelocity.y + int(Math.random() * 200);
				}
				else if (leftPaddleCenter < FlxG.height/2  - 10)
				{
					_leftPaddle.velocity.y = leftPaddleVelocity; //_leftPaddle.maxVelocity.y - int(Math.random() * 200);
				}
			}
		}
		
		
		private function updateRightAI():void
		{
			_rightPaddle.velocity.y = 0;
			
			if (!_rightActive)
				return;
			
			var rightPaddleCenter:Number = _rightPaddle.y + _rightPaddle.height/2;
			
			var rightPaddleVelocity:Number = Globals.PADDLE_SPEED - (_rightTimeSincePress * 1);
			if (rightPaddleVelocity <= 0)
				return;
			
			trace("VELOCITY SET TO: " + rightPaddleVelocity);
			
			if (_ball.velocity.x > 0)
			{
				// BALL COMING SO INTERCEPT
				if (rightPaddleCenter < _ball.y - 10)
				{
					_rightPaddle.velocity.y = rightPaddleVelocity; // _rightPaddle.maxVelocity.y - int(Math.random() * 300);
				}
				else if (rightPaddleCenter > _ball.y + 10)
				{
					_rightPaddle.velocity.y = -rightPaddleVelocity; //-_rightPaddle.maxVelocity.y + int(Math.random() * 300);
				}
			}
			else
			{
				// BALL NOT COMING, SO RETURN TO MIDDLE
				if (rightPaddleCenter > FlxG.height/2 + 10)
				{
					_rightPaddle.velocity.y = -rightPaddleVelocity; //_rightPaddle.maxVelocity.y + int(Math.random() * 200);
				}
				else if (rightPaddleCenter < FlxG.height/2  - 10)
				{
					_rightPaddle.velocity.y = rightPaddleVelocity; //_rightPaddle.maxVelocity.y - int(Math.random() * 200);
				}
			}
		}
		
		
		protected override function handlePaddleInput():void
		{
			// Nothing.
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.A && _leftLastKey == Keyboard.D) {
				_leftActive = (_leftTimeSincePress < MAX_KEY_DELAY);
				_leftTimeSincePress = 0;
				_leftLastKey = e.keyCode;
			}
			else if (e.keyCode == Keyboard.D && _leftLastKey == Keyboard.A) {
				_leftActive = (_leftTimeSincePress < MAX_KEY_DELAY);
				_leftTimeSincePress = 0;
				_leftLastKey = e.keyCode;
			}
			
			if (e.keyCode == Keyboard.LEFT && _rightLastKey == Keyboard.RIGHT) {
				_rightActive = (_rightTimeSincePress < MAX_KEY_DELAY);
				_rightTimeSincePress = 0;
				_rightLastKey = e.keyCode;
			}
			else if (e.keyCode == Keyboard.RIGHT && _rightLastKey == Keyboard.LEFT) {
				_rightActive = (_rightTimeSincePress < MAX_KEY_DELAY);
				_rightTimeSincePress = 0;
				_rightLastKey = e.keyCode;
			}
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}