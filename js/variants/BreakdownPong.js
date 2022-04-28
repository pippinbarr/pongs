class BreakdownPong extends Pong {
  constructor() {
    super({
      key: `BREAKDOWN PONG`
    });
  }

  create() {
    this.leftPaddleGroup = this.physics.add.group();
    this.rightPaddleGroup = this.physics.add.group();

    super.create();

    this.resetPaddles();

    this.leftPaddle.destroy();
    this.rightPaddle.destroy();

    this.leftPaddleGroup.setVisible(false);
    this.rightPaddleGroup.setVisible(false);

    this.paddlesReset = true;
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit, null, this);
    this.physics.collide(this.leftPaddleGroup, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.rightPaddleGroup, this.ball, this.paddleHit, null, this);
  }

  paddleHit(ball, block) {
    this.paddleSFX.play();

    let ballDirection = Math.atan2(ball.body.velocity.y, ball.body.velocity.x);
    ball.setVelocityY(Math.sin(ballDirection) * BALL_SPEED + (block.body.velocity.y * PADDLE_BALL_INFLUENCE_FACTOR));

    block.destroy();
  }

  activate() {
    this.ball.setActive(true);
    this.leftPaddleGroup.getChildren()
      .forEach(child => {
        child.setActive(true);
        child.setVisible(true)
      });
    this.rightPaddleGroup.getChildren()
      .forEach(child => {
        child.setActive(true);
        child.setVisible(true)
      });
  }

  deactivate() {
    this.ball.setActive(false);
    this.leftPaddleGroup.getChildren()
      .forEach(child => {
        child.setActive(false);
        child.setVisible(false)
      });
    this.rightPaddleGroup.getChildren()
      .forEach(child => {
        child.setActive(false);
        child.setVisible(false)
      });
  }

  resetPlay() {
    clearTimeout(this.timer);

    this.activate();

    this.resetBall(this.ball);
    this.resetPaddles();

    this.state = State.SERVING;
    this.lastHit = Player.NONE;

    this.timer = setTimeout(() => {
      this.launchBall();
    }, BALL_LAUNCH_DELAY);
  }

  resetPaddles() {
    this.leftPaddleGroup.clear(true, true);
    this.rightPaddleGroup.clear(true, true);

    for (let i = 0; i < 6; i++) {
      let leftBlock = this.createPhysicsRect(PADDLE_INSET, 220 + (i * 10), 10, 10);
      leftBlock.setBounce(1);
      this.leftPaddleGroup.add(leftBlock);
      leftBlock.setImmovable(true);

      let rightBlock = this.createPhysicsRect(this.width - PADDLE_INSET, 220 + (i * 10), 10, 10);
      rightBlock.setBounce(1);
      this.rightPaddleGroup.add(rightBlock);
      rightBlock.setImmovable(true);
    }
  }

  setPlayVisible(value) {
    this.divider.setVisible(value);
    this.leftPaddleGroup.setVisible(value);
    this.rightPaddleGroup.setVisible(value);
    this.scoreInfo.setVisible(value);
    this.ball.setVisible(value);
  }

  handlePaddleInput() {
    this.handleSpecificPaddleInput(this.rightPaddleGroup, this.keys.up, this.keys.down);
    this.handleSpecificPaddleInput(this.leftPaddleGroup, this.keys.w, this.keys.s);
  }

  handleSpecificPaddleInput(paddleGroup, up, down) {
    paddleGroup.setVelocity(0, 0);

    if (up.isDown) {
      paddleGroup.setVelocityY(-PADDLE_SPEED);
    } else if (down.isDown) {
      paddleGroup.setVelocityY(PADDLE_SPEED);
    }

    let topY = this.height;
    let bottomY = 0;
    paddleGroup.getChildren()
      .forEach(function (child) {
        if (child.active) {
          if (child.y < topY) topY = child.y;
          if (child.y > bottomY) bottomY = child.y;
        }
      });

    let dTop = 0 - topY;
    if (dTop > 0) paddleGroup.incY(dTop);

    let dBottom = this.height - bottomY;
    if (dBottom < 0) paddleGroup.incY(dBottom);
  }
}