package
{
	import org.flixel.*;

	public class EduPong extends StandardPong
	{
		public static const menuName:String = "EDUTAINMENT PONG";

		[Embed(source="/assets/sounds/correct.mp3")]
		public static const CORRECT_SOUND:Class;

		[Embed(source="/assets/sounds/incorrect.mp3")]
		public static const INCORRECT_SOUND:Class;



		private const QUESTION:uint = 4;
		private const POST_QUESTION:uint = 5;

		private const COUNTRY_NAME:uint = 0;
		private const CAPITAL_NAME:uint = 1;

		private const _capitals:Array = new Array(
			new Array("Afghanistan","Kabul"),
			new Array("Albania","Tirane"),
			new Array("Algeria","Algiers"),
			new Array("Andorra","Andorra la Vella"),
			new Array("Angola","Luanda"),
			new Array("Antigua and Barbuda","Saint John\'s"),
			new Array("Argentina","Buenos Aires"),
			new Array("Armenia","Yerevan"),
			new Array("Australia","Canberra"),
			new Array("Austria","Vienna"),
			new Array("Azerbaijan","Baku"),
			new Array("The Bahamas","Nassau"),
			new Array("Bahrain","Manama"),
			new Array("Bangladesh","Dhaka"),
			new Array("Barbados","Bridgetown"),
			new Array("Belarus","Minsk"),
			new Array("Belgium","Brussels"),
			new Array("Belize","Belmopan"),
			new Array("Benin","Porto-Novo"),
			new Array("Bhutan","Thimphu"),
			new Array("Bolivia","La Paz"),
			new Array("Bosnia and Herzegovina","Sarajevo"),
			new Array("Botswana","Gaborone"),
			new Array("Brazil","Brasilia"),
			new Array("Brunei","Bandar Seri Begawan"),
			new Array("Bulgaria","Sofia"),
			new Array("Burkina Faso","Ouagadougou"),
			new Array("Burundi","Bujumbura"),
			new Array("Cambodia","Phnom Penh"),
			new Array("Cameroon","Yaounde"),
			new Array("Canada","Ottawa"),
			new Array("Cape Verde","Praia"),
			new Array("Central African Republic","Bangui"),
			new Array("Chad","N\'Djamena"),
			new Array("Chile","Santiago"),
			new Array("China","Beijing"),
			new Array("Colombia","Bogota"),
			new Array("Comoros","Moroni"),
			new Array("Republic of the Congo","Brazzaville"),
			new Array("Democratic Republic of the Congo","Kinshasa"),
			new Array("Costa Rica","San Jose"),
			new Array("Cote d\'Ivoire","Yamoussoukro"),
			new Array("Croatia","Zagreb"),
			new Array("Cuba","Havana"),
			new Array("Cyprus","Nicosia"),
			new Array("Czech Republic","Prague"),
			new Array("Denmark","Copenhagen"),
			new Array("Djibouti","Djibouti"),
			new Array("Dominica","Roseau"),
			new Array("Dominican Republic","Santo Domingo"),
			new Array("East Timor","Dili"),
			new Array("Ecuador","Quito"),
			new Array("Egypt","Cairo"),
			new Array("El Salvador","San Salvador"),
			new Array("Equatorial Guinea","Malabo"),
			new Array("Eritrea","Asmara"),
			new Array("Estonia","Tallinn"),
			new Array("Ethiopia","Addis Ababa"),
			new Array("Fiji","Suva"),
			new Array("Finland","Helsinki"),
			new Array("France","Paris"),
			new Array("Gabon","Libreville"),
			new Array("The Gambia","Banjul"),
			new Array("Georgia","Tbilisi"),
			new Array("Germany","Berlin"),
			new Array("Ghana","Accra"),
			new Array("Greece","Athens"),
			new Array("Grenada","Saint George\'s"),
			new Array("Guatemala","Guatemala City"),
			new Array("Guinea","Conakry"),
			new Array("Guinea-Bissau","Bissau"),
			new Array("Guyana","Georgetown"),
			new Array("Haiti","Port-au-Prince"),
			new Array("Honduras","Tegucigalpa"),
			new Array("Hungary","Budapest"),
			new Array("Iceland","Reykjavik"),
			new Array("India","New Delhi"),
			new Array("Indonesia","Jakarta"),
			new Array("Iran","Tehran"),
			new Array("Iraq","Baghdad"),
			new Array("Ireland","Dublin"),
			new Array("Israel","Jerusalem"),
			new Array("Italy","Rome"),
			new Array("Jamaica","Kingston"),
			new Array("Japan","Tokyo"),
			new Array("Jordan","Amman"),
			new Array("Kazakhstan","Astana"),
			new Array("Kenya","Nairobi"),
			new Array("Kiribati","Tarawa Atoll"),
			new Array("North Korea","Pyongyang"),
			new Array("South Korea","Seoul"),
			new Array("Kosovo","Pristina"),
			new Array("Kuwait","Kuwait City"),
			new Array("Kyrgyzstan","Bishkek"),
			new Array("Laos","Vientiane"),
			new Array("Latvia","Riga"),
			new Array("Lebanon","Beirut"),
			new Array("Lesotho","Maseru"),
			new Array("Liberia","Monrovia"),
			new Array("Libya","Tripoli"),
			new Array("Liechtenstein","Vaduz"),
			new Array("Lithuania","Vilnius"),
			new Array("Luxembourg","Luxembourg"),
			new Array("Macedonia","Skopje"),
			new Array("Madagascar","Antananarivo"),
			new Array("Malawi","Lilongwe"),
			new Array("Malaysia","Kuala Lumpur"),
			new Array("Maldives","Male"),
			new Array("Mali","Bamako"),
			new Array("Malta","Valletta"),
			new Array("Marshall Islands","Majuro"),
			new Array("Mauritania","Nouakchott"),
			new Array("Mauritius","Port Louis"),
			new Array("Mexico","Mexico City"),
			new Array("Federated States of Micronesia","Palikir"),
			new Array("Moldova","Chisinau"),
			new Array("Monaco","Monaco"),
			new Array("Mongolia","Ulaanbaatar"),
			new Array("Montenegro","Podgorica"),
			new Array("Morocco","Rabat"),
			new Array("Mozambique","Maputo"),
			new Array("Myanmar","Rangoon"),
			new Array("Namibia","Windhoek"),
			new Array("Nepal","Kathmandu"),
			new Array("Netherlands","Amsterdam"),
			new Array("New Zealand","Wellington"),
			new Array("Nicaragua","Managua"),
			new Array("Niger","Niamey"),
			new Array("Nigeria","Abuja"),
			new Array("Norway","Oslo"),
			new Array("Oman","Muscat"),
			new Array("Pakistan","Islamabad"),
			new Array("Palau","Melekeok"),
			new Array("Panama","Panama City"),
			new Array("Papua New Guinea","Port Moresby"),
			new Array("Paraguay","Asuncion"),
			new Array("Peru","Lima"),
			new Array("Philippines","Manila"),
			new Array("Poland","Warsaw"),
			new Array("Portugal","Lisbon"),
			new Array("Qatar","Doha"),
			new Array("Romania","Bucharest"),
			new Array("Russia","Moscow"),
			new Array("Rwanda","Kigali"),
			new Array("Saint Kitts and Nevis","Basseterre"),
			new Array("Saint Lucia","Castries"),
			new Array("Saint Vincent and the Grenadines","Kingstown"),
			new Array("Samoa","Apia"),
			new Array("San Marino","San Marino"),
			new Array("Sao Tome and Principe","Sao Tome"),
			new Array("Saudi Arabia","Riyadh"),
			new Array("Senegal","Dakar"),
			new Array("Serbia","Belgrade"),
			new Array("Seychelles","Victoria"),
			new Array("Sierra Leone","Freetown"),
			new Array("Singapore","Singapore"),
			new Array("Slovakia","Bratislava"),
			new Array("Slovenia","Ljubljana"),
			new Array("Solomon Islands","Honiara"),
			new Array("Somalia","Mogadishu"),
			new Array("South Africa","Pretoria"),
			new Array("South Sudan","Juba"),
			new Array("Spain","Madrid"),
			new Array("Sri Lanka","Colombo"),
			new Array("Sudan","Khartoum"),
			new Array("Suriname","Paramaribo"),
			new Array("Swaziland","Mbabane"),
			new Array("Sweden","Stockholm"),
			new Array("Switzerland","Bern"),
			new Array("Syria","Damascus"),
			new Array("Taiwan","Taipei"),
			new Array("Tajikistan","Dushanbe"),
			new Array("Tanzania","Dar es Salaam"),
			new Array("Thailand","Bangkok"),
			new Array("Togo","Lome"),
			new Array("Tonga","Nuku\'alofa"),
			new Array("Trinidad and Tobago","Port of Spain"),
			new Array("Tunisia","Tunis"),
			new Array("Turkey","Ankara"),
			new Array("Turkmenistan","Ashgabat"),
			new Array("Tuvalu","Vaiaku"),
			new Array("Uganda","Kampala"),
			new Array("Ukraine","Kyiv"),
			new Array("United Arab Emirates","Abu Dhabi"),
			new Array("United Kingdom","London"),
			new Array("United States of America","Washington D.C."),
			new Array("Uruguay","Montevideo"),
			new Array("Uzbekistan","Tashkent"),
			new Array("Vanuatu","Port-Vila"),
			new Array("Vatican City","Vatican City"),
			new Array("Venezuela","Caracas"),
			new Array("Vietnam","Hanoi"),
			new Array("Yemen","Sanaa"),
			new Array("Zambia","Lusaka"),
			new Array("Zimbabwe","Harare"));

		private var _answers:Array = new Array();
		private var _correctIndex:uint;

		private var _questionText:FlxText;
		private var _aText:FlxText;
		private var _bText:FlxText;
		private var _cText:FlxText;
		private var _dText:FlxText;

		private const QUESTION_RANDOM_TIME:Number = 5;
		private const QUESTION_MINIMUM_TIME:Number = 2;

		private var _questionee:uint = Math.floor(Math.random() * 2)

		private var _questionTimer:FlxTimer = new FlxTimer();

		public function EduPong()
		{
		}


		public override function create():void
		{
			super.create();

			_titleText.text = menuName;

			_questionText = new FlxText(64,FlxG.height/2 - 32,FlxG.width - 128,"",true);
			_questionText.setFormat("Commodore",18,0xFFFFFF,"left");
			add(_questionText);
			_questionText.visible = false;
			_aText = new FlxText(64,FlxG.height/2 + 32,FlxG.width - 128,"",true);
			_aText.setFormat("Commodore",18,0xFFFFFF,"left");
			add(_aText);
			_aText.visible = false;
			_bText = new FlxText(64,FlxG.height/2 + 64,FlxG.width - 128,"",true);
			_bText.setFormat("Commodore",18,0xFFFFFF,"left");
			add(_bText);
			_bText.visible = false;
			_cText= new FlxText(64,FlxG.height/2 + 96,FlxG.width - 128,"",true);
			_cText.setFormat("Commodore",18,0xFFFFFF,"left");
			add(_cText);
			_cText.visible = false;
			_dText = new FlxText(64,FlxG.height/2 + 128,FlxG.width - 128,"",true);
			_dText.setFormat("Commodore",18,0xFFFFFF,"left");
			add(_dText);
			_dText.visible = false;
		}


		public override function update():void
		{
			super.update();
		}


		protected override function gameOver():void
		{
			super.gameOver();

			_questionTimer.stop();
		}


		protected override function resetPlay():void
		{
			super.resetPlay();

			_questionTimer.stop();
		}


		protected override function launchBall(t:FlxTimer):void
		{
			super.launchBall(null);

			_questionTimer.start(Math.random() * QUESTION_RANDOM_TIME + QUESTION_MINIMUM_TIME,1,askQuestion);
		}


		private function askQuestion(t:FlxTimer):void
		{
			_state = QUESTION;

			_leftPaddle.active = false;
			_rightPaddle.active = false;
			_ball.active = false;

			_leftPaddle.visible = false;
			_rightPaddle.visible = false;
			_ball.visible = false;
			_leftScoreText.visible = false;
			_rightScoreText.visible = false;
			_divider.visible = false;

			// Choose a "correct" answer
			_correctIndex = Math.floor(Math.random() * 4);

			// Populate the question answers
			_answers = new Array();
			var correctCountry:String;
			while (_answers.length != 4)
			{
				var index:uint = Math.floor(Math.random() * _capitals.length);
				if (_answers.indexOf(_capitals[index][CAPITAL_NAME]) == -1)
				{
					_answers.push(_capitals[index][CAPITAL_NAME]);
					if (_answers.length == _correctIndex+1)
					{
						correctCountry = _capitals[index][COUNTRY_NAME].toUpperCase();
					}
				}
			}


			// Construct the question
			if (_questionee == PLAYER_1)
				_questionText.text = "PLAYER ONE, ";
			else
				_questionText.text = "PLAYER TWO, ";
			_questionText.text += "WHAT IS THE CAPITAL OF " + correctCountry + "?";

			// Fill out the answers
			_aText.text = "(A) " + _answers[0].toUpperCase();
			_bText.text = "(B) " + _answers[1].toUpperCase();
			_cText.text = "(C) " + _answers[2].toUpperCase();
			_dText.text = "(D) " + _answers[3].toUpperCase();

			_questionText.visible = true;

			_aText.visible = true;
			_bText.visible = true;
			_cText.visible = true;
			_dText.visible = true;
		}


		private function postQuestion(t:FlxTimer):void
		{
			_state = PLAYING;

			_leftPaddle.active = true;
			_rightPaddle.active = true;
			_ball.active = true;

			_leftScoreText.visible = true;
			_rightScoreText.visible = true;
			_leftPaddle.visible = true;
			_rightPaddle.visible = true;
			_divider.visible = true;
			_walls.visible = true;
			_ball.visible = true;

			_questionText.visible = false;
			_aText.visible = false;
			_bText.visible = false;
			_cText.visible = false;
			_dText.visible = false;

			_aText.color = 0xFFFFFF;
			_bText.color = 0xFFFFFF;
			_cText.color = 0xFFFFFF;
			_dText.color = 0xFFFFFF;

			_questionTimer.start(Math.random() * QUESTION_RANDOM_TIME + QUESTION_MINIMUM_TIME,1,askQuestion);
		}


		protected override function handleInput():void
		{
			super.handleInput();
			handleQuestionInput();
		}

		private function handleQuestionInput():void
		{
			if (_state == QUESTION &&
			    (FlxG.keys.A ||
				 FlxG.keys.B ||
				 FlxG.keys.C ||
				 FlxG.keys.D))
			{
				var answerIndex:int = -1;

				if (FlxG.keys.A)
				{
					answerIndex = 0;
					_aText.color = 0xFFFF0000;
				}
				else if (FlxG.keys.B)
				{
					answerIndex = 1;
					_bText.color = 0xFFFF0000;
				}
				else if (FlxG.keys.C)
				{
					answerIndex = 2;
					_cText.color = 0xFFFF0000;
				}
				else if (FlxG.keys.D)
				{
					answerIndex = 3;
					_dText.color = 0xFFFF0000;
				}


				switch (_correctIndex)
				{
					case 0:
						_aText.color = 0xFF00FF00;
						break;
					case 1:
						_bText.color = 0xFF00FF00;
						break;
					case 2:
						_cText.color = 0xFF00FF00;
						break;
					case 3:
						_dText.color = 0xFF00FF00;
						break;
				}

				if (answerIndex == _correctIndex)
				{
					FlxG.play(CORRECT_SOUND);

					if (_questionee == PLAYER_1)
					{
						_leftScore += 2;
						_leftScoreText.text = _leftScore.toString();
					}
					else
					{
						_rightScore += 2;
						_rightScoreText.text = _rightScore.toString();
					}
				}
				else
				{
					FlxG.play(INCORRECT_SOUND);
				}

				_questionee = (1 - _questionee);

				_state = POST_QUESTION;
				_questionTimer.start(3,1,postQuestion);

				return;
			}
		}


		public override function destroy():void
		{
			super.destroy();

			_questionText.destroy();
			_aText.destroy();
			_bText.destroy();
			_cText.destroy();
			_dText.destroy();

			_questionTimer.destroy();
		}
	}
}
