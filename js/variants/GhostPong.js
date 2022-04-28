class GhostPong extends Pong {
  constructor() {
    super({
      key: `GHOST PONG`
    });
  }

  create() {
    super.create();

    this.leftPaddle.setAlpha(0.5);
    this.rightPaddle.setAlpha(0.5);
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit, null, this);
  }
}