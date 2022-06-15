package
{
	import org.flixel.*;
	
	public class MemoriesOfPong extends StandardPong
	{
		
		public static const menuName:String = "MEMORIES OF PONG";
		
		private var _leftPaddleYPositions:Array = new Array();
		private var _rightPaddleYPositions:Array = new Array();
		private var _ballXPositions:Array = new Array();
		private var _ballYPositions:Array = new Array();
		
		private var _playBackLeftPaddleYPositions:Array;
		private var _playBackRightPaddleYPositions:Array;
		private var _playBackBallXPositions:Array;
		private var _playBackBallYPositions:Array;
		
		private var _playbackIndex:uint = 0;

		private var _memoryBall:FlxSprite;
		private var _memoryLeftPaddle:FlxSprite;
		private var _memoryRightPaddle:FlxSprite;
				
		
		
		public function MemoriesOfPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_memoryBall = new FlxSprite(-200, -200);
			_memoryBall.makeGraphic(Globals.BALL_SIZE,Globals.BALL_SIZE,0xBBFFFFFF);
			add(_memoryBall);
			
			_memoryLeftPaddle = new FlxSprite(0 + Globals.PADDLE_WIDTH, -200);
			_memoryLeftPaddle.makeGraphic(Globals.PADDLE_WIDTH,Globals.PADDLE_HEIGHT,0xBBFFFFFF);
			add(_memoryLeftPaddle);
			
			_memoryRightPaddle = new FlxSprite(FlxG.width - Globals.PADDLE_WIDTH*2, -200);
			_memoryRightPaddle.makeGraphic(Globals.PADDLE_WIDTH,Globals.PADDLE_HEIGHT,0xBBFFFFFF);
			add(_memoryRightPaddle);
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_state == PLAYING)
			{
				if (_playbackIndex < _playBackLeftPaddleYPositions.length)
				{
					_memoryLeftPaddle.y = _playBackLeftPaddleYPositions[_playbackIndex];
					_memoryRightPaddle.y = _playBackRightPaddleYPositions[_playbackIndex];
					_memoryBall.x = _playBackBallXPositions[_playbackIndex];
					_memoryBall.y = _playBackBallYPositions[_playbackIndex];
					
					_playbackIndex++;
				}
				
				_leftPaddleYPositions.push(_leftPaddle.y);
				_rightPaddleYPositions.push(_rightPaddle.y);
				_ballXPositions.push(_ball.x);
				_ballYPositions.push(_ball.y);
			}
		}
		
		
		protected override function resetPlay():void
		{
			super.resetPlay();
			
			_playbackIndex = 0;
			
			_playBackLeftPaddleYPositions = _leftPaddleYPositions.concat();
			_playBackRightPaddleYPositions = _rightPaddleYPositions.concat();
			_playBackBallXPositions = _ballXPositions.concat();
			_playBackBallYPositions = _ballYPositions.concat();
			
			_leftPaddleYPositions = new Array();
			_rightPaddleYPositions = new Array();
			_ballXPositions = new Array();
			_ballYPositions = new Array();			
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}
}