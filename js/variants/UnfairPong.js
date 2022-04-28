class UnfairPong extends Pong {
  constructor() {
    super({
      key: `UNFAIR PONG`
    });
  }

  create() {
    super.create();
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    // Set up the unfairness for this game
    if (value) {
      if (Math.random() < 0.5) {
        this.leftPaddle.setScale(PADDLE_WIDTH, PADDLE_HEIGHT * 4);
        this.rightPaddle.setScale(PADDLE_WIDTH, PADDLE_HEIGHT / 6);
      } else {
        this.rightPaddle.setScale(PADDLE_WIDTH, PADDLE_HEIGHT * 4);
        this.leftPaddle.setScale(PADDLE_WIDTH, PADDLE_HEIGHT / 6);
      }
    }
  }

  checkBall(ball) {
    let point = false;

    let rH = this.rightPaddle.body.height;
    let lH = this.leftPaddle.body.height;

    // Check if the ball has gone off the screen
    if (ball.x + ball.width / 2 < 0) {
      this.rightScore += (rH > lH) ? 5 : 1;
      this.lastPoint = Player.TWO;
      point = true;
    } else if (ball.x - ball.width / 2 > this.width) {
      this.leftScore += (lH > rH) ? 5 : 1;
      this.lastPoint = Player.ONE;
      point = true;
    }

    this.setScores();

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }
}