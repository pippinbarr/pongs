class InversePong extends Pong {
  constructor() {
    super({
      key: `INVERSE PONG`
    });
  }

  create() {
    // Need to define here too so that it's available for split paddle creation
    this.width = this.game.canvas.width;
    this.height = this.game.canvas.height;

    this.upperLeftPaddle = this.createPhysicsRect(PADDLE_INSET, 0, PADDLE_WIDTH, this.height - PADDLE_HEIGHT)
    this.lowerLeftPaddle = this.createPhysicsRect(PADDLE_INSET, this.height, PADDLE_WIDTH, this.height - PADDLE_HEIGHT)

    this.upperRightPaddle = this.createPhysicsRect(this.width - PADDLE_INSET, 0, PADDLE_WIDTH, this.height - PADDLE_HEIGHT)
    this.lowerRightPaddle = this.createPhysicsRect(this.width - PADDLE_INSET, this.height, PADDLE_WIDTH, this.height - PADDLE_HEIGHT)

    super.create();

    this.ballSpeed = 1000;
    this.ball.setMaxVelocity(this.ballSpeed, this.ballSpeed);

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "MISS BALL FOR HIGH SCORE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.leftPaddle.destroy();
    this.rightPaddle.destroy();
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit, null, this);
    this.physics.collide(this.upperLeftPaddle, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.lowerLeftPaddle, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.upperRightPaddle, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.lowerRightPaddle, this.ball, this.paddleHit, null, this);
  }

  checkBall(ball) {
    let point = false;
    if (ball.x + ball.body.width < 0) {
      this.leftScore++;
      point = true;
    } else if (ball.x - ball.body.width > this.width) {
      this.rightScore++;
      point = true;
    }
    this.setScores();

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  activate() {
    this.ball.setActive(true);
    this.upperLeftPaddle.setActive(true);
    this.lowerLeftPaddle.setActive(true);
    this.upperRightPaddle.setActive(true);
    this.lowerRightPaddle.setActive(true);
    this.physics.world.resume();
  }

  deactivate() {
    this.ball.setActive(false);
    this.upperLeftPaddle.setActive(false);
    this.lowerLeftPaddle.setActive(false);
    this.upperRightPaddle.setActive(false);
    this.lowerRightPaddle.setActive(false);
    this.physics.world.pause();
  }

  resetPlay() {
    clearTimeout(this.timer);

    this.activate();

    this.resetBall(this.ball);
    this.upperLeftPaddle.setVelocity(0, 0);
    this.upperRightPaddle.setVelocity(0, 0);
    this.lowerLeftPaddle.setVelocity(0, 0);
    this.lowerRightPaddle.setVelocity(0, 0);

    this.state = State.SERVING;
    this.lastHit = Player.NONE;

    this.timer = setTimeout(() => {
      this.launchBall();
    }, BALL_LAUNCH_DELAY);
  }

  handlePaddleInput() {
    this.handleSpecificPaddleInput(this.upperRightPaddle, this.lowerRightPaddle, this.keys.up, this.keys.down);
    this.handleSpecificPaddleInput(this.upperLeftPaddle, this.lowerLeftPaddle, this.keys.w, this.keys.s);
  }

  handleSpecificPaddleInput(upper, lower, up, down) {
    upper.setVelocity(0, 0);
    lower.setVelocity(0, 0);

    if (up.isDown && upper.y + upper.body.height / 2 > 0) {
      upper.setVelocityY(-PADDLE_SPEED);
      lower.setVelocityY(-PADDLE_SPEED);
    } else if (down.isDown && lower.y - lower.body.height / 2 < this.height) {
      upper.setVelocityY(PADDLE_SPEED);
      lower.setVelocityY(PADDLE_SPEED);
    }
    // if (paddle.y < paddle.body.height / 2) paddle.y = paddle.body.height / 2;
    // if (paddle.y > this.height - paddle.body.height / 2) paddle.y = this.height - paddle.body.height / 2;

  }

  setPlayVisible(value) {
    this.divider.setVisible(value);
    this.upperLeftPaddle.setVisible(value);
    this.lowerLeftPaddle.setVisible(value);
    this.upperRightPaddle.setVisible(value);
    this.lowerRightPaddle.setVisible(value);
    this.scoreInfo.setVisible(value);
    this.ball.setVisible(value);

    if (value) {
      this.resetBall(this.ball);
      this.resetPaddles();
    }
  }

  resetPaddles() {
    this.upperLeftPaddle.setVelocity(0, 0);
    this.upperLeftPaddle.setAcceleration(0, 0);
    this.upperLeftPaddle.setPosition(PADDLE_INSET, 0);
    this.lowerLeftPaddle.setVelocity(0, 0);
    this.lowerLeftPaddle.setAcceleration(0, 0);
    this.lowerLeftPaddle.setPosition(PADDLE_INSET, this.height);

    this.upperRightPaddle.setVelocity(0, 0);
    this.upperRightPaddle.setAcceleration(0, 0);
    this.upperRightPaddle.setPosition(this.width - PADDLE_INSET, 0);
    this.lowerRightPaddle.setVelocity(0, 0);
    this.lowerRightPaddle.setAcceleration(0, 0);
    this.lowerRightPaddle.setPosition(this.width - PADDLE_INSET, this.height);

  }

}