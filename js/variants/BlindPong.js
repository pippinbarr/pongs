class BlindPong extends Pong {

  constructor() {
    super({
      key: `blind-pong`
    });
  }

  create() {
    this.titleString = `BLIND PONG`;
    this.ballControlLeft = Math.random() < 0.5;

    super.create();

    this.instructionText.text = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

BALL ALWAYS SERVED STRAIGHT AHEAD
PADDLE RESET TO CENTER ON SERVE

[SPACE] TO START
[ESCAPE] TO QUIT`;
  }

  update(delta, time) {
    super.update(time, delta);
  }

  showPlay() {
    super.showPlay();
    // this.playGraphics.setVisible(false);
  }

  resetPlay() {
    super.resetPlay();
    this.leftPaddle.y = this.height / 2;
    this.rightPaddle.y = this.height / 2;
  }

  launchBall() {
    this.state = `PLAYING`;
    let ballDirection;
    if (this.lastPoint === `PLAYER 2`) {
      ballDirection = 0;
    } else if (this.lastPoint === `PLAYER 1`) {
      ballDirection = Math.PI;
    }
    this.ball.setVelocity(Math.cos(ballDirection) * BALL_SPEED, Math.sin(ballDirection) * BALL_SPEED);
  }

}