package
{
	import org.flixel.*;
	
	public class SnakePong extends StandardPong
	{	
		public static const menuName:String = "SNAKE PONG";
		
		private var _tailBalls:FlxGroup;
		private var _lastBallX:Number;
		private var _lastBallY:Number;
		
		private var _timeElapsed:Number = 0;
		
		private var _apple:FlxSprite;
		private var _appleTimer:FlxTimer = new FlxTimer();
		
		
		public function SnakePong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_tailBalls = new FlxGroup();
			add(_tailBalls);
			
			_apple = new FlxSprite(-200,-200);
			_apple.makeGraphic(10,10,0xFFFF0000);
			add(_apple);
			
			OVERRIDE_UPDATE = true;
		}
		
		
		public override function update():void
		{
			super.update();
			
			handleInput();
			
			if (_state == PLAYING)
			{
				FlxG.overlap(_ball, _apple, appleHit);
				
				checkBall(_ball);
				
				doCollisions();
				
				updateTail();
				
				_lastBallX = _ball.x;
				_lastBallY = _ball.y;	
				
				checkGameOver();
			}
		}
		
		
		private function updateTail():void
		{
			for (var i:int = _tailBalls.length-1; i >= 1; i--)
			{
				if (_tailBalls.members[i].alive)
				{
					_tailBalls.members[i].x = _tailBalls.members[i-1].x;
					_tailBalls.members[i].y = _tailBalls.members[i-1].y;
				}
			}
			if (_tailBalls.length > 0)
			{
				_tailBalls.members[0].x = _lastBallX;
				_tailBalls.members[0].y = _lastBallY;
			}
		}
		
		
		private function appleHit(ball:FlxObject, apple:FlxObject):void
		{
			_apple.x = -200;
			_apple.y = -200;
			
			if (_lastHit == PLAYER_1)
			{
				_leftScore += 5;
				_leftScoreText.text = _leftScore.toString();
			}
			else if (_lastHit == PLAYER_2)
			{
				_rightScore += 5;
				_rightScoreText.text = _rightScore.toString();
			}
			
			_appleTimer.start(Math.random() * 3 + 2,1,placeApple);
		}
		
		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle,ball);
						
			// Add to the tail
			for (var i:uint = 0; i < 5; i++)
			{
				if (_tailBalls.length >= 0)
				{
					var newBall:FlxSprite = _tailBalls.recycle(FlxSprite) as FlxSprite;
					newBall.makeGraphic(Globals.BALL_SIZE, Globals.BALL_SIZE, 0xFFFFFFFF);
					newBall.elasticity = 1;
					newBall.revive();
					newBall.active = true;
					
					if (ball.velocity.x < 0)
						newBall.x = ball.x + newBall.width*4;
					else if (_ball.velocity.x > 0)
						newBall.x = ball.x - newBall.width*3;
					else
						trace("ERROR: BALL X VELOCITY == 0");
					if (ball.velocity.y < 0)
						newBall.y = ball.y + newBall.width*4;
					else if (_ball.velocity.y > 0)
						newBall.y = ball.y - newBall.width*3;
					else
						trace("ERROR: BALL Y VELOCITY == 0");
				}
			}			
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
			
			_appleTimer.stop();
			
			remove(_ball);
			remove(_tailBalls);
			
			remove(_winnerBlackFrame);
			remove(_winnerWhiteFrame);
			remove(_winnerBG);
			remove(_winnerText);
			remove(_resultText);
			
			add(_ball);
			add(_tailBalls);
			
			add(_winnerBlackFrame);
			add(_winnerWhiteFrame);
			add(_winnerBG);
			add(_winnerText);
			add(_resultText);

		}
		
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_appleTimer.stop();
						
			_tailBalls.callAll("kill");			
		}
		
		
		protected override function launchBall(t:FlxTimer):void
		{
			super.launchBall(t);			

			_appleTimer.start(Math.random() * 3 + 2,1,placeApple);
		}
		
		
		private function placeApple(t:FlxTimer):void
		{
			_apple.x = 20 + (Math.random() * (FlxG.width - 50));
			_apple.y = Math.random() * (FlxG.height - 10);
			
			_appleTimer.start(Math.random() * 5 + 5,1,placeApple);
		}
		
		
		
		
		
		public override function destroy():void
		{
			super.destroy();
		
			this._tailBalls.destroy();
			this._apple.destroy();
			this._appleTimer.destroy();
		}
	}
}