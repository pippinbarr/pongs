package
{
	import org.flixel.*;
	
	public class PongInTheMiddle extends StandardPong
	{
		public static const menuName:String = "PONG IN THE MIDDLE";
		
		private var _middlePaddle:FlxSprite;
		
		private const MIDDLE_PADDLE_MAX_SPEED:uint = Globals.PADDLE_SPEED;
		
		public function PongInTheMiddle()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_middlePaddle = new FlxSprite(FlxG.width/2 - Globals.PADDLE_WIDTH/2,FlxG.height/2 - Globals.PADDLE_HEIGHT/2);
			_middlePaddle.makeGraphic(Globals.PADDLE_WIDTH,Globals.PADDLE_HEIGHT,0xFFFFFFFF);
			_middlePaddle.immovable = true;
			_middlePaddle.elasticity = 1;
			
			add(_middlePaddle);
			_middlePaddle.visible = false;
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_state == PLAYING)
			{
				updateAI();
			}
		}
		
		
		protected override function doCollisions():void
		{
			super.doCollisions();
			
			FlxG.collide(_middlePaddle,_ball,paddleHit);
		}
		
		
		private function updateAI():void
		{
			_middlePaddle.velocity.y = 0;
			
			var middlePaddleCenter:Number = _middlePaddle.y + _middlePaddle.height/2;
			
			if ((_ball.x < FlxG.width/2 && _ball.velocity.x > 0) || 
				(_ball.x > FlxG.width/2 && _ball.velocity.x < 0))
			{
				// BALL COMING FROM THE RIGHT SO INTERCEPT
				if (middlePaddleCenter < _ball.y - 10)
				{
					_middlePaddle.velocity.y = MIDDLE_PADDLE_MAX_SPEED - int(Math.random() * 300);
				}
				else if (middlePaddleCenter > _ball.y + 10)
				{
					_middlePaddle.velocity.y = -MIDDLE_PADDLE_MAX_SPEED + int(Math.random() * 300);
				}
			}
			else
			{
				// BALL NOT COMING, SO RETURN TO MIDDLE
				if (middlePaddleCenter > FlxG.height/2 + 10)
				{
					_middlePaddle.velocity.y = -MIDDLE_PADDLE_MAX_SPEED + int(Math.random() * 200);
				}
				else if (middlePaddleCenter < FlxG.height/2  - 10)
				{
					_middlePaddle.velocity.y = MIDDLE_PADDLE_MAX_SPEED - int(Math.random() * 200);
				}
			}
		}
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_middlePaddle.visible = true;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}