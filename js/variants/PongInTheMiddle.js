class PongInTheMiddle extends Pong {
  constructor() {
    super({
      key: `PONG IN THE MIDDLE`
    });
  }

  create() {
    this.width = this.game.canvas.width;
    this.height = this.game.canvas.height;

    this.middlePaddle = this.createPhysicsRect(
        this.width / 2, this.height / 2, PADDLE_WIDTH, PADDLE_HEIGHT)
      .setBounce(1);

    this.MIDDLE_PADDLE_MAX_SPEED = PADDLE_SPEED;

    super.create();
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);
    this.middlePaddle.setVisible(value);
    console.log(this.middlePaddle.x, this.middlePaddle.y);
  }

  update() {
    super.update();
    if (this.state === State.PLAYING) {
      this.updateAI();
    }
  }

  doCollisions() {
    super.doCollisions();
    this.physics.collide(this.middlePaddle, this.ball, this.paddleHit, null, this);
  }

  updateAI() {
    this.middlePaddle.setVelocity(0, 0);

    if ((this.ball.x < this.width / 2 && this.ball.body.velocity.x > 0) ||
      (this.ball.x > this.width / 2 && this.ball.body.velocity.x < 0)) {
      // BALL COMING SO INTERCEPT
      if (this.middlePaddle.y < this.ball.y - 10) {
        this.middlePaddle.body.velocity.y = this.MIDDLE_PADDLE_MAX_SPEED - Math.floor(Math.random() * 300);
      } else if (this.middlePaddle.y > this.ball.y + 10) {
        this.middlePaddle.body.velocity.y = -this.MIDDLE_PADDLE_MAX_SPEED + Math.floor(Math.random() * 300);
      }
    } else {
      // BALL NOT COMING, SO RETURN TO MIDDLE
      if (this.middlePaddle.y > this.height / 2 + 10) {
        this.middlePaddle.body.velocity.y = -this.MIDDLE_PADDLE_MAX_SPEED + Math.floor(Math.random() * 200);
      } else if (this.middlePaddle.y < this.height / 2 - 10) {
        this.middlePaddle.body.velocity.y = this.MIDDLE_PADDLE_MAX_SPEED - Math.floor(Math.random() * 200);
      }
    }
  }
}