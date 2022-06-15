package
{
	import org.flixel.*;
	
	public class SwapPong extends StandardPong
	{	
		public static const menuName:String = "SWAPPED PONG";

		
		public function SwapPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"AVOID MISSING PADDLE FOR HIGH SCORE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";	
			
			_leftPaddle.makeGraphic(Globals.BALL_SIZE, Globals.BALL_SIZE, 0xFFFFFFFF);
			_rightPaddle.makeGraphic(Globals.BALL_SIZE, Globals.BALL_SIZE, 0xFFFFFFFF);
			_ball.makeGraphic(Globals.PADDLE_WIDTH, Globals.PADDLE_HEIGHT, 0xFFFFFFFF);
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}