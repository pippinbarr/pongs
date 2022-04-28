class EduPong extends Pong {
  constructor() {
    super({
      key: `EDUTAINMENT PONG`
    });
  }

  create() {
    super.create();

    this.setupData();

    this.answers = [];
    this.correctAnswer = undefined;

    let questionStyle = {
      font: "18px Commodore",
      color: "#fff",
      align: "left",
      wordWrap: {
        width: this.width - 128
      }
    };
    this.questionGroup = this.add.group();
    this.questionText = this.add.text(64, this.height / 2 - 32, ``, questionStyle)
    this.aText = this.add.text(64, this.height / 2 + 32, ``, questionStyle);
    this.bText = this.add.text(64, this.height / 2 + 64, ``, questionStyle);
    this.cText = this.add.text(64, this.height / 2 + 96, ``, questionStyle);
    this.dText = this.add.text(64, this.height / 2 + 128, ``, questionStyle);
    this.questionGroup.add(this.questionText)
    this.questionGroup.add(this.aText);
    this.questionGroup.add(this.bText);
    this.questionGroup.add(this.cText);
    this.questionGroup.add(this.dText);
    this.questionGroup.setVisible(false);

    this.QUESTION_RANDOM_TIME = 5000;
    this.QUESTION_MINIMUM_TIME = 2000;

    this.questionee = Math.random() < 0.5 ? Player.ONE : Player.TWO;

    this.questionTimer = undefined;

    this.substate = `none`;

    // Add int he two missing keys for answering questions
    this.keys.a = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.A);
    this.keys.b = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.B);
    this.keys.c = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.C);
    this.keys.d = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.D);

    this.correctSFX = this.sound.add(`correct`);
    this.incorrectSFX = this.sound.add(`incorrect`);
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.questionTimer);
  }

  launchBall() {
    super.launchBall();
    this.startQuestionTimer();
  }

  startQuestionTimer() {
    this.questionTimer = setTimeout(() => {
      this.askQuestion();
    }, Math.random() * this.QUESTION_RANDOM_TIME + this.QUESTION_MINIMUM_TIME);
  }

  resetPlay() {
    clearTimeout(this.questionTimer);
    this.substate = `none`;

    super.resetPlay();
  }

  gameOver() {
    clearTimeout(this.questionTimer);

    super.gameOver();
  }

  askQuestion() {
    this.data.sort((a, b) => Math.random() < 0.5 ? -1 : 1);
    let answers = this.data.slice(0, 4);

    this.correctIndex = Math.floor(Math.random() * answers.length);
    this.correctAnswer = answers[this.correctIndex];

    let question = `${this.questionee === Player.ONE ? "PLAYER ONE" : "PLAYER TWO"}, WHAT IS THE CAPITAL OF ${this.correctAnswer.country.toUpperCase()}?`;
    this.questionText.text = question;

    this.questionGroup.getChildren()
      .forEach(child => {
        child.setColor(`#ffffff`);
      });

    this.aText.text = `(A) ${answers[0].capital.toUpperCase()}`;
    this.bText.text = `(B) ${answers[1].capital.toUpperCase()}`;
    this.cText.text = `(C) ${answers[2].capital.toUpperCase()}`;
    this.dText.text = `(D) ${answers[3].capital.toUpperCase()}`;

    this.state = State.NONE;
    this.substate = `question`;

    this.deactivate();

    this.showQuestion();
  }

  handleInput() {
    super.handleInput();

    if (this.substate === `question`) {
      this.handleQuestionInput();
    }
  }

  handleQuestionInput() {
    // Colour the user's answer red (our first assumption, which we'll
    // override below if needed)
    let answerIndex = -1;

    if (this.keys.a.isDown || this.keys.b.isDown || this.keys.c.isDown || this.keys.d.isDown) {

      if (this.keys.a.isDown) {
        this.aText.setColor(`#ff0000`);
        answerIndex = 0;
      } else if (this.keys.b.isDown) {
        this.bText.setColor(`#ff0000`);
        answerIndex = 1;
      } else if (this.keys.c.isDown) {
        this.cText.setColor(`#ff0000`);
        answerIndex = 2;
      } else if (this.keys.d.isDown) {
        this.dText.setColor(`#ff0000`);
        answerIndex = 3;
      }

      // Colour the correct answer green
      if (this.aText.text.includes(this.correctAnswer.capital.toUpperCase())) {
        this.aText.setColor(`#00ff00`);
      } else if (this.bText.text.includes(this.correctAnswer.capital.toUpperCase())) {
        this.bText.setColor(`#00ff00`);
      } else if (this.cText.text.includes(this.correctAnswer.capital.toUpperCase())) {
        this.cText.setColor(`#00ff00`);
      } else if (this.dText.text.includes(this.correctAnswer.capital.toUpperCase())) {
        this.dText.setColor(`#00ff00`);
      }

      if (answerIndex === this.correctIndex) {
        this.correctSFX.play();
        if (this.questionee === Player.ONE) {
          this.leftScore += 2;
          this.setScores();
        } else if (this.questionee === Player.TWO) {
          this.rightScore += 2;
          this.setScores();
        }
      } else {
        this.incorrectSFX.play();
      }

      if (answerIndex >= 0) {
        this.questionee = this.questionee === Player.ONE ? Player.TWO : Player.ONE;
        this.substate = `post question`;
        this.questionTimer = setTimeout(() => {
          this.postQuestion();
        }, 3000);

        this.correctIndex = -1;
      }

    }
  }

  postQuestion() {
    this.hideQuestion();
    this.activate();

    this.startQuestionTimer();
    this.state = State.PLAYING;
    this.substate = `none`;

    console.log("end postQuestion()");
  }

  showQuestion() {
    this.questionGroup.setVisible(true);

    this.divider.setVisible(false);
    this.leftPaddle.setVisible(false);
    this.rightPaddle.setVisible(false);
    this.scoreInfo.setVisible(false);
    this.ball.setVisible(false);
  }

  hideQuestion() {
    this.questionGroup.setVisible(false);

    this.divider.setVisible(true);
    this.leftPaddle.setVisible(true);
    this.rightPaddle.setVisible(true);
    this.scoreInfo.setVisible(true);
    this.ball.setVisible(true);
  }

  setupData() {
    this.data = [{
        country: "Afghanistan",
        capital: "Kabul"
      },
      {
        country: "Albania",
        capital: "Tirane"
      },
      {
        country: "Algeria",
        capital: "Algiers"
      },
      {
        country: "Andorra",
        capital: "Andorra la Vella"
      },
      {
        country: "Angola",
        capital: "Luanda"
      },
      {
        country: "Antigua and Barbuda",
        capital: "Saint John\'s"
      },
      {
        country: "Argentina",
        capital: "Buenos Aires"
      },
      {
        country: "Armenia",
        capital: "Yerevan"
      },
      {
        country: "Australia",
        capital: "Canberra"
      },
      {
        country: "Austria",
        capital: "Vienna"
      },
      {
        country: "Azerbaijan",
        capital: "Baku"
      },
      {
        country: "The Bahamas",
        capital: "Nassau"
      },
      {
        country: "Bahrain",
        capital: "Manama"
      },
      {
        country: "Bangladesh",
        capital: "Dhaka"
      },
      {
        country: "Barbados",
        capital: "Bridgetown"
      },
      {
        country: "Belarus",
        capital: "Minsk"
      },
      {
        country: "Belgium",
        capital: "Brussels"
      },
      {
        country: "Belize",
        capital: "Belmopan"
      },
      {
        country: "Benin",
        capital: "Porto-Novo"
      },
      {
        country: "Bhutan",
        capital: "Thimphu"
      },
      {
        country: "Bolivia",
        capital: "La Paz"
      },
      {
        country: "Bosnia and Herzegovina",
        capital: "Sarajevo"
      },
      {
        country: "Botswana",
        capital: "Gaborone"
      },
      {
        country: "Brazil",
        capital: "Brasilia"
      },
      {
        country: "Brunei",
        capital: "Bandar Seri Begawan"
      },
      {
        country: "Bulgaria",
        capital: "Sofia"
      },
      {
        country: "Burkina Faso",
        capital: "Ouagadougou"
      },
      {
        country: "Burundi",
        capital: "Bujumbura"
      },
      {
        country: "Cambodia",
        capital: "Phnom Penh"
      },
      {
        country: "Cameroon",
        capital: "Yaounde"
      },
      {
        country: "Canada",
        capital: "Ottawa"
      },
      {
        country: "Cape Verde",
        capital: "Praia"
      },
      {
        country: "Central African Republic",
        capital: "Bangui"
      },
      {
        country: "Chad",
        capital: "N\'Djamena"
      },
      {
        country: "Chile",
        capital: "Santiago"
      },
      {
        country: "China",
        capital: "Beijing"
      },
      {
        country: "Colombia",
        capital: "Bogota"
      },
      {
        country: "Comoros",
        capital: "Moroni"
      },
      {
        country: "Republic of the Congo",
        capital: "Brazzaville"
      },
      {
        country: "Democratic Republic of the Congo",
        capital: "Kinshasa"
      },
      {
        country: "Costa Rica",
        capital: "San Jose"
      },
      {
        country: "Cote d\'Ivoire",
        capital: "Yamoussoukro"
      },
      {
        country: "Croatia",
        capital: "Zagreb"
      },
      {
        country: "Cuba",
        capital: "Havana"
      },
      {
        country: "Cyprus",
        capital: "Nicosia"
      },
      {
        country: "Czech Republic",
        capital: "Prague"
      },
      {
        country: "Denmark",
        capital: "Copenhagen"
      },
      {
        country: "Djibouti",
        capital: "Djibouti"
      },
      {
        country: "Dominica",
        capital: "Roseau"
      },
      {
        country: "Dominican Republic",
        capital: "Santo Domingo"
      },
      {
        country: "East Timor",
        capital: "Dili"
      },
      {
        country: "Ecuador",
        capital: "Quito"
      },
      {
        country: "Egypt",
        capital: "Cairo"
      },
      {
        country: "El Salvador",
        capital: "San Salvador"
      },
      {
        country: "Equatorial Guinea",
        capital: "Malabo"
      },
      {
        country: "Eritrea",
        capital: "Asmara"
      },
      {
        country: "Estonia",
        capital: "Tallinn"
      },
      {
        country: "Ethiopia",
        capital: "Addis Ababa"
      },
      {
        country: "Fiji",
        capital: "Suva"
      },
      {
        country: "Finland",
        capital: "Helsinki"
      },
      {
        country: "France",
        capital: "Paris"
      },
      {
        country: "Gabon",
        capital: "Libreville"
      },
      {
        country: "The Gambia",
        capital: "Banjul"
      },
      {
        country: "Georgia",
        capital: "Tbilisi"
      },
      {
        country: "Germany",
        capital: "Berlin"
      },
      {
        country: "Ghana",
        capital: "Accra"
      },
      {
        country: "Greece",
        capital: "Athens"
      },
      {
        country: "Grenada",
        capital: "Saint George\'s"
      },
      {
        country: "Guatemala",
        capital: "Guatemala City"
      },
      {
        country: "Guinea",
        capital: "Conakry"
      },
      {
        country: "Guinea-Bissau",
        capital: "Bissau"
      },
      {
        country: "Guyana",
        capital: "Georgetown"
      },
      {
        country: "Haiti",
        capital: "Port-au-Prince"
      },
      {
        country: "Honduras",
        capital: "Tegucigalpa"
      },
      {
        country: "Hungary",
        capital: "Budapest"
      },
      {
        country: "Iceland",
        capital: "Reykjavik"
      },
      {
        country: "India",
        capital: "New Delhi"
      },
      {
        country: "Indonesia",
        capital: "Jakarta"
      },
      {
        country: "Iran",
        capital: "Tehran"
      },
      {
        country: "Iraq",
        capital: "Baghdad"
      },
      {
        country: "Ireland",
        capital: "Dublin"
      },
      {
        country: "Israel",
        capital: "Jerusalem"
      },
      {
        country: "Italy",
        capital: "Rome"
      },
      {
        country: "Jamaica",
        capital: "Kingston"
      },
      {
        country: "Japan",
        capital: "Tokyo"
      },
      {
        country: "Jordan",
        capital: "Amman"
      },
      {
        country: "Kazakhstan",
        capital: "Astana"
      },
      {
        country: "Kenya",
        capital: "Nairobi"
      },
      {
        country: "Kiribati",
        capital: "Tarawa Atoll"
      },
      {
        country: "North Korea",
        capital: "Pyongyang"
      },
      {
        country: "South Korea",
        capital: "Seoul"
      },
      {
        country: "Kosovo",
        capital: "Pristina"
      },
      {
        country: "Kuwait",
        capital: "Kuwait City"
      },
      {
        country: "Kyrgyzstan",
        capital: "Bishkek"
      },
      {
        country: "Laos",
        capital: "Vientiane"
      },
      {
        country: "Latvia",
        capital: "Riga"
      },
      {
        country: "Lebanon",
        capital: "Beirut"
      },
      {
        country: "Lesotho",
        capital: "Maseru"
      },
      {
        country: "Liberia",
        capital: "Monrovia"
      },
      {
        country: "Libya",
        capital: "Tripoli"
      },
      {
        country: "Liechtenstein",
        capital: "Vaduz"
      },
      {
        country: "Lithuania",
        capital: "Vilnius"
      },
      {
        country: "Luxembourg",
        capital: "Luxembourg"
      },
      {
        country: "Macedonia",
        capital: "Skopje"
      },
      {
        country: "Madagascar",
        capital: "Antananarivo"
      },
      {
        country: "Malawi",
        capital: "Lilongwe"
      },
      {
        country: "Malaysia",
        capital: "Kuala Lumpur"
      },
      {
        country: "Maldives",
        capital: "Male"
      },
      {
        country: "Mali",
        capital: "Bamako"
      },
      {
        country: "Malta",
        capital: "Valletta"
      },
      {
        country: "Marshall Islands",
        capital: "Majuro"
      },
      {
        country: "Mauritania",
        capital: "Nouakchott"
      },
      {
        country: "Mauritius",
        capital: "Port Louis"
      },
      {
        country: "Mexico",
        capital: "Mexico City"
      },
      {
        country: "Federated States of Micronesia",
        capital: "Palikir"
      },
      {
        country: "Moldova",
        capital: "Chisinau"
      },
      {
        country: "Monaco",
        capital: "Monaco"
      },
      {
        country: "Mongolia",
        capital: "Ulaanbaatar"
      },
      {
        country: "Montenegro",
        capital: "Podgorica"
      },
      {
        country: "Morocco",
        capital: "Rabat"
      },
      {
        country: "Mozambique",
        capital: "Maputo"
      },
      {
        country: "Myanmar",
        capital: "Rangoon"
      },
      {
        country: "Namibia",
        capital: "Windhoek"
      },
      {
        country: "Nepal",
        capital: "Kathmandu"
      },
      {
        country: "Netherlands",
        capital: "Amsterdam"
      },
      {
        country: "New Zealand",
        capital: "Wellington"
      },
      {
        country: "Nicaragua",
        capital: "Managua"
      },
      {
        country: "Niger",
        capital: "Niamey"
      },
      {
        country: "Nigeria",
        capital: "Abuja"
      },
      {
        country: "Norway",
        capital: "Oslo"
      },
      {
        country: "Oman",
        capital: "Muscat"
      },
      {
        country: "Pakistan",
        capital: "Islamabad"
      },
      {
        country: "Palau",
        capital: "Melekeok"
      },
      {
        country: "Panama",
        capital: "Panama City"
      },
      {
        country: "Papua New Guinea",
        capital: "Port Moresby"
      },
      {
        country: "Paraguay",
        capital: "Asuncion"
      },
      {
        country: "Peru",
        capital: "Lima"
      },
      {
        country: "Philippines",
        capital: "Manila"
      },
      {
        country: "Poland",
        capital: "Warsaw"
      },
      {
        country: "Portugal",
        capital: "Lisbon"
      },
      {
        country: "Qatar",
        capital: "Doha"
      },
      {
        country: "Romania",
        capital: "Bucharest"
      },
      {
        country: "Russia",
        capital: "Moscow"
      },
      {
        country: "Rwanda",
        capital: "Kigali"
      },
      {
        country: "Saint Kitts and Nevis",
        capital: "Basseterre"
      },
      {
        country: "Saint Lucia",
        capital: "Castries"
      },
      {
        country: "Saint Vincent and the Grenadines",
        capital: "Kingstown"
      },
      {
        country: "Samoa",
        capital: "Apia"
      },
      {
        country: "San Marino",
        capital: "San Marino"
      },
      {
        country: "Sao Tome and Principe",
        capital: "Sao Tome"
      },
      {
        country: "Saudi Arabia",
        capital: "Riyadh"
      },
      {
        country: "Senegal",
        capital: "Dakar"
      },
      {
        country: "Serbia",
        capital: "Belgrade"
      },
      {
        country: "Seychelles",
        capital: "Victoria"
      },
      {
        country: "Sierra Leone",
        capital: "Freetown"
      },
      {
        country: "Singapore",
        capital: "Singapore"
      },
      {
        country: "Slovakia",
        capital: "Bratislava"
      },
      {
        country: "Slovenia",
        capital: "Ljubljana"
      },
      {
        country: "Solomon Islands",
        capital: "Honiara"
      },
      {
        country: "Somalia",
        capital: "Mogadishu"
      },
      {
        country: "South Africa",
        capital: "Pretoria"
      },
      {
        country: "South Sudan",
        capital: "Juba"
      },
      {
        country: "Spain",
        capital: "Madrid"
      },
      {
        country: "Sri Lanka",
        capital: "Colombo"
      },
      {
        country: "Sudan",
        capital: "Khartoum"
      },
      {
        country: "Suriname",
        capital: "Paramaribo"
      },
      {
        country: "Swaziland",
        capital: "Mbabane"
      },
      {
        country: "Sweden",
        capital: "Stockholm"
      },
      {
        country: "Switzerland",
        capital: "Bern"
      },
      {
        country: "Syria",
        capital: "Damascus"
      },
      {
        country: "Taiwan",
        capital: "Taipei"
      },
      {
        country: "Tajikistan",
        capital: "Dushanbe"
      },
      {
        country: "Tanzania",
        capital: "Dar es Salaam"
      },
      {
        country: "Thailand",
        capital: "Bangkok"
      },
      {
        country: "Togo",
        capital: "Lome"
      },
      {
        country: "Tonga",
        capital: "Nuku\'alofa"
      },
      {
        country: "Trinidad and Tobago",
        capital: "Port of Spain"
      },
      {
        country: "Tunisia",
        capital: "Tunis"
      },
      {
        country: "Turkey",
        capital: "Ankara"
      },
      {
        country: "Turkmenistan",
        capital: "Ashgabat"
      },
      {
        country: "Tuvalu",
        capital: "Vaiaku"
      },
      {
        country: "Uganda",
        capital: "Kampala"
      },
      {
        country: "Ukraine",
        capital: "Kyiv"
      },
      {
        country: "United Arab Emirates",
        capital: "Abu Dhabi"
      },
      {
        country: "United Kingdom",
        capital: "London"
      },
      {
        country: "United States of America",
        capital: "Washington D.C."
      },
      {
        country: "Uruguay",
        capital: "Montevideo"
      },
      {
        country: "Uzbekistan",
        capital: "Tashkent"
      },
      {
        country: "Vanuatu",
        capital: "Port-Vila"
      },
      {
        country: "Vatican City",
        capital: "Vatican City"
      },
      {
        country: "Venezuela",
        capital: "Caracas"
      },
      {
        country: "Vietnam",
        capital: "Hanoi"
      },
      {
        country: "Yemen",
        capital: "Sanaa"
      },
      {
        country: "Zambia",
        capital: "Lusaka"
      },
      {
        country: "Zimbabwe",
        capital: "Harare"
      }
    ];
  }
}