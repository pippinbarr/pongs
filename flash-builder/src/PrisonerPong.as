package
{
	import org.flixel.*;
	
	public class PrisonerPong extends StandardPong
	{	
		public static const menuName:String = "PRISONER PONG";

		private const LEFT_OUT:uint = 4;
		private const RIGHT_OUT:uint = 5;
		private const BOTH_OUT:uint = 6;
		
		private var _leftPlayerMissed:Boolean = true;
		private var _rightPlayerMissed:Boolean = true;
		
		private var _prisonWall:FlxSprite;
		private var _ball2:FlxSprite;
		
		private var _ball2Direction:Number; // Angle in radians the ball is moving along
		
		private var _leftTimer:FlxTimer;
		private var _rightTimer:FlxTimer;
		
		
		public function PrisonerPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();

			_titleText.text = menuName;
			
			_ball2 = new FlxSprite(-20, 214).makeGraphic(Globals.BALL_SIZE, Globals.BALL_SIZE, 0xFFFFFFFF);
			_ball2.elasticity = 1;
			_ball2.maxVelocity.x = 300;
			_ball2.maxVelocity.y = 300;
			
			_ball.x = FlxG.width/2 - 5*_ball.width/2;
			_ball.y = FlxG.height/2 - _ball.height/2;
			
			_ball2.x = FlxG.width/2 + 3*_ball.width/2;
			_ball2.y = FlxG.height/2 - _ball.height/2;
						
			// Set up the dividing line
			_prisonWall = new FlxSprite(FlxG.width/2 - 5,0);
			_prisonWall.makeGraphic(10,FlxG.height,0xFFFFFFFF);
			_prisonWall.immovable = true;
			_prisonWall.elasticity = 1;
			
			_leftTimer = new FlxTimer();
			_rightTimer = new FlxTimer();
			
			remove(_divider);
			
			add(_prisonWall);
			_prisonWall.visible = false;
			add(_ball2);
			_ball2.visible = false;
			
			OVERRIDE_UPDATE = true;
		}
		
		
		public override function update():void
		{
			super.update();
			
			handleInput();
			
			// We only handle collisions and so on if the game is playing
			
			if (_state != GAMEOVER)
			{
				checkLeftBall();
				FlxG.collide(_ball, _walls, wallHit);
				FlxG.collide(_leftPaddle, _ball, paddleHit);
				FlxG.collide(_ball, _prisonWall, dividerHit);
				
				checkRightBall();
				FlxG.collide(_ball2, _walls, wallHit);
				FlxG.collide(_rightPaddle, _ball2, paddleHit);
				FlxG.collide(_ball2, _divider, dividerHit);
				
				checkScores();
			}
		}
		
		
		
		private function checkLeftBall():void
		{			
			// If the ball has gone off the left side of the screen
			// Increase the right hand score, update the text, set point to true
			if (_ball.x + _ball.width < 0)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
								
				resetLeft();
			}
		}
		
		
		private function checkRightBall():void
		{
			if (_ball2.x > FlxG.width)
			{
				FlxG.play(Assets.POINT_SOUND,0.5);
								
				resetRight();
			}
		}
		
		private function resetLeft():void
		{			
			_ball.active = true;
			_leftPaddle.active = true;
			
			_ball.velocity.x = 0;
			_ball.velocity.y = 0;
			
			_ball.y = FlxG.height/2 - _ball.height/2;
			_ball.x = FlxG.width/2 - 5*_ball.width/2;
			
			// Launch the ball after a delay
			trace("Calling launch timer.");
			_leftTimer.start(Globals.BALL_LAUNCH_DELAY,1,launchLeftBall);
		}
		
		
		private function resetRight():void
		{
			_ball2.velocity.x = 0;
			_ball2.velocity.y = 0;
			
			_ball2.x = FlxG.width/2 + 3*_ball2.width/2;
			_ball2.y = FlxG.height/2 - _ball2.height/2;
			
			_ball2.active = true;	
			_rightPaddle.active = true;
			
			_rightTimer.start(Globals.BALL_LAUNCH_DELAY,1,launchRightBall);
		}
		
		private function checkScores():void
		{
			// If either player is at or over the winning score
			// and is at least two ahead...
			if ((_leftScore >= Globals.GAME_OVER_SCORE && _leftScore - 2 >= _rightScore)  || 
				(_rightScore >= Globals.GAME_OVER_SCORE && _rightScore - 2 >= _leftScore))
			{
				gameOver();
			}
		}
		
		
		private function dividerHit(ball:FlxObject, divider:FlxObject):void
		{
			FlxG.play(Assets.WALL_SOUND);
			
			if (ball.x < FlxG.width/2)
			{
				_leftScore++;
			}
			else if (ball.x + ball.width > FlxG.width/2)
			{
				_rightScore++;
			}
			setScores(_leftScore,_rightScore);
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
			
			_leftTimer.stop();
			_rightTimer.stop();
		}
		
		
		protected override function activate():void
		{
			_ball.active = true;
			_ball2.active = true;
			_leftPaddle.active = true;
			_rightPaddle.active = true;
		}
		
		protected override function deactivate():void
		{
			_ball.active = false;
			_ball2.active = false;
			_leftPaddle.active = false;
			_rightPaddle.active = false;
		}

		
		private function launchLeftBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			_ball.x = FlxG.width/2 - 5*_ball.width/2;
			_ball.y = FlxG.height/2 - _ball.height/2;
			
			_ballDirection = (Math.random() * Math.PI/4) + Math.PI - Math.PI/8;
			
			_ball.velocity.x = Math.cos(_ballDirection) * Globals.BALL_SPEED;
			_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED;			
		}
		
		
		private function launchRightBall(t:FlxTimer):void
		{
			_state = PLAYING;
			
			_ball2.x = FlxG.width/2 + 3*_ball2.width/2;
			_ball2.y = FlxG.height/2 - _ball2.height/2;
			
			_ball2Direction = (Math.random() * Math.PI/4) - Math.PI/8;
			
			_ball2.velocity.x = Math.cos(_ball2Direction) * Globals.BALL_SPEED;
			_ball2.velocity.y = Math.sin(_ball2Direction) * Globals.BALL_SPEED;
		}
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();
			
			_ball2.visible = true;
			_prisonWall.visible = true;
		}
		
		
		protected override function handleSpacePressed():void
		{			
			if (_state == INSTRUCTIONS || _state == GAMEOVER)
			{	
				if (FlxG.keys.SPACE)
				{
					setScores(0,0);
					
					swapTitleAndPlayVisibles();
					
					resetLeft();
					resetRight();
					
					_state = PLAYING;
				}
				return;
			}
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			this._ball2.destroy();
			this._prisonWall.destroy();
			this._leftTimer.destroy();
			this._rightTimer.destroy();
		}
	}
}