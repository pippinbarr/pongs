class BallPong extends Pong {

  constructor() {
    super({
      key: `ball-pong`
    });
  }

  create() {
    this.titleString = `BALL PONG`;
    this.ballControlLeft = Math.random() < 0.5;

    super.create();

    this.leftScoreLabel.text = this.ballControlLeft ? `BALL` : `PADDLES`;
    this.rightScoreLabel.text = !this.ballControlLeft ? `BALL` : `PADDLES`;
    this.instructionText.text = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

[SPACE] TO START
[ESCAPE] TO QUIT`;
  }

  update(delta, time) {
    super.update(time, delta);
  }

  checkBall(ball) {
    let point = false;
    if (ball.x + ball.width / 2 < 0 || ball.x - ball.width / 2 > this.width) {
      if (this.ballControlLeft) {
        this.setScores(++this.leftScore, this.rightScore);
        this.lastPoint = `PLAYER 1`;
        point = true;
      } else {
        this.setScores(this.leftScore, ++this.rightScore);
        this.lastPoint = `PLAYER 2`;
        point = true;
      }
    }

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);

    if (this.ballControlLeft) {
      this.setScores(this.leftScore, ++this.rightScore);
    } else {
      this.setScores(++this.leftScore, this.rightScore);
    }
  }

  handlePaddleInput(e) {
    if (this.state !== `PLAYING`) {
      return;
    }

    if (this.ballControlLeft) {
      this.handlePaddle(this.leftPaddle, this.up, this.down);
      this.handlePaddle(this.rightPaddle, this.up, this.down);
      if (this.w.isDown && this.ball.body.velocity.y <= 0) {
        this.ball.setVelocityY(-BALL_SPEED / 4);
      }
      if (this.s.isDown && this.ball.body.velocity.y >= 0) {
        this.ball.setVelocityY(BALL_SPEED / 4);
      }
    } else {
      this.handlePaddle(this.leftPaddle, this.w, this.s);
      this.handlePaddle(this.rightPaddle, this.w, this.s);
      if (this.up.isDown && this.ball.body.velocity.y >= 0) {
        this.ball.setVelocityY(-BALL_SPEED / 4);
      }
      if (this.down.isDown && this.ball.body.velocity.y <= 0) {
        this.ball.setVelocityY(BALL_SPEED / 4);
      }
    }
  }

}