class TracePong extends Pong {
  constructor() {
    super({
      key: `TRACE PONG`
    });
  }

  create() {
    super.create();

    this.graphics = this.add.graphics(0, 0);
  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      this.graphics.fillStyle(0xFFffFF, 1.0);
      this.graphics.fillRect(this.ball.x - BALL_SIZE / 2, this.ball.y - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE);
    }
  }

  resetPlay() {
    super.resetPlay();

    this.graphics.clear();
  }
}