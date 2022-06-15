package
{
	import org.flixel.*;


	public class CountdownPong extends StandardPong
	{
		public static const menuName:String = "COUNTDOWN PONG";

		[Embed(source="/assets/images/particle.png")]
		private const PARTICLE:Class;

		private const COUNTDOWN_MINIMUM:uint = 5;
		private const COUNTDOWN_EXTRA:uint = 5;

		private var _countDownText:FlxText;
		private var _count:int = -1;


		public function CountdownPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_countDownText = new FlxText(-200,-200,50,"",true);
			_countDownText.setFormat("Commodore",18,0xFFFFFF,"center");
			_countDownText.visible = false;
			add(_countDownText);
		}


		public override function update():void
		{
			super.update();

			if (PLAYING)
			{
				_countDownText.text = _count.toString();
				_countDownText.y = _ball.y - 20;
				_countDownText.x = _ball.x + _ball.width/2 - _countDownText.width/2;
			}
		}


		protected override function paddleHit(paddle:FlxObject, ball:FlxObject):void
		{
			super.paddleHit(paddle,ball);

			_count--;
			if (_count == 0)
			{
				startExplosion();
			}
		}


		protected override function wallHit(ball:FlxObject, wall:FlxObject):void
		{
			super.wallHit(ball,wall);

			_count--;
			if (_count == 0)
			{
				startExplosion();
			}
		}


		private function startExplosion():void
		{
			_state = AFTER_POINT;

			if (_ball.x + _ball.width/2 < FlxG.width/2)
			{
				_rightScore++;
			}
			else if (_ball.x + _ball.width/2 > FlxG.width/2)
			{
				_leftScore++;
			}
			setScores(_leftScore,_rightScore);

			_ball.velocity.x = 0;
			_ball.velocity.y = 0;

			explode(null);
		}


		private function explode(t:FlxTimer):void
		{
			_countDownText.visible = false;
			_ball.visible = false;

			var emitter:FlxEmitter = new FlxEmitter(_ball.x + _ball.width/2,_ball.y + _ball.height/2);

			emitter.makeParticles(PARTICLE,100,0);
			emitter.setXSpeed(-200,200);
			emitter.setYSpeed(-200,200);

			add(emitter);
			emitter.start(true,1);
			_timer.start(1,1,postExplosion);
		}


		private function postExplosion(t:FlxTimer):void
		{
			resetPlay();
		}


		protected override function resetPlay():void
		{
			super.resetPlay();

			_count = Math.floor(Math.random() * COUNTDOWN_EXTRA) + COUNTDOWN_MINIMUM;
			_countDownText.text = _count.toString();

			_countDownText.visible = true;
			_ball.visible = true;
		}


		protected override function swapTitleAndPlayVisibles():void
		{
			super.swapTitleAndPlayVisibles();

			_countDownText.visible = true;
		}


		public override function destroy():void
		{
			super.destroy();

			_countDownText.destroy();
		}
	}
}
