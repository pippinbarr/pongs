package
{
	import org.flixel.*;
	
	public class BreakdownPong extends StandardPong
	{	
		public static const menuName:String = "BREAKDOWN PONG";
		
		private var _leftPaddleGroup:FlxGroup;
		private var _rightPaddleGroup:FlxGroup;

		private var ZERO_VELOCITY:FlxPoint = new FlxPoint(0,0);
		private var UP_VELOCITY:FlxPoint = new FlxPoint(0,-Globals.PADDLE_SPEED);
		private var DOWN_VELOCITY:FlxPoint = new FlxPoint(0, Globals.PADDLE_SPEED);
		
		private var _paddlesReset:Boolean = true;
		
		
		public function BreakdownPong()
		{
			//super();
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			_leftPaddleGroup = new FlxGroup();
			_rightPaddleGroup = new FlxGroup();
			
			for (var i:uint = 0; i < 6; i++)
			{
				var leftBlock:FlxSprite = new FlxSprite(10,220 + (i * 10));
				leftBlock.makeGraphic(10,10,0xFFFFFFFF);
				leftBlock.immovable = true;
				leftBlock.elasticity = 1;
				_leftPaddleGroup.add(leftBlock);

				var rightBlock:FlxSprite = new FlxSprite(FlxG.width - 20,220 + (i * 10));
				rightBlock.makeGraphic(10,10,0xFFFFFFFF);
				rightBlock.immovable = true;
				rightBlock.elasticity = 1;
				_rightPaddleGroup.add(rightBlock);
			}
			
			remove(_leftPaddle);
			remove(_rightPaddle);
			
			add(_leftPaddleGroup);
			_leftPaddleGroup.visible = false;
			add(_rightPaddleGroup);
			_rightPaddleGroup.visible = false;
		
			// And set the starting state...
			_state = INSTRUCTIONS;
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		protected override function doCollisions():void
		{
			FlxG.collide(_ball, _walls, wallHit);
			FlxG.collide(_leftPaddleGroup, _ball, paddleHit);
			FlxG.collide(_rightPaddleGroup, _ball, paddleHit);
		}
		
		
		protected override function paddleHit(_paddle:FlxObject, _ball:FlxObject):void
		{
			FlxG.play(Assets.PADDLE_SOUND);
			_paddle.kill();
			_paddle.exists = false;

			_ballDirection = Math.atan2(_ball.velocity.y,_ball.velocity.x);
			_ball.velocity.y = Math.sin(_ballDirection) * Globals.BALL_SPEED + (_paddle.velocity.y * Globals.PADDLE_BALL_INFLUENCE_FACTOR);		
		}
		
		
		protected override function activate():void
		{
			_ball.active = true;
			_leftPaddleGroup.active = true;
			_rightPaddleGroup.active = true;
		}
		
		
		protected override function deactivate():void
		{
			_ball.active = false;
			_leftPaddleGroup.active = false;
			_rightPaddleGroup.active = false;
		}
		
		
		protected override function resetPlay():void
		{
			_state = PLAYING;
			_paddlesReset = false;
						
			var firstAliveLeftIndex:int = -1;
			for (var i:uint = 0; i < _leftPaddleGroup.length; i++)
			{
				if (firstAliveLeftIndex == -1 && _leftPaddleGroup.members[i].alive)
				{
					firstAliveLeftIndex = i;
					break;
				}
			}
			
			var firstAliveRightIndex:int = -1;
			for (i = 0; i < _rightPaddleGroup.length; i++)
			{
				if (firstAliveRightIndex == -1 && _rightPaddleGroup.members[i].alive)
				{
					firstAliveRightIndex = i;	
					break;
				}
			}
			
			var leftTopY:Number = 0;
			if (firstAliveLeftIndex == 0)
			{
				leftTopY = _leftPaddleGroup.members[firstAliveLeftIndex].y;		
			}
			else if (firstAliveLeftIndex != -1)
			{
				leftTopY = _leftPaddleGroup.members[firstAliveLeftIndex].y - (10 * firstAliveLeftIndex);
			}
			else 
			{
				leftTopY = 220;
			}
			
			var rightTopY:Number = 0;
			if (firstAliveRightIndex == 0)
			{
				rightTopY = _rightPaddleGroup.members[firstAliveRightIndex].y;		
			}
			else if (firstAliveRightIndex != -1)
			{
				rightTopY = _rightPaddleGroup.members[firstAliveRightIndex].y - (10 * firstAliveRightIndex);
			}
			else 
			{
				rightTopY = 220;
			}

			for (i = 0; i < _leftPaddleGroup.length; i++)
			{
				_leftPaddleGroup.members[i].y = leftTopY + (i * 10);
				_rightPaddleGroup.members[i].y = rightTopY + (i * 10);
			}

			checkBoundaries(_leftPaddleGroup);
			checkBoundaries(_rightPaddleGroup);
			
			_leftPaddleGroup.callAll("revive");
			_rightPaddleGroup.callAll("revive");
			
						
			// Put the ball in the middle of the screen
			_ball.x = FlxG.width/2 - _ball.width/2;
			_ball.y = FlxG.height/2 - _ball.height/2;
			
			// Zero its velocity
			_ball.velocity.x = 0;
			_ball.velocity.y = 0;
			
			// Launch the ball after a delay
			trace("Calling launch timer.");
			_timer.start(Globals.BALL_LAUNCH_DELAY,1,launchBall);
			

		}
		
		
		protected override function swapTitleAndPlayVisibles():void
		{
			_titleText.visible = false;
			_instructionsText.visible = false;
			
			_winnerText.visible = false;
			_resultText.visible = false;
			
			_leftScoreText.visible = true;
			_rightScoreText.visible = true;
			_leftScoreLabel.visible = true;
			_rightScoreLabel.visible = true;
			
			_divider.visible = true;
			_walls.visible = true;
			
			_leftPaddleGroup.visible = true;
			_rightPaddleGroup.visible = true;
			_ball.visible = true;
		}
		
		
		protected override function handlePaddleInput():void
		{
			// Zero the velocities to start
			_leftPaddleGroup.setAll("velocity",ZERO_VELOCITY);
			_rightPaddleGroup.setAll("velocity",ZERO_VELOCITY);
						
			// RIGHT PADDLE
			if (FlxG.keys.UP)
			{
				_rightPaddleGroup.setAll("velocity", UP_VELOCITY);
			}
			else if (FlxG.keys.DOWN)
			{
				_rightPaddleGroup.setAll("velocity", DOWN_VELOCITY);
			}
			
			checkBoundaries(_rightPaddleGroup);

			
			// LEFT PADDLE
			if (FlxG.keys.W)
			{
				_leftPaddleGroup.setAll("velocity", UP_VELOCITY);
			}
			else if (FlxG.keys.S)
			{
				_leftPaddleGroup.setAll("velocity", DOWN_VELOCITY);
			}
			
			checkBoundaries(_leftPaddleGroup);
			
		}
		
		
		private function checkBoundaries(group:FlxGroup):void
		{
			var i:int = 0;
			trace("group.length = " + group.length);
			while (i < group.length)
			{
				if (group.members[i].alive && group.members[i].y < 0)
				{
					var add:Number = Math.abs(group.members[i].y);
					for (var j:int = 0; j < group.length; j++)
					{
						group.members[j].y += add;
					}
					break;
				}
				i++;
			}
			
			i = group.length - 1;
			while (i >= 0)
			{
				if (group.members[i].alive && group.members[i].y + group.members[i].height > FlxG.height)
				{
					var sub:Number = Math.abs(FlxG.height - (group.members[i].y + group.members[i].height));
					for (var k:int = 0; k < group.length; k++)
					{
						group.members[k].y -= sub;
					}
					break;
				}
				i--;
			}
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			this._leftPaddleGroup.destroy();
			this._rightPaddleGroup.destroy();
		}
	}
}