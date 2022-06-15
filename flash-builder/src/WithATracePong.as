package
{
	import flash.display.Sprite;
	import org.flixel.*;
	
	public class WithATracePong extends StandardPong
	{
		
		public static const menuName:String = "TRACE PONG";
		
		private var _trace:Sprite;
		
		private var _lastBallX:Number;
		private var _lastBallY:Number;
		
		
		public function WithATracePong()
		{
		}

		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_trace = new Sprite();
			_trace.x = 0; _trace.y = 0;
			FlxG.stage.addChild(_trace);
			_trace.visible = false;
			
			_lastBallX = FlxG.width/2 - _ball.width/2;
			_lastBallY = FlxG.height/2 - _ball.height/2;
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (PLAYING)
			{
				drawTrace();
			}
			
			_lastBallX = _ball.x;
			_lastBallY = _ball.y;
		}
		
	
		private function drawTrace():void
		{
			_trace.graphics.beginFill(0xFFFFFF);
			_trace.graphics.drawRect(_lastBallX,_lastBallY,Globals.BALL_SIZE,Globals.BALL_SIZE);
			_trace.graphics.endFill();			
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
			
			_trace.graphics.clear();
		}
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_trace.graphics.clear();
			_lastBallX = FlxG.width/2 - _ball.width/2;
			_lastBallY = FlxG.height/2 - _ball.height/2;
		}
		
		protected override function handleSpacePressed():void
		{			
			if (FlxG.keys.SPACE && (_state == INSTRUCTIONS || _state == GAMEOVER))
			{
				_trace.visible = true;
			}
			
			super.handleSpacePressed();
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			FlxG.stage.removeChild(_trace);
		}
		
	}
}