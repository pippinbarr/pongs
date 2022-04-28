class ButtonPong extends Pong {
  constructor() {
    super({
      key: `B.U.T.T.O.N. PONG`
    });
  }

  create() {
    super.create();

    this.buttonStrings = [
      "HOLD YOUR BREATH FOR THE DURATION OF THIS POINT",
      "PLAY THIS POINT WITH YOUR EYES CLOSED",
      "INTERFERE WITH YOUR OPPONENT TO WIN THIS POINT",
      "LOSE THIS POINT ON PURPOSE",
      "PLAY THIS POINT WITH YOUR NON-DOMINANT HAND",
      "PLAY THIS POINT FACING AWAY AND LOOKING BACK OVER YOUR SHOULDER",
      "BLINK RAPIDLY THROUGHOUT THIS POINT",
      "LOUDLY COUNT BACKWARDS FROM 100 DURING THIS POINT",
      "PLAY THIS POINT WITH YOUR NOSE TOUCHING THE SCREEN",
      "PLAY THIS POINT USING YOUR NOSE",
      "CHANT \"LOSE! LOSE! LOSE!\" WHILE PLAYING THIS POINT",
      "HAVE A CONVERSATION ABOUT YOUR WORST JOB DURING THIS POINT",
      "PLAY THIS POINT STANDING UP",
      "PLAY THIS POINT SITTING ON THE GROUND",
      "PLAY THIS POINT USING YOUR FEET",
      "PLAY THIS POINT TRYING TO COVER YOUR OPPONENT'S EYES",
      "PLAY THIS POINT CONTROLLING THE OTHER PADDLE",
      "PLAY THIS POINT WHILE DOING AN IMPRESSION OF MICHAEL CAINE",
      "PLAY THIS POINT WHILE DOING AN IMPRESSION OF AL PACINO",
      "PLAY THIS POINT LIKE BILLY MITCHELL WOULD PLAY THIS POINT",
      "PLAY THIS POINT LIKE CHUCK NORRIS",
      "PLAY THIS POINT LIKE JESUS",
      "LOUDLY SING THE \"I LIKE TO MOVE IT MOVE IT\" SONG DURING THIS POINT",
      "PLAY THIS POINT LIKE KEYBOARD CAT",
      "PLAY THIS POINT IN SLOW MOTION",
      "DON'T PLAY THIS POINT",
      "DECLARE YOURSELF THE WINNER AFTER THIS POINT",
      "TAKE FIVE STEPS BACK FROM THE COMPUTER AND THEN PLAY THIS POINT",
      "PLAY THIS POINT SCREAMING LIKE ONE OF THOSE LOUD TENNIS PLAYERS",
      "FAKE A HEART ATTACK OR STROKE DURING THIS POINT",
      "SPELL 'ANTIDISESTABLISHMENTARIANISM' OUT LOUD DURING THIS POINT",
      "WIN THIS POINT",
      "TAKE THIS POINT FAR TOO SERIOUSLY",
      "KEEP ASKING YOUR OPPONENT WHAT THE TIME IS DURING THIS POINT",
      "IMAGINE YOU ARE ON A WHITE, SANDY BEACH DURING THIS POINT",
      "SLAP YOURSELF IN THE FACE EVERY TIME THE BALL BOUNCES DURING THIS POINT",
      "COMPOSE A HAIKU ABOUT THIS POINT DURING THIS POINT",
      "ACCEPT THAT FREE WILL IS AN ILLUSION DURING THIS POINT",
      "THINK ABOUT ALL THE OTHER STUFF YOU SHOULD REALLY BEING DOING DURING THIS POINT",
      "ARGUE ABOUT POLITICS DURING THIS POINT",
      "PLAY THIS POINT LIKE NO ONE'S WATCHING",
      "COMPLIMENT YOUR OPPONENT'S APPEARANCE DURING THIS POINT",
      "DISTRACT YOUR OPPONENT DURING THIS POINT",
      "TELL A JOKE DURING THIS POINT",
      "PLAY THIS POINT LOOKING AWAY AND USING YOUR PERIPHERAL VISION",
      "PLAY THIS POINT AS IF YOUR LIFE DEPENDED ON IT",
      "PLAY THIS POINT WHILE DISCUSSING THE TROLLEY PROBLEM",
      "PLAY THIS POINT WHILE MOVING YOUR HEAD LIKE THE CROWD AT A TENNIS MATCH",
      "SHOUT \"BOOM-SHAKALAKA!\" EACH TIME YOU HIT THE BALL IN THIS POINT"
    ];

    this.buttonTimer = undefined;

    this.instructionsText.text += "\n\n(AND, OF COURSE, BRUTALLY UNFAIR TACTICS ARE TOTALLY OKAY NOW.)";
  }

  resetPlay() {
    super.resetPlay();
    clearTimeout(this.timer);
    this.state = State.NONE;

    this.timer = setTimeout(() => {
      this.displayButtonRule();
    }, 1000);
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.timer);
  }

  displayButtonRule() {
    this.deactivate();
    this.setPlayVisible(false);
    this.instructionsText.text = this.buttonStrings[Math.floor(Math.random() * this.buttonStrings.length)];
    this.instructionsText.setVisible(true);
    this.timer = setTimeout(() => {
      this.setPlayVisible(true);
      this.leftPaddle.setVelocity(0, 0);
      this.rightPaddle.setVelocity(0, 0);
      this.instructionsText.setVisible(false);
      this.state = State.PLAYING;
      this.lastHit = Player.NONE;
      this.activate();
      this.resetBall(this.ball);
      this.timer = setTimeout(() => {
        this.launchBall();
      }, BALL_LAUNCH_DELAY);
    }, 3000);
  }
}