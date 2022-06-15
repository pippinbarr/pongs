package
{
	import org.flixel.*;
	
	public class ViennesePong extends StandardPong
	{			
		public static const menuName:String = "VIENNESE PONG";

		private const QUESTION:uint = 4;
		private const DENIED:uint = 5;
		
		private var _questionText:FlxText;
		private var _questionString:String = "" +
			"ARE YOU CURRENTLY IN VIENNA?\n\n" +
			"(Y)ES    OR    (N)O";
		private var _deniedString:String = "" +
			"THEN YOU CANNOT PLAY VIENNESE PONG\n\n" +
			"PRESS [ESCAPE] TO EXIT";
				
		
		public function ViennesePong()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			_titleText.text = menuName;
						
			_instructionsText.visible = false;
			
			_questionText = new FlxText(64,128,FlxG.width,_questionString,true);
			_questionText.setFormat("Commodore",16,0xFFFFFF,"left");
			add(_questionText);
			_questionText.visible = true;
			
			_state = QUESTION;
		}
		
		
		protected override function handleInput():void
		{
			super.handleInput();
			
			handleQuestion();
		}
		
		
		private function handleQuestion():void
		{
			if (_state == QUESTION)
			{
				if (FlxG.keys.Y)
				{
					_state = INSTRUCTIONS;
					_questionText.visible = false;
					_instructionsText.visible = true;
				}
				else if (FlxG.keys.N)
				{
					_state = DENIED;
					_questionText.text = _deniedString;
				}
				return;
			}	
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			this._questionText.destroy();
		}
	}
}