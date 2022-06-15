package
{
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private var bp:BallPong;
		private var blp:BlindPong;
		private var bdp:BreakdownPong;
		private var bop:BreakoutPong;
		private var btp:ButtonPong;
		private var cdp:CountdownPong;
		private var edp:EduPong;
		private var ep:EpilepsyPong;
		private var fp:FertilityPong;
		private var gp:GhostPong;
		private var gnp:GunPong;
		private var ip:InversePong;
		private var memp:MemoriesOfPong;
		private var mp:MetaPong;
		private var nwp:NoWallsPong;
		private var prp:PerlinPong;
		private var pf2:PongForTwo;
		private var pnm:PongInTheMiddle;
		private var pp:PrisonerPong;
		private var qte:QTEPong;
		private var sp:SchizoPong;
		private var srp:SeriousPong;
		private var shp:ShitPong;
		private var shrp:ShrinkPong;
		private var smp:SiamesePong;
		private var snp:SnakePong;
		private var swp:SwapPong;
		private var tmp:TeamPong;
		private var tetp:TetrisPong;
		private var tkp:TrackAndPong;
		private var trp:TrophyPong;
		private var tbp:TurnBasedPong;
		private var tdp:TwoDPong;
		private var ufp:UnfairPong;
		private var vp:ViennesePong;
		private var watp:WithATracePong;

		private var _modeClasses:Array = new Array(
			"TwoDPong",
			"BallPong",
			"BlindPong",
			"BreakdownPong",
			"BreakoutPong",
			"ButtonPong",
			"CountdownPong",
			"EduPong",
			"FertilityPong",
			"EpilepsyPong", // FLASH
			"GhostPong",
			"SchizoPong", // IDENTITY
			"InversePong",
			"GunPong",
			"MemoriesOfPong",
			"NoWallsPong",
			"PerlinPong",
			"PongForTwo",
			"PongInTheMiddle",
			"MetaPong", // PONG
			"ShitPong", // POOP
			"PrisonerPong",
			"QTEPong",
			"SeriousPong",
			"ShrinkPong",
			"SiamesePong",
			"SnakePong",
			"SwapPong",
			"TeamPong",
			"TetrisPong",
			"TrackAndPong",
			"TrophyPong",
			"TurnBasedPong",
			"UnfairPong",
			"ViennesePong",
			"WithATracePong"
			);

		private var _letters:Array = new Array(
			"(A)", "(B)", "(C)", "(D)", "(E)", "(F)", "(G)", "(H)", "(I)",
			"(J)", "(K)", "(L)", "(M)", "(N)", "(O)", "(P)", "(Q)", "(R)", "(S)",
			"(T)", "(U)", "(V)", "(W)", "(X)", "(Y)", "(Z)",
			"(0)", "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)");

		private var _keys:Array = new Array(
			Keyboard.A, Keyboard.B, Keyboard.C, Keyboard.D, Keyboard.E, Keyboard.F,
			Keyboard.G, Keyboard.H, Keyboard.I, Keyboard.J, Keyboard.K, Keyboard.L,
			Keyboard.M, Keyboard.N, Keyboard.O, Keyboard.P, Keyboard.Q, Keyboard.R,
			Keyboard.S, Keyboard.T, Keyboard.U, Keyboard.V, Keyboard.W, Keyboard.X,
			Keyboard.Y, Keyboard.Z,
			Keyboard.NUMBER_0, Keyboard.NUMBER_1, Keyboard.NUMBER_2, Keyboard.NUMBER_3,
			Keyboard.NUMBER_4, Keyboard.NUMBER_5, Keyboard.NUMBER_6, Keyboard.NUMBER_7,
			Keyboard.NUMBER_8, Keyboard.NUMBER_9);

		private var _menuColumnOne:FlxText;
		private var _menuColumnTwo:FlxText;

		private var _title:FlxText;


		public function MenuState()
		{
			super();
		}


		public override function create():void
		{
			super.create();

			FlxG.bgColor = 0xFF112233;

			_title = new FlxText(0,20,FlxG.width,"PONGS",true);
			_title.setFormat("Commodore",100,0xFFFFFF,"center");

			_menuColumnOne = new FlxText(80,170,FlxG.width/2,"",true);
			_menuColumnOne.setFormat("Commodore", 14, 0xFFFFFF, "left");

			for (var i:int = 0; i < _modeClasses.length/2; i++)
			{
				var newClass:Class = getDefinitionByName(_modeClasses[i]) as Class;
				_menuColumnOne.text += _letters[i] + " " + newClass.menuName + "\n";
			}

			_menuColumnTwo = new FlxText(FlxG.width/2 + 35,170,FlxG.width/2,"",true);
			_menuColumnTwo.setFormat("Commodore", 14, 0xFFFFFF, "left");

			for (i; i < _modeClasses.length; i++)
			{
				newClass = getDefinitionByName(_modeClasses[i]) as Class;
				_menuColumnTwo.text += _letters[i] + " " + newClass.menuName + "\n";
			}

			add(_title);
			add(_menuColumnOne);
			add(_menuColumnTwo);

			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}


		public override function update():void
		{
			super.update();
		}


		private function onKeyDown(e:KeyboardEvent):void
		{
			var index:int = _keys.indexOf(e.keyCode);
			if (index != -1)
			{
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

				var playClass:Class = getDefinitionByName(_modeClasses[index]) as Class;
				FlxG.switchState(new playClass);
			}
		}

		public override function destroy():void
		{
			super.destroy();

			_title.destroy();
			_menuColumnOne.destroy();
			_menuColumnTwo.destroy();
		}
	}
}
