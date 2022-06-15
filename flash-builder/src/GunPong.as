package
{
	import org.flixel.*;
	
	public class GunPong extends StandardPong
	{	
		public static const menuName:String = "LASER PONG";
		
		private var _leftBulletReady:Boolean = true;
		private var _leftBullet:FlxSprite;
		private var _rightBulletReady:Boolean = true;
		private var _rightBullet:FlxSprite;
		
		public function GunPong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
			_instructionsText.text = "" +
				"PLAYER 1: [W] / [S] TO MOVE, [D] TO FIRE\n\n" +
				"PLAYER 2: [UP] / [DOWN] TO MOVE, [LEFT] TO FIRE\n\n" +
				"AVOID MISSING BALL FOR HIGH SCORE\n\n" +
				"DON'T SHOOT THE BALL\n\n" +
				"[SPACE] TO START\n[ESCAPE] TO QUIT";
			
			_leftBullet = new FlxSprite(FlxG.width/2,-200).makeGraphic(10,2,0xFFFFFFFF);
			_leftBullet.immovable = true;
			_leftBullet.elasticity = 1;
			
			_rightBullet = new FlxSprite(FlxG.width/2,-200).makeGraphic(10,2,0xFFFFFFFF);
			_rightBullet.immovable = true;
			_rightBullet.elasticity = 1;
			
			add(_leftBullet);
			_leftBullet.visible = true;
			add(_rightBullet);
			_rightBullet.visible = true;
		}
		
		
		public override function update():void
		{
			if (_state == PLAYING)
			{
				checkBullets();
			}
			
			super.update();
		}
		
		
		private function checkBullets():void
		{
			if (_leftBullet.x > FlxG.width)
			{
				_leftBullet.velocity.x = 0;
				_leftBullet.x = FlxG.width/2;
				_leftBullet.y = -200;
				_leftBulletReady = true;
			}
			if (_rightBullet.x + _rightBullet.width < 0)
			{
				_rightBullet.velocity.x = 0;
				_rightBullet.x = FlxG.width/2;
				_rightBullet.y = -200;
				_rightBulletReady = true;
			}
		}
		
		
		protected override function doCollisions():void
		{
			super.doCollisions();
			
			FlxG.overlap(_rightBullet, _leftPaddle, bulletHit);
			FlxG.overlap(_leftBullet, _rightPaddle, bulletHit);
			FlxG.overlap(_rightBullet, _ball, ballShot);
			FlxG.overlap(_leftBullet, _ball, ballShot);
		}
		
		
		private function bulletHit(bullet:FlxObject, paddle:FlxObject):void
		{
			FlxG.play(Assets.POINT_SOUND);

			paddle.kill();

			if (bullet.velocity.x < 0)
				_rightBulletReady = true;
			else if (bullet.velocity.x > 0)
				_leftBulletReady = true;
			bullet.velocity.x = 0;
			
			bullet.x = FlxG.width/2;
			bullet.y = -200;
		}
		
		
		private function ballShot(bullet:FlxObject, ball:FlxObject):void
		{
			FlxG.play(Assets.POINT_SOUND);
			
			ball.kill();
			
			if (bullet.velocity.x < 0)
			{
				_rightBulletReady = true;
				_leftScore++;
			}
			else if (bullet.velocity.x > 0)
			{
				_leftBulletReady = true;
				_rightScore++;
			}
			setScores(_leftScore,_rightScore);
			
			bullet.velocity.x = 0;
			bullet.x = FlxG.width/2;
			bullet.y = -200;
			
			resetPlay();
		}
				
		
		protected override function resetPlay():void
		{
			
			super.resetPlay();
			
			_leftPaddle.revive();
			_rightPaddle.revive();
			_ball.revive();
			
			_leftBullet.x = FlxG.width/2;
			_leftBullet.y = -200;
			_leftBullet.velocity.x = 0;
			_leftBulletReady = true;
			
			_rightBullet.x = FlxG.width/2;
			_rightBullet.y = -200;
			_rightBullet.velocity.x = 0;
			_rightBulletReady = true;
		}

		
		protected override function handleInput():void
		{
			super.handleInput();
			
			handleLaserInput();
		}
		
		
		private function handleLaserInput():void
		{
			if (FlxG.keys.LEFT && _rightBulletReady)
			{
				_rightBullet.x = _rightPaddle.x - _rightBullet.width/2;
				_rightBullet.y = _rightPaddle.y + (_rightPaddle.height/2) - _rightBullet.height/2;
				_rightBullet.velocity.x = -300;
				_rightBulletReady = false;
			}
			
			if (FlxG.keys.D && _leftBulletReady)
			{
				_leftBullet.x = _leftPaddle.x;
				_leftBullet.y = _leftPaddle.y + (_leftPaddle.height/2) - _leftBullet.height/2;
				_leftBullet.velocity.x = 300;
				_leftBulletReady = false;
			}
		}
		
			
		
		public override function destroy():void
		{
			super.destroy();
			
			this._leftBullet.destroy();
			this._rightBullet.destroy();
		}
	}
}