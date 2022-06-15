package
{
	import org.flixel.*;
	
	public class TurnBasedPong extends StandardPong
	{	
		public static const menuName:String = "TURN-BASED PONG";

		private const SELECTION:uint = 4;
		
		private const TURN_TIME:Number = 0.1;
		
		private var _leftTurnText:FlxText;
		private var _rightTurnText:FlxText;
		private var _leftMoveWaitString:String = "" +
			"SELECT YOUR MOVE\n\n" +
			"[W] = UP\n" +
			"[S] = DOWN\n" +
			"[D] = SKIP TURN";
		private var _rightMoveWaitString:String = "" +
			"SELECT YOUR MOVE\n\n" +
			"[UP] = UP\n" +
			"[DOWN] = DOWN\n" +
			"[LEFT] = SKIP TURN";
		private var _moveMadeString:String = "" +
			"MOVE SELECTED";
		
		private var _turnTimer:FlxTimer;		
		
		private var _leftSelection:Number = -1;
		private var _rightSelection:Number = -1;
		
		public function TurnBasedPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_leftTurnText = new FlxText(0,256,FlxG.width/2,_leftMoveWaitString,true);
			_leftTurnText.setFormat("Commodore",18,0xFFFFFF,"center");
			add(_leftTurnText);
			_leftTurnText.visible = false;
			
			_rightTurnText = new FlxText(FlxG.width/2,256,FlxG.width/2,_rightMoveWaitString,true);
			_rightTurnText.setFormat("Commodore",18,0xFFFFFF,"center");
			add(_rightTurnText);
			_rightTurnText.visible = false;
			
			_turnTimer = new FlxTimer();
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);

			var ballDirection:Number = Math.atan2(_ball.velocity.y, _ball.velocity.x);

			var paddleInfluence:Number = ((paddle.velocity.y * 5) * Globals.PADDLE_BALL_INFLUENCE_FACTOR);
			
			ball.velocity.y = Math.sin(ballDirection) * Globals.BALL_SPEED*1.5 + paddleInfluence;		
		}
		
		private function degrees(angle:Number):Number
		{
			return (angle / (2 * Math.PI)) * 360;
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
			
			_turnTimer.stop();
			
			_leftTurnText.visible = false;
			_rightTurnText.visible = false;
		}
		
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_turnTimer.stop();
			
			_leftTurnText.text = _leftMoveWaitString;
			_rightTurnText.text = _rightMoveWaitString;
			
			_leftTurnText.visible = false;
			_rightTurnText.visible = false;			
		}
		
		
		protected override function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			var ballDirection:Number;
			
			if (_lastPoint == PLAYER_2)
			{
				ballDirection = (Math.random() * Math.PI/4) - Math.PI/8;
			}
			else if (_lastPoint == PLAYER_1)
			{
				ballDirection = (Math.random() * Math.PI/4) + Math.PI - Math.PI/8;
			}
			_ball.velocity.x = Math.cos(ballDirection) * Globals.BALL_SPEED*1.5;//*15;
			_ball.velocity.y = Math.sin(ballDirection) * Globals.BALL_SPEED*1.5;//*15;
						
			this._turnTimer.start(TURN_TIME,1,selectMode);
		}
		
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_leftTurnText.visible = false;
			_rightTurnText.visible = false;
			_leftTurnText.text = _leftMoveWaitString;
			_rightTurnText.text = _rightMoveWaitString;
		}
		
		
		protected override function handlePaddleInput():void
		{			
			if (_state == SELECTION)
			{
				if (_leftSelection == -1)
				{
					if (FlxG.keys.W)
					{
						_leftSelection = 1;
						_leftPaddle.velocity.y = -Globals.PADDLE_SPEED;
					}
					else if (FlxG.keys.S)
					{
						_leftSelection = 1;
						_leftPaddle.velocity.y = Globals.PADDLE_SPEED;
					}
					else if (FlxG.keys.D)
					{
						_leftSelection = 1;
						_leftPaddle.velocity.y = 0;
					}
				}
				if (_rightSelection == -1)
				{
					if (_rightSelection == -1)
					{
						if (FlxG.keys.UP)
						{
							_rightSelection = 1;
							_rightPaddle.velocity.y = -Globals.PADDLE_SPEED;
						}
						else if (FlxG.keys.DOWN)
						{
							_rightSelection = 1;
							_rightPaddle.velocity.y = Globals.PADDLE_SPEED;
						}
						else if (FlxG.keys.LEFT)
						{
							_rightSelection = 1;
							_rightPaddle.velocity.y = 0;
						}
					}
				}
				if (_rightSelection == 1)
					_rightTurnText.text = _moveMadeString;
				if (_leftSelection == 1)
					_leftTurnText.text = _moveMadeString;
				
				if (_rightSelection == 1 && _leftSelection == 1)
				{
					_leftSelection = 0;
					_rightSelection = 0;
					
					_turnTimer.stop();
					_turnTimer.start(1,1,playMode);
				}
			}
			
			checkBoundaries();
		}
		
		
		private function playMode(t:FlxTimer):void
		{
			_state = PLAYING;
			
			activate();
			
			_leftTurnText.visible = false;
			_rightTurnText.visible = false;

			_turnTimer.stop();
			_turnTimer.start(TURN_TIME,1,selectMode);
		}
		
		
		private function selectMode(t:FlxTimer):void
		{
			_state = SELECTION;
			
			deactivate();
			
			_leftSelection = -1;
			_rightSelection = -1;
			
			_leftTurnText.visible = true;
			_rightTurnText.visible = true;
			
			_leftTurnText.text = this._leftMoveWaitString;
			_rightTurnText.text = this._rightMoveWaitString;
		}
		
		
		private function checkBoundaries():void
		{
			if (_rightPaddle.y < 0)
			{
				_rightPaddle.y = 0;
			}
			if (_rightPaddle.y + _rightPaddle.height > FlxG.height)
			{
				_rightPaddle.y = FlxG.height - _rightPaddle.height;
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
			
			this._leftTurnText.destroy();
			this._rightTurnText.destroy();
			this._turnTimer.destroy();
		}
	}
}