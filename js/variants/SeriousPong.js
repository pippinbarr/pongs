class SeriousPong extends Pong {
  constructor() {
    super({
      key: `SERIOUS PONG`
    });
  }

  create() {
    super.create();

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "AVOID MISSING REFUGEE FOR HIGH SCORE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.leftPaddle = this.physics.add.sprite(0, this.height / 2, `flag1`)
      .setBounce(1)
      .setImmovable(true)
      .setDepth(-10)
      .setVisible(false);
    this.leftPaddle.x = this.leftPaddle.body.width / 2;

    this.rightPaddle = this.physics.add.sprite(0, this.height / 2, `flag2`)
      .setBounce(1)
      .setImmovable(true)
      .setDepth(-10)
      .setVisible(false)
    this.rightPaddle.x = this.width - this.rightPaddle.body.width / 2;

    this.ball = this.physics.add.sprite(this.width / 2, this.height / 2, `refugee`, false)
      .setBounce(1)
      .setMaxVelocity(350, 350)
      .setDepth(-10)
      .setVisible(false)
  }

  update() {
    if (this.state === State.NONE) {
      this.handlePaddleInput();

      // aka LAUNCHING
      if (this.launchLeft) {
        this.ball.x = this.leftPaddle.x + this.leftPaddle.body.width / 2 + this.ball.body.width / 2;
        this.ball.y = this.leftPaddle.y;
      } else {
        this.ball.x = this.rightPaddle.x - this.rightPaddle.body.width / 2 - this.ball.body.width / 2;
        this.ball.y = this.rightPaddle.y;
      }
    }

    super.update();
  }

  checkBall(ball) {
    let point = false;

    if (ball.x < 0 - ball.body.width) {
      this.leftScore++;
      this.lastPoint = Player.ONE;
      point = true;
    } else if (ball.x > this.width + ball.body.width) {
      this.rightScore++;
      this.lastPoint = Player.TWO;
      point = true;
    }

    this.setScores();

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  gameOver() {
    this.state = State.GAMEOVER;
    clearTimeout(this.timer);
    this.deactivate();

    if (this.leftScore > this.rightScore) {
      this.winnerInfo.setX(3 * this.width / 4);
    } else if (this.rightScore > this.leftScore) {
      this.winnerInfo.setX(this.width / 4);
    }

    this.setGameOverVisible(true);
    this.ball.setVisible(false);
  }

  resetPlay() {
    this.state = State.NONE; // Launching

    this.activate();

    if (this.launchLeft) {
      this.ball.x = this.leftPaddle.x + this.leftPaddle.body.width / 2 + this.ball.body.width / 2;
      this.ball.y = this.leftPaddle.y;
    } else {
      this.ball.x = this.rightPaddle.x - this.rightPaddle.body.width / 2 - this.ball.body.width / 2;
      this.ball.y = this.rightPaddle.y;
    }

    this.leftPaddle.setVelocity(0, 0);
    this.leftPaddle.setPosition(PADDLE_INSET, this.height / 2);
    this.rightPaddle.setVelocity(0, 0);
    this.rightPaddle.setPosition(this.width - PADDLE_INSET, this.height / 2);
    this.ball.setVelocity(0, 0);

    setTimeout(() => {
      this.launchBall();
    }, BALL_LAUNCH_DELAY);
  }

  launchBall() {
    this.state = State.PLAYING;

    let ballDirection = 0;
    if (this.launchLeft) {
      ballDirection = 0;
    } else {
      ballDirection = Math.PI;
    }

    let vx = Math.cos(ballDirection) * this.ballSpeed;
    let vy = Math.sin(ballDirection) * this.ballSpeed;

    this.ball.setVelocity(vx, vy);
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    if (value) {
      this.launchLeft = Math.random() < 0.5;

      if (this.launchLeft) {
        this.leftScoreLabel.text = `ILLEGAL\nRE-ENTRIES`;
        this.rightScoreLabel.text = `REFUGEES\nTAKEN IN`;
      } else {
        this.rightScoreLabel.text = `ILLEGAL\nRE-ENTRIES`;
        this.leftScoreLabel.text = `REFUGEES\nTAKEN IN`;
      }
    }
  }

}