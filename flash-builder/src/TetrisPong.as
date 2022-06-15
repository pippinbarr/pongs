package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class TetrisPong extends StandardPong
	{
		public static const menuName:String = "TETRIS PONG";
		
		private var _blocks:FlxGroup;
		private var _frameCount:uint = 0;
		
		
		public function TetrisPong()
		{
		}
		
		
		public override function create():void
		{
			trace("TetrisPong.create()");
			
			super.create();
			
			_titleText.text = menuName;
			
			_blocks = new FlxGroup();
			add(_blocks);
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_state == PLAYING)
			{
				_frameCount++;
				
				if (_frameCount % 240 == 0)
				{
					var block:TetrisBlock = _blocks.recycle(TetrisBlock) as TetrisBlock;
					block.revive();
					block.setupBlock();
					_blocks.add(block);
				}
			}
		}
		
		
		protected override function doCollisions():void
		{
			super.doCollisions();
			
			FlxG.overlap(_ball,_blocks,ballBlockHit);
			FlxG.overlap(_blocks,_blocks,blockBlockHit);
		}
		
		
		protected override function gameOver():void
		{
			super.gameOver();
						
			trace("Removing and adding win thing");
			
			remove(_blocks);
			
			remove(_winnerBlackFrame);
			remove(_winnerWhiteFrame);
			remove(_winnerBG);
			remove(_winnerText);
			remove(_resultText);
			
			add(_blocks);
			
			add(_winnerBlackFrame);
			add(_winnerWhiteFrame);
			add(_winnerBG);
			add(_winnerText);
			add(_resultText);
		}
		
		
		protected override function resetPlay():void
		{
			if (_state == GAMEOVER)
				_blocks.callAll("kill");
			
			super.resetPlay();
		}
		
		
		protected override function activate():void
		{
			super.activate();
			
			_blocks.active = true;
		}
		
		
		protected override function deactivate():void
		{
			super.deactivate();
			
			_blocks.active = false;
		}
		
		private function ballBlockHit(ball:FlxObject, block:FlxObject):void
		{
			var separateX:Boolean = FlxCollision.pixelPerfectSeparateX(ball as FlxSprite,block as TetrisBlock);
			var separateY:Boolean = FlxCollision.pixelPerfectSeparateY(ball as FlxSprite,block as TetrisBlock);
			
			var immovable:Boolean = block.immovable;
			block.immovable = true;
			if (separateX && !separateY)
			{
				_ball.velocity.x = block.velocity.x - _ball.velocity.x;
			}
			else if (separateY && !separateX)
			{
				_ball.velocity.y = block.velocity.y - _ball.velocity.y;
			}
			else if (separateX && separateY)
			{
				_ball.velocity.x = block.velocity.x - _ball.velocity.x;
				_ball.velocity.y = block.velocity.y - _ball.velocity.y;
			}
			block.immovable = immovable;
		}
		
		
		private function blockBlockHit(block1:FlxObject, block2:FlxObject):void
		{			
			var b1:TetrisBlock = block1 as TetrisBlock;
			var b2:TetrisBlock = block2 as TetrisBlock;
			
			if (b1.immovable && b2.immovable) return;
			
			trace("blockBlockHit()");
			trace("b1.y is " + b1.y + ", b2.y is " + b2.y);
			trace("b1.immovable is " + b1.immovable + ", b2.immovable is " + b2.immovable);
			
			if (b2.immovable && 
				FlxCollision.pixelPerfectSeparateY(b1,b2))
			{
				trace("b2.immovable && pixelPerfect separate b1,b2");
				b1.velocity.y = 0;
				b1.immovable = true;
			}
			else if (b1.immovable && 
				FlxCollision.pixelPerfectSeparateY(b2,b1))
			{
				trace("b1.immovable && pixelPerfect separate b2,b1");
				b2.velocity.y = 0;
				b2.immovable = true;
			}
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			_blocks.destroy();
		}
	}
}