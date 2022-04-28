class PongSansFrontiers extends Pong {
  constructor() {
    super({
      key: `PONG SANS FRONTIERS`
    });
  }

  create() {
    super.create();
  }

  doCollisions() {
    this.physics.collide(this.leftPaddle, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.rightPaddle, this.ball, this.paddleHit, null, this);
  }

  checkBall(ball) {
    super.checkBall(ball);

    if (ball.y + ball.body.height < 0) {
      ball.y = this.height + ball.y;
    } else if (ball.y > this.height) {
      ball.y = this.height - ball.y;
    }
  }
}