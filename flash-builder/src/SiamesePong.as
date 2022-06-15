package
{
	import org.flixel.*;
	
	public class SiamesePong extends StandardPong
	{	
		public static const menuName:String = "SIAMESE PONG";

		public function SiamesePong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		
		protected override function handlePaddleInput():void
		{
			// Zero the velocities to start
			_leftPaddle.velocity.y = 0;
			_rightPaddle.velocity.y = 0;
			
			// RIGHT PADDLE
			if (FlxG.keys.UP)
			{
				_rightPaddle.velocity.y += -PADDLE_SPEED;
				_leftPaddle.velocity.y += -PADDLE_SPEED;
			}
			else if (FlxG.keys.DOWN && _rightPaddle.y + _rightPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y += PADDLE_SPEED;
				_leftPaddle.velocity.y += PADDLE_SPEED;
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
				_rightPaddle.velocity.y += -PADDLE_SPEED;
				_leftPaddle.velocity.y += -PADDLE_SPEED;
			}
			else if (FlxG.keys.S && _leftPaddle.y + _leftPaddle.height < FlxG.height)
			{
				_rightPaddle.velocity.y += PADDLE_SPEED;
				_leftPaddle.velocity.y += PADDLE_SPEED;
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
		}
	}
}