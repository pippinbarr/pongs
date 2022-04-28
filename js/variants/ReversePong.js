class ReversePong extends Pong {
  constructor() {
    super({
      key: `REVERSE PONG`
    });
  }

  create() {
    super.create();

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE\n\n" +
      "AVOID MISSING PADDLE FOR HIGH SCORE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.leftPaddle.setScale(BALL_SIZE);
    this.rightPaddle.setScale(BALL_SIZE);
    this.ball.setScale(PADDLE_WIDTH, PADDLE_HEIGHT);
  }
}