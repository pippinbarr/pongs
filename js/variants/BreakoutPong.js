class BreakoutPong extends Pong {
  constructor() {
    super({
      key: `BREAKOUT PONG`
    });
  }

  create() {
    super.create();
  }

  doCollisions() {
    super.doCollisions();

    this.physics.collide(this.ball, this.divider, this.dividerHit, null, this);
  }

  dividerHit(ball, block) {
    this.paddleSFX.play();

    if (this.lastHit === Player.ONE) {
      this.leftScore++;
    } else if (this.lastHit === Player.TWO) {
      this.rightScore++;
    }
    this.setScores();

    let ballDirection = Math.atan2(ball.body.velocity.y, ball.body.velocity.x);

    ball.setVelocityY(Math.sin(ballDirection) * BALL_SPEED);

    block.destroy();
  }

  resetPlay() {
    super.resetPlay();

    this.divider.clear(true, true);
    this.createDivider();
  }

  resetBall(ball) {
    super.resetBall(ball);

    ball.body.y = this.height / 2;

    if (this.lastPoint === Player.ONE) {
      ball.body.position.x = this.width / 2 - 2 * ball.body.width;
    } else if (this.lastPoint === Player.TWO) {
      ball.body.position.x = this.width / 2 + 1 * ball.body.width;
    } else {
      ball.body.position.x = this.width / 2 + ball.body.width * 2 * (Math.random() < 0.5 ? -1 : 0.5);
    }
  }

  setLaunchVelocity(ball) {
    let ballDirection = 0;

    if (ball.body.x > this.width / 2) {
      ballDirection = (Math.random() * Math.PI / 4) - Math.PI / 8;
    } else {
      ballDirection = (Math.random() * Math.PI / 4) + Math.PI - Math.PI / 8;
    }

    let vx = Math.cos(ballDirection) * this.ballSpeed;
    let vy = Math.sin(ballDirection) * this.ballSpeed;

    ball.setVelocity(vx, vy);
  }

}