class BlindPong extends Pong {
  constructor() {
    super({
      key: `BLIND PONG`
    });
  }

  create() {
    super.create();

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "BALL ALWAYS SERVED STRAIGHT AHEAD\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";
  }

  resetPlay() {
    super.resetPlay();

    this.ball.setVisible(false);
    this.divider.setVisible(false);
  }

  launchBall() {
    this.state = State.PLAYING;

    if (this.lastPoint === Player.TWO) {
      this.ball.setVelocity(BALL_SPEED, 0);
    } else if (this.lastPoint === Player.ONE) {
      this.ball.setVelocity(-BALL_SPEED, 0);
    } else {
      this.ball.setVelocity(Math.random() < 0.5 ? BALL_SPEED : -BALL_SPEED, 0);
    }
  }
}