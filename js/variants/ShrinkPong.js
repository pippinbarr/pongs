class ShrinkPong extends Pong {
  constructor() {
    super({
      key: `SHRINK PONG`
    });
  }

  create() {
    super.create();

    this.shrinkage = 2;
    this.startingScale = 8;
    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "AVOID MISSING BALL FOR HIGH SCORE\n\n" +
      "DON'T BE THE ONE TO MAKE THE BALL VANISH\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.ball.setScale(this.ball.scale * this.startingScale);
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);
    this.shrinkBall();
  }

  wallHit(ball, wall) {
    super.wallHit(ball, wall);
    this.shrinkBall();
  }

  shrinkBall() {
    if (this.ball.body.width - this.shrinkage > 0) {
      this.ball.setScale(this.ball.scale - this.shrinkage);
    } else {
      if (this.lastHit === Player.ONE) {
        this.rightScore++;
      } else {
        this.leftScore++;
      }
      this.setScores();
      this.resetPlay();
    }
  }

  resetBall(ball) {
    ball.setScale(BALL_SIZE * this.startingScale);
    super.resetBall(ball);
  }
}