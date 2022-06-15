package
{
	import org.flixel.*;
	
	public class TeamPong extends StandardPong
	{	
		public static const menuName:String = "TEAM PONG";

		protected var _winner2Text:FlxText;
		protected var _winner2BG:FlxSprite;
		protected var _winner2BlackFrame:FlxSprite;
		protected var _winner2WhiteFrame:FlxSprite;
		
		protected var _result2Text:FlxText;

		
		public function TeamPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			
			_winner2BlackFrame = new FlxSprite(0,0);
			_winner2BlackFrame.makeGraphic(FlxG.width/2 - 20,FlxG.height/2 - 0,0xFF000000);
			_winner2BlackFrame.visible = false;
			
			_winner2WhiteFrame = new FlxSprite(0,0);
			_winner2WhiteFrame.makeGraphic(FlxG.width/2 - 30,FlxG.height/2 - 10,0xFFFFFFFF);
			_winner2WhiteFrame.visible = false;
			
			_winner2BG = new FlxSprite(0,0);
			_winner2BG.makeGraphic(FlxG.width/2 - 40,FlxG.height/2 - 20,0xFF000000);
			_winner2BG.visible = false;
			
			_winner2Text = new FlxText(0,0,FlxG.width/2,_winnerString,true);
			_winner2Text.setFormat("Commodore",32,0xFFFFFF,"center");
			_winner2Text.visible = false;
			
			_result2Text = new FlxText(0,0,FlxG.width/2,_resultString,true);
			_result2Text.setFormat("Commodore",18,0xFFFFFF,"center");
			_result2Text.visible = false;

			add(_winner2BlackFrame);
			add(_winner2WhiteFrame);
			add(_winner2BG);
			add(_winner2Text);
			add(_result2Text);

		}
		
		
		public override function update():void
		{
			super.update();
		}			
		
		
		protected override function checkBall(ball:FlxSprite):void
		{
			var point:Boolean = false;
			
			// If the ball has gone off the left side of the screen
			// Increase the right hand score, update the text, set point to true
			if (ball.x + ball.width < 0)
			{
				_rightScore -= 2;
				_leftScore -= 2;
				_lastPoint = PLAYER_2;
				point = true;
			}
				// If the ball has gone off the right side of the screen
				// Increase the left hand score, update the text, set point to true
			else if (ball.x > FlxG.width)
			{
				_rightScore -= 2;
				_leftScore -= 2;
				_lastPoint = PLAYER_1;
				point = true;
			}
			
			setScores(_leftScore,_rightScore);
			
			// If either player is at or over the winning score
			// and is at least two ahead...
			if ((_leftScore >= Globals.GAME_OVER_SCORE && _leftScore - 2 >= _rightScore)  || 
				(_rightScore >= Globals.GAME_OVER_SCORE && _rightScore - 2 >= _leftScore))
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				gameOver();
			}
				// Otherwise, if a point was scored, we go into the after point mode which
				// means delaying relaunching the ball
			else if (point)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
				resetPlay();
			}
		}
		
		
		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle, ball);
			
			_leftScore++;
			_rightScore++;
			setScores(_leftScore,_rightScore);
		}
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_winner2Text.visible = false;
			_result2Text.visible = false;
			_winner2BlackFrame.visible = false;
			_winner2WhiteFrame.visible = false;
			_winner2BG.visible = false;

		}
		
		
		protected override function gameIsOver():Boolean
		{
			return (_leftScore >= Globals.GAME_OVER_SCORE && _rightScore >= Globals.GAME_OVER_SCORE);
		}

		
		protected override function gameOver():void
		{
			_state = GAMEOVER;	
			
			_timer.stop();
			
			deactivate();
			
			_winnerText.x = 0;
			_resultText.x = 0;
			_winnerBG.x = 0 + 20;
			_winnerBlackFrame.x = 0 + 5;
			_winnerWhiteFrame.x = 0 + 15;
			
			_winner2Text.x = FlxG.width/2;
			_result2Text.x = FlxG.width/2;
			_winner2BG.x = FlxG.width/2 + 20;
			_winner2BlackFrame.x = FlxG.width/2 + 5;
			_winner2WhiteFrame.x = FlxG.width/2 + 15;
				
			_winnerText.y = 200;
			_resultText.y = 250;
			_winnerBG.y = 150 - 5;
			_winnerBlackFrame.y = 150 - 15;
			_winnerWhiteFrame.y = 150 - 10;
			
			_winner2Text.y = 200;
			_result2Text.y = 250;
			_winner2BG.y = 150 - 5;
			_winner2BlackFrame.y = 150 - 15;
			_winner2WhiteFrame.y = 150 - 10;

			_winnerBG.visible = true;
			_winnerBlackFrame.visible = true;
			_winnerWhiteFrame.visible = true;
			_winnerText.visible = true;
			_resultText.visible = true;
			
			_winner2BG.visible = true;
			_winner2BlackFrame.visible = true;
			_winner2WhiteFrame.visible = true;
			_winner2Text.visible = true;
			_result2Text.visible = true;

			_ball.visible = false;
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			this._winner2Text.destroy();
			this._result2Text.destroy();
			this._winner2BG.destroy();
			this._winner2BlackFrame.destroy();
			this._winner2WhiteFrame.destroy();
		}
	}
}