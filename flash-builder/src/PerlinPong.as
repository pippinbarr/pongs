package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class PerlinPong extends StandardPong
	{	
		public static const menuName:String = "PERLIN PONG";
		
		private const PRELAUNCH:uint = 4;
				
		private var _perlinData:BitmapData;
		private var _perlinIndex:uint = 0;
		
		
		public function PerlinPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_perlinData = new BitmapData(3000,1);
			_perlinData.perlinNoise(100,1,2,int(Math.random() * 100),false,false,7,false);
			
			BALL_SPEED = Globals.BALL_SPEED * 0.75;
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_state == PLAYING)
			{
				perlinBall();
			}
		}
		
		
		private function perlinBall():void
		{
			var pixel:uint = _perlinData.getPixel(_perlinIndex,0);

			var red:uint = pixel >> 16 & 0xFF;
			var green:uint = pixel >> 8 & 0xFF;
			var blue:uint = pixel & 0xFF;
						
			var effect:Number = (red - 127) / 128;
			
			_perlinIndex = (_perlinIndex + 1) % _perlinData.width;
			
			_ball.velocity.y += (effect + 0.5) * Globals.BALL_SPEED/4; 
		}
		
		
		protected override function paddleHit(_paddle:FlxObject, _ball:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);
		}
		
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_state = PRELAUNCH;
		}
		
		
		protected override function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			// Set the ball's velocities based on the previous
			// point winner (launch at them)
			if (_lastPoint == PLAYER_2)
			{
				_ball.velocity.x = -BALL_SPEED;
			}
			else if (_lastPoint == PLAYER_1)
			{
				_ball.velocity.x = BALL_SPEED;
			}			
		}
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}