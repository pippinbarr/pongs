class ConjoinedPong extends Pong {
  constructor() {
    super({
      key: `CONJOINED PONG`
    });
  }

  create() {
    super.create();
  }

  handlePaddleInput() {
    this.leftPaddle.setVelocity(0, 0);
    this.rightPaddle.setVelocity(0, 0);

    this.handleSpecificPaddleInput(this.rightPaddle, this.keys.up, this.keys.down);
    this.handleSpecificPaddleInput(this.rightPaddle, this.keys.w, this.keys.s);
    this.handleSpecificPaddleInput(this.leftPaddle, this.keys.up, this.keys.down);
    this.handleSpecificPaddleInput(this.leftPaddle, this.keys.w, this.keys.s);
  }

  handleSpecificPaddleInput(paddle, up, down) {
    if (up.isDown && paddle.y > paddle.body.height / 2) {
      paddle.setVelocityY(paddle.body.velocity.y + -PADDLE_SPEED);
    } else if (down.isDown && paddle.y < this.height - paddle.body.height / 2) {
      paddle.setVelocityY(paddle.body.velocity.y + PADDLE_SPEED);
    }
    if (paddle.y < paddle.body.height / 2) paddle.y = paddle.body.height / 2;
    if (paddle.y > this.height - paddle.body.height / 2) paddle.y = this.height - paddle.body.height / 2;
  }
}