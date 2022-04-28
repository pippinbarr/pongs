class PongPong extends Pong {
  constructor() {
    super({
      key: `PONG PONG`
    });
  }

  create() {
    this.cabinet = this.add.image(this.width / 2, this.height / 2, `pong-cabinet`);
    this.leftDial = this.add.image(211 + 9.5, 385 + 9, `dial`);
    this.rightDial = this.add.image(404 + 8, 385 + 8, `dial2`);

    this.screen = this.add.graphics();
    this.screen.fillStyle(0x39443D);
    this.screen.fillRect(0, 0, 132, 96);
    this.screen.x = 252;
    this.screen.y = 162;
    this.screen.width = 132;
    this.screen.height = 96;

    super.create();

    this.instructionsText.text = "" +
      "DEPOSIT QUARTER\n" +
      "BALL WILL SERVE AUTOMATICALLY\n" +
      "AVOID MISSING BALL FOR HIGH SCORE\n\n" +
      "PLAYER 1: [W] / [S] TO TURN DIAL\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO TURN DIAL\n\n" +
      "[SPACE] TO INSERT QUARTER\n[ESCAPE] TO QUIT";

    this.leftScoreText.destroy();
    this.rightScoreText.destroy();

    this.leftScoreText = this.add.text();
    this.leftScoreText = this.add.text(this.screen.x + this.screen.width / 2 - 20, this.screen.y, this.leftScore, {
        font: "12px Commodore",
        color: "#fff",
        align: "right",
      })
      .setOrigin(0, 0)
      .setVisible(false)

    this.rightScoreText = this.add.text(this.screen.x + this.screen.width / 2 + 20, this.screen.y, this.rightScore, {
        font: "12px Commodore",
        color: "#fff",
        align: "left",
      })
      .setOrigin(1, 0)
      .setVisible(false)

    this.scoreInfo.add(this.leftScoreText);
    this.scoreInfo.add(this.rightScoreText);

    this.winnerInfo.setDepth(100);

    this.paddleSpeed = 50;
    this.ballSpeed = 50;
  }

  resetBall(ball) {
    ball.body.position.x = this.screen.x + this.screen.width / 2 - ball.body.width / 2;
    ball.body.position.y = this.screen.y + this.screen.height / 2 - ball.body.height / 2;

    ball.setVelocity(0, 0);
    ball.setAcceleration(0, 0);
  }

  resetPaddles() {
    this.leftPaddle.setVelocity(0, 0);
    this.leftPaddle.setPosition(this.screen.x + 2, this.screen.y + this.screen.height / 2);

    this.rightPaddle.setVelocity(0, 0);
    this.rightPaddle.setPosition(this.screen.x + this.screen.width - 2, this.screen.y + this.screen.height / 2);
  }

  handleSpecificPaddleInput(paddle, up, down) {
    paddle.setVelocity(0, 0);

    if (up.isDown && paddle.y > paddle.body.height / 2) {
      paddle.setVelocityY(-PADDLE_SPEED);
      if (paddle.x < this.width / 2) {
        this.leftDial.angle -= 1;
      } else {
        this.rightDial.angle -= 1;
      }
    } else if (down.isDown && paddle.y < this.height - paddle.body.height / 2) {
      paddle.setVelocityY(PADDLE_SPEED);
      if (paddle.x < this.width / 2) {
        this.leftDial.angle += 1;
      } else {
        this.rightDial.angle += 1;
      }
    }
    if (paddle.y < this.screen.y + paddle.body.height / 2) paddle.y = this.screen.y + paddle.body.height / 2;
    if (paddle.y > this.screen.y + this.screen.height - paddle.body.height / 2) paddle.y = this.screen.y + this.screen.height - paddle.body.height / 2;
  }

  checkBall(ball) {
    let point = false;

    // Check if the ball has gone off the screen
    if (ball.x + ball.width / 2 < this.screen.x) {
      this.rightScore++;
      this.lastPoint = Player.TWO;
      point = true;
    } else if (ball.x - ball.width / 2 > this.screen.x + this.screen.width) {
      this.leftScore++;
      this.lastPoint = Player.ONE;
      point = true;
    }

    this.setScores();

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    this.cabinet.setVisible(value);
    this.leftDial.setVisible(value);
    this.rightDial.setVisible(value);
    this.screen.setVisible(value);
  }

  createPaddles() {
    this.leftPaddle = this.createPhysicsRect(this.screen.x + 2, this.screen.y + this.screen.height / 2, 3, 9)
      .setBounce(1)
      .setMaxVelocity(50)
    this.rightPaddle = this.createPhysicsRect(this.screen.x + this.screen.width - 2, this.screen.y + this.screen.height / 2, 3, 9)
      .setBounce(1)
      .setMaxVelocity(50)
  }

  createBall() {
    this.ball = this.createPhysicsRect(
        this.screen.x + this.screen.width / 2, this.screen.y + this.screen.height / 2,
        3, 3, false)
      .setBounce(1)
      .setMaxVelocity(50)
  }

  createDivider() {
    this.divider = this.physics.add.group();
    for (let i = 0; i < 16; i++) {
      let block = this.createPhysicsRect(this.screen.x + this.screen.width / 2, this.screen.y + i * 6 + 2, 1, 3)
        .setBounce(1);
      this.divider.add(block);
      block.setImmovable(true);
    }
  }

  createWalls() {
    this.walls = this.physics.add.group();

    this.topWall = this.createPhysicsRect(this.screen.x + this.screen.width / 2, this.screen.y - 5, this.screen.width, 10);
    this.walls.add(this.topWall);

    this.bottomWall = this.createPhysicsRect(this.screen.x + this.screen.width / 2, this.screen.y + this.screen.height + 5, this.screen.width, 10);
    this.walls.add(this.bottomWall);

    // Have to reset immovable when added to group!
    this.topWall
      .setImmovable(true)
      .setVisible(false)
    this.bottomWall
      .setImmovable(true)
      .setVisible(false)
  }
}