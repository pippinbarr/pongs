package
{
	import org.flixel.*;
	
	public class PongForTwo extends StandardPong
	{
		public static const menuName:String = "PONG FOR TWO";
		
		private var _lastBounce:uint;
		
		public function PongForTwo()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_ball.acceleration.y = 300;
			_leftPaddle.elasticity = 10;
			_rightPaddle.elasticity = 10;
			
			PADDLE_INFLUENCE = 0.75;
			
			_divider.callAll("kill");
			for (var i:uint = 0; i < 4; i++)
			{
				var block:FlxSprite = _divider.recycle(FlxSprite) as FlxSprite; 
				block.x = FlxG.width/2 - 5;
				block.y = FlxG.height - i * 20 - 15;
				block.makeGraphic(10,10,0xFFFFFFFF);
				block.immovable = true;
				block.elasticity = 1;
				block.revive();
				block.active = true;
				_divider.add(block);
			}
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		protected override function doCollisions():void
		{
			super.doCollisions();
			
			FlxG.collide(_ball,_divider);
		}
		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle,ball);
			
			ball.velocity.y -= 200;
			
			_lastBounce = NONE;
		}
		
		
		protected override function wallHit(ball:FlxObject, wall:FlxObject):void
		{
			super.wallHit(ball,wall);
			
			// Also want to check for a double bounce
			
			if (ball.x < FlxG.width/2)
			{
				if (_lastBounce == PLAYER_1)
				{
					trace("BALL BOUNCED ON PLAYER 1'S SIDE TWICE");
					_rightScore++;
					setScores(_leftScore,_rightScore);
					
					if (!gameIsOver())
					{
						postPoint();
					}
				}
				else
				{
					trace("BALL BOUNCED ON PLAYER 1'S SIDE ONCE");
					_lastBounce = PLAYER_1;
				}
			}
			else if (ball.x > FlxG.width/2)
			{
				if (_lastBounce == PLAYER_2)
				{
					trace("BALL BOUNCED ON PLAYER 2'S SIDE TWICE");
					_leftScore++;
					setScores(_leftScore,_rightScore);
					
					if (!gameIsOver())
					{
						postPoint();
					}
				}
				else
				{
					trace("BALL BOUNCED ON PLAYER 2'S SIDE ONCE");
					_lastBounce = PLAYER_2;
				}
			}
			
			// And a bounce on own side after hitting
			
			if (ball.x < FlxG.width/2)
			{
				if (_lastHit == PLAYER_1)
				{
					trace("BALL BOUNCED ON PLAYER 1'S SIDE AFTER PLAYER 1 HIT");
					_rightScore++;
					setScores(_leftScore,_rightScore);
					
					if (!gameIsOver())
					{
						postPoint();
					}
					
				}
			}
			else if (ball.x > FlxG.width/2)
			{
				if (_lastHit == PLAYER_2)
				{
					trace("BALL BOUNCED ON PLAYER 2'S SIDE AFTER PLAYER 2 HIT");
					_leftScore++;
					setScores(_leftScore,_rightScore);
					
					if (!gameIsOver())
					{
						postPoint();
					}
				}
				
			}
		}
		
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_lastBounce = NONE;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}