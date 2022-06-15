package
{
	import org.flixel.*;
	
	public class BlindPong extends StandardPong
	{	
		public static const menuName:String = "BLIND PONG";
		
		public function BlindPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"BALL ALWAYS SERVED STRAIGHT AHEAD\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
		}
		
		
		public override function update():void
		{
			super.update();
		}

		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_ball.visible = false;
			_divider.visible = false;
		}
		
		protected override function launchBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			if (_lastPoint == PLAYER_2)
			{
				_ballDirection = 0;
			}
			else if (_lastPoint == PLAYER_1)
			{
				_ballDirection = Math.PI;
			}
			_ball.velocity.x = Math.cos(_ballDirection) * Globals.BALL_SPEED;
			_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED;			}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}