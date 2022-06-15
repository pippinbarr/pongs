/**
 * Atari 2600 Breakout
 * In Flixel 2.5
 * By Richard Davey, Photon Storm
 * In 20mins :)
 *
 * Modified by Pippin Barr
 * In way longer :(
 */
package
{
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	import flash.display.*;

	import org.flixel.*;

	public class ClickToPong extends FlxState
	{
		private var bricks:FlxGroup;
		private var _instructionsText:FlxText;


		public function ClickToPong()
		{
		}

		override public function create():void
		{
    			FlxG.stage.showDefaultContextMenu = false;
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL;
      FlxG.stage.align = '';


//      FlxG.stage.backgroundColor = '#000';
//
//			FlxG.stage.align = StageAlign.TOP;
//
			fscommand("trapallkeys","true");

			_instructionsText = new FlxText(0,0,FlxG.width,"CLICK TO PONG",true);
			_instructionsText.setFormat(null,130,0xFFFFFFFF,"center");

			add(_instructionsText);

			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);



		}

		override public function update():void
		{
			super.update();
		}





		private function onMouseUp(e:MouseEvent):void
		{
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			FlxG.switchState(new MenuState);
		}


		public override function destroy():void
		{
			_instructionsText.destroy();
		}


	}

}
