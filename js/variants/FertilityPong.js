class FertilityPong extends Pong {
  constructor() {
    super({
      key: `FERTILITY PONG`
    });
  }

  create() {
    this.balls = this.physics.add.group();
    this.addBall();
    this.balls.setVisible(false);

    super.create();

    this.instructionsText.text = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

AVOID MISSING BALL(S) FOR HIGH SCORE

[SPACE] TO START\n[ESCAPE] TO QUIT`;

    this.ball.destroy();

    this.OVERRIDE_UPDATE = true;
  }

  addBall(x, y, vx = 0, vy = 0) {
    let ball = this.createPhysicsRect(x, y, BALL_SIZE, BALL_SIZE, false)
    this.balls.add(ball);
    ball.setBounce(1);
    ball.setVelocity(vx, vy);
    ball.setMaxVelocity(350, 350)

  }

  setPlayVisible(value) {
    this.divider.setVisible(value);
    this.leftPaddle.setVisible(value);
    this.rightPaddle.setVisible(value);
    this.scoreInfo.setVisible(value);
    this.balls.setVisible(value);
  }

  update() {
    this.handleInput();

    if (this.state === State.PLAYING) {
      if (!this.balls.getFirstAlive()) {
        this.resetPlay();
      } else {
        this.physics.collide(this.balls, this.walls, this.wallHit, null, this);
        this.physics.collide(this.leftPaddle, this.balls, this.paddleHit, null, this);
        this.physics.collide(this.rightPaddle, this.balls, this.paddleHit, null, this);

        this.balls.getChildren()
          .forEach(ball => {
            if (ball.active) {
              this.checkBall(ball);
            }
          });
      }
    }
  }

  checkBall(ball) {
    let point = false;

    // Check if the ball has gone off the screen
    if (ball.x + ball.body.width / 2 < 0) {
      ball.setActive(false);
      this.pointSFX.play();
      this.rightScore++;
      this.lastPoint = Player.TWO;
      point = true;
    } else if (ball.x - ball.body.width / 2 > this.width) {
      ball.setActive(false);
      this.pointSFX.play();
      this.leftScore++;
      this.lastPoint = Player.ONE;
      point = true;
    }

    this.setScores();

    if (this.gameIsOver()) {
      this.gameOver();
    } else if (point && !this.balls.getFirstAlive()) {
      this.resetPlay();
    }
  }

  paddleHit(paddle, ball) {
    this.paddleSFX.play();

    // USE A MORE "CONSTANT SPEED"
    let ballDirection = Math.atan2(ball.body.velocity.y, ball.body.velocity.x);
    ball.setVelocityY(Math.sin(ballDirection) * BALL_SPEED + (paddle.body.velocity.y * PADDLE_BALL_INFLUENCE_FACTOR));
    let x = ball.x;
    let y = ball.y;
    let vx = ball.body.velocity.x + (Math.random() * ball.body.velocity.x * 0.1);
    let vy = ball.body.velocity.y + 0.5 * -(Math.sin(ballDirection) * BALL_SPEED + (paddle.body.velocity.y * PADDLE_BALL_INFLUENCE_FACTOR));
    this.addBall(x, y, vx, vy);

    return true;
  }

  gameOver() {
    this.state = State.GAMEOVER;

    this.clearTimeouts();

    this.deactivate();

    if (this.leftScore > this.rightScore) {
      this.winnerInfo.setX(this.width / 4);
    } else if (this.rightScore > this.leftScore) {
      this.winnerInfo.setX(3 * this.width / 4);
    }

    this.setGameOverVisible(true);
    this.balls.clear(true, true);
  }

  resetPlay() {
    this.state = State.PLAYING;

    this.balls.clear(true, true);
    this.addBall(this.width / 2, this.height / 2);

    this.activate();

    this.timer = setTimeout(() => {
      this.launchBall();
    }, BALL_LAUNCH_DELAY);
  }

  launchBall() {
    let ball = this.balls.getFirstAlive();
    this.setLaunchVelocity(ball);
  }
}