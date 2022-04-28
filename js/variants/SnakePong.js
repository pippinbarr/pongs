class SnakePong extends Pong {
  constructor() {
    super({
      key: `SNAKE PONG`
    });
  }

  create() {
    super.create();

    this.apple = this.createPhysicsRect(-100, -100, BALL_SIZE, BALL_SIZE)
      .setTint(0xff0000);
    this.appleTimer = undefined;

    this.tailBalls = [];

    this.OVERRIDE_UPDATE = true;

    this.instructionsText.text = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

AVOID MISSING SNAKE FOR HIGH SCORE

[SPACE] TO START\n[ESCAPE] TO QUIT`;
    // this.physics.world.setFPS(15); // This would be funny, but let's stick to the script
  }

  update() {
    this.handleInput();

    if (this.state === State.PLAYING) {
      this.physics.overlap(this.ball, this.apple, this.appleHit, null, this);
      this.checkBall(this.ball);
      this.doCollisions();
      this.updateTail();
      this.ball.px = this.ball.x;
      this.ball.py = this.ball.y;
      this.checkGameOver();
    }
  }

  updateTail() {
    for (let i = 0; i < this.tailBalls.length - 1; i++) {
      let ball = this.tailBalls[i];
      let next = this.tailBalls[i + 1];
      ball.setPosition(next.x, next.y);
    }

    if (this.tailBalls.length > 0) {
      let first = this.tailBalls[this.tailBalls.length - 1];
      first.setPosition(this.ball.x, this.ball.y)
    }
  }

  appleHit(ball, apple) {
    apple.setPosition(-100, -100);
    if (this.lastHit === Player.ONE) {
      this.leftScore += 5;
    } else if (this.lastHit === Player.TWO) {
      this.rightScore += 5;
    }
    this.setScores();
    this.startAppleTimer();
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);
    for (let i = 0; i < 5; i++) {
      let x = ball.x;
      let y = ball.y;
      let tailBall = this.createPhysicsRect(x, y, BALL_SIZE, BALL_SIZE);
      this.tailBalls.unshift(tailBall);
    }
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.appleTimer);
  }

  gameOver() {
    super.gameOver();
    clearTimeout(this.appleTimer);
    this.tailBalls.forEach(ball => {
      ball.setDepth(-100);
    });
    this.apple.setDepth(-100);
  }

  resetPlay() {
    super.resetPlay();
    clearTimeout(this.appleTimer);
    this.tailBalls.forEach(ball => {
      ball.destroy();
    });
    this.tailBalls = [];
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);
    if (value) {
      this.apple.setPosition(-100, -100);
    }
  }

  launchBall() {
    super.launchBall();
    this.startAppleTimer();
  }

  startAppleTimer(min = 3000, range = 2000) {
    clearTimeout(this.appleTimer);
    this.appleTimer = setTimeout(() => {
      this.placeApple();
    }, Math.random() * min + range);
  }

  placeApple() {
    let x = PADDLE_INSET * 2 + (Math.random() * (this.width - PADDLE_INSET * 4));
    let y = Math.random() * (this.height - BALL_SIZE);
    this.apple.setPosition(x, y);
    this.startAppleTimer(5000, 5000);
  }

}