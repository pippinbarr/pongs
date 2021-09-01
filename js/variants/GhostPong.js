class GhostPong extends Pong {

  constructor() {
    super({
      key: `ghost-pong`
    });
  }

  create() {
    this.titleString = `GHOST PONG`;

    super.create();

    this.leftPaddle.setAlpha(0.5);
    this.rightPaddle.setAlpha(0.5);
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit.bind(this));
  }

}