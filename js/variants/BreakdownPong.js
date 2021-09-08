class BreakdownPong extends Pong {

  constructor() {
    super({
      key: `breakdown-pong`
    });
  }

  create() {
    this.titleString = `BREAKDOWN PONG`;

    super.create();

    this.instructionText.text = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

[SPACE] TO START
[ESCAPE] TO QUIT`;

    // Replace the paddles with multiple sprites
    this.leftPaddleGroup = this.physics.add.group();
    this.rightPaddleGroup = this.physics.add.group();

    for (let i = 0; i < 6; i++) {
      let leftBlock = this.createRect(20, 220 + i * 10, 10, 10);
      this.leftPaddleGroup.add(leftBlock);

      let rightBlock = this.createRect(this.width - 20, 220 + i * 10, 10, 10);
      this.rightPaddleGroup.add(rightBlock);
    }

    this.leftPaddle.destroy();
    this.rightPaddle.destroy();

    this.leftPaddleGroup.setVisible(false);
    this.rightPaddleGroup.setVisible(false);
  }

  update(delta, time) {
    super.update(time, delta);
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit.bind(this));
    this.physics.collide(this.leftPaddleGroup, this.ball, this.paddleBlockHit.bind(this));
    this.physics.collide(this.rightPaddleGroup, this.ball, this.paddleBlockHit.bind(this));
  }

  paddleBlockHit(paddleBlock, ball) {
    console.log("A very palpable hit")
    this.lastHit = paddleBlock.x < this.width / 2 ? `LEFT` : `RIGHT`;

    ball.body.velocity.y += paddleBlock.body.velocity.y;
    paddleBlock.destroy();
  }

  activate() {
    this.ball.active = true;
    this.leftPaddleGroup.active = true;
    this.rightPaddleGroup.active = true;
  }

  deactivate() {
    this.ball.active = false;
    this.leftPaddleGroup.active = false;
    this.rightPaddleGroup.active = false;
  }

  showPlay() {
    this.playGraphics.setVisible(true);
    this.leftPaddleGroup.setVisible(true);
    this.rightPaddleGroup.setVisible(true);
    this.instructionGraphics.setVisible(false);
    this.state = `PLAYING`;
  }

  handlePaddleInput() {
    if (this.state !== `PLAYING`) {
      return;
    }

    this.handlePaddleGroup(this.leftPaddleGroup, this.w, this.s);
    this.handlePaddleGroup(this.rightPaddleGroup, this.up, this.down);
  }

  handlePaddleGroup(paddleGroup, up, down) {
    if (up.isDown && paddleGroup.getChildren()[0].body.velocity.y >= 0) {
      paddleGroup.setVelocityY(-PADDLE_SPEED);
    } else if (down.isDown && paddleGroup.getChildren()[0].body.velocity.y <= 0) {
      paddleGroup.setVelocityY(PADDLE_SPEED);
    } else {
      paddleGroup.setVelocityY(0);
    }
  }

}