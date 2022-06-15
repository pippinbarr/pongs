package
{
	import org.flixel.*;

	public class ShitPong extends StandardPong
	{
		public static const menuName:String = "POOP PONG";

		private var _shits:FlxGroup;
		private var _preShits:FlxGroup;


		public function ShitPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_shits = new FlxGroup();
			add(_shits);

			_preShits = new FlxGroup();
		}


		public override function update():void
		{
			super.update();

			checkShits();
		}


		private function checkShits():void
		{
			for (var i:uint = 0; i < _preShits.length; i++)
			{
				if (!FlxG.overlap(_ball,_preShits.members[i]))
				{
					_shits.add(_preShits.members[i]);
					_preShits.remove(_preShits.members[i]);
				}
			}
		}


		protected override function doCollisions():void
		{
			super.doCollisions();

			FlxG.collide(_ball,_shits, shitHit);
		}

		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle,ball);

			newShit(ball.x,ball.y);
		}


		protected override function wallHit(ball:FlxObject, wall:FlxObject):void
		{
			super.wallHit(ball,wall);

			newShit(ball.x,ball.y);
		}


		private function shitHit(ball:FlxObject, shit:FlxObject):void
		{
			newShit(ball.x,ball.y);
		}

		private function newShit(X:Number, Y:Number):void
		{
			var shit:FlxSprite = _preShits.recycle(FlxSprite) as FlxSprite;
			shit.revive();
			shit.x = X;
			shit.y = Y;
			shit.makeGraphic(Globals.BALL_SIZE,Globals.BALL_SIZE,0xFF733D1A);
			shit.immovable = true;
			shit.elasticity = 1;

			_preShits.add(shit);
		}


		protected override function gameOver():void
		{
			super.gameOver();

			// Get the win over the shits
			remove(_winnerBlackFrame);
			remove(_winnerWhiteFrame);
			remove(_winnerBG);
			remove(_winnerText);
			remove(_resultText);

			add(_winnerBlackFrame);
			add(_winnerWhiteFrame);
			add(_winnerBG);
			add(_winnerText);
			add(_resultText);

			_shits.callAll("kill");
		}


		protected override function resetPlay():void
		{
			super.resetPlay();
		}

		public override function destroy():void
		{
			super.destroy();

			_shits.destroy();
		}
	}
}
