class PerlinPong extends Pong {
  constructor() {
    super({
      key: `PERLIN PONG`
    });
  }

  create() {
    super.create();

    this.perlin = this.plugins.get('rexperlinplugin')
      .add(Math.random());
    this.tx = 0;
    this.ty = Math.random() * 1000;
  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      this.tx += 0.01;
      this.ty += 0.01;

      let v = this.perlin.perlin2(this.tx, this.ty)
      this.ball.body.velocity.y += v * this.ballSpeed / 12;
    }
  }
}