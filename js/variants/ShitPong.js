class ShitPong extends Pong {
  constructor() {
    super({
      key: `SHIT PONG`
    });
  }

  create() {
    super.create();

    this.shits = this.physics.add.group();
  }

  doCollisions() {
    super.doCollisions();
    this.physics.collide(this.ball, this.shits, this.shitHit, null, this);
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);
    this.newShit(ball.x, ball.y);
  }

  wallHit(ball, wall) {
    super.wallHit(ball, wall);
    this.newShit(ball.x, ball.y);
  }

  shitHit(ball, shit) {
    this.newShit(ball.x, ball.y);
  }

  newShit(x, y) {
    let shit = this.createPhysicsRect(x, y, BALL_SIZE, BALL_SIZE)
      .setBounce(1)
      .setTint(0xff733d1a);
    this.shits.add(shit);
    shit.setImmovable(true);
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    if (value) {
      this.shits.clear(true, true);
    }
  }

  gameOver() {
    super.gameOver();
    this.shits.setDepth(-100);
  }



}