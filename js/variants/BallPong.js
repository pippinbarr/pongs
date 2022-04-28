class BallPong extends Pong {
  constructor() {
    super({
      key: `BALL PONG`
    });
  }

  create() {
    super.create();

    this.ballControlLeft = Math.random() < 0.5;

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    if (this.ballControlLeft) this.leftScoreLabel.text = "BALL";
    else this.leftScoreLabel.text = "PADDLES";

    if (this.ballControlLeft) this.rightScoreLabel.text = "PADDLES";
    else this.rightScoreLabel.text = "BALL";
  }

  checkBall(ball) {
    let point = false;

    // If the ball has gone off the left side of the screen
    // Increase the right hand score, update the text, set point to true
    if (this.ball.x + this.ball.body.width < 0) {
      if (this.ballControlLeft) {
        this.leftScore++;
      } else {
        this.rightScore++;
      }
      this.lastPoint = Player.TWO;
      point = true;
    }
    // If the ball has gone off the right side of the screen
    // Increase the left hand score, update the text, set point to true
    else if (ball.x > this.width) {
      if (this.ballControlLeft) {
        this.leftScore++;
      } else {
        this.rightScore++;
      }

      this.lastPoint = Player.ONE;
      point = true;
    }
    this.setScores();

    // If either player is at or over the winning score
    // and is at least two ahead...
    if ((this.leftScore >= GAME_OVER_SCORE && this.leftScore - 2 >= this.rightScore) ||
      (this.rightScore >= GAME_OVER_SCORE && this.rightScore - 2 >= this.leftScore)) {
      this.pointSFX.play();
      this.gameOver();
    }
    // Otherwise, if a point was scored, we go into the after point mode which
    // means delaying relaunching the ball
    else if (point) {
      this.pointSFX.play();
      this.resetPlay();
    }
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);

    if (!this.ballControlLeft) {
      this.leftScore++;
    } else {
      this.rightScore++;
    }
    this.setScores();
  }

  handlePaddleInput() {
    // HANDLE PADDLE INPUT
    if (this.ballControlLeft) {
      this.handleSpecificPaddleInput(this.rightPaddle, this.keys.up, this.keys.down);
      this.handleSpecificPaddleInput(this.leftPaddle, this.keys.up, this.keys.down);
    } else {
      this.handleSpecificPaddleInput(this.rightPaddle, this.keys.w, this.keys.s);
      this.handleSpecificPaddleInput(this.leftPaddle, this.keys.w, this.keys.s);
    }

    // HANDLE BALL INPUT
    // this.ball.setVelocityY(0);
    if (this.ball.body.velocity.x === 0) return;

    if (this.ballControlLeft) {
      if (this.keys.w.isDown) {
        this.ball.setVelocityY(-BALL_SPEED / 3);
      } else if (this.keys.s.isDown) {
        this.ball.setVelocityY(BALL_SPEED / 3);
      }
    } else {
      if (this.keys.up.isDown) {
        this.ball.setVelocityY(-BALL_SPEED / 3);
      } else if (this.keys.down.isDown) {
        this.ball.setVelocityY(BALL_SPEED / 3);
      }
    }

    if (this.ball.y - this.ball.body.height / 2 < 0) {
      this.ball.y = this.ball.body.height / 2;
    } else if (this.ball.y + this.ball.body.height / 2 > this.height) {
      this.ball.y = this.height - this.ball.body.height / 2;
    }
  }
}