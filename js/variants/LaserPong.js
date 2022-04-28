class LaserPong extends Pong {
  constructor() {
    super({
      key: `LASER PONG`
    });
  }

  create() {
    super.create();

    this.leftBullet = this.createPhysicsRect(this.width / 2, -100, 10, 2, false);
    this.leftBullet.ready = true;

    this.rightBullet = this.createPhysicsRect(this.width / 2, -100, 10, 2, false);
    this.rightBullet.ready = true;

    this.keys.left = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.LEFT);
    this.keys.d = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.D);

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [S] TO MOVE, [D] TO FIRE\n\n" +
      "PLAYER 2: [UP] / [DOWN] TO MOVE, [LEFT] TO FIRE\n\n" +
      "AVOID MISSING BALL FOR HIGH SCORE\n\n" +
      "DON'T SHOOT THE BALL\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";
  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      this.checkBullets();
    }
  }

  resetBullet(bullet) {
    bullet.setVelocity(0, 0);
    bullet.setPosition(this.width / 2, -200);
    bullet.ready = true;
  }

  checkBullets() {
    if (this.leftBullet.x + this.leftBullet.body.width > this.width) {
      this.resetBullet(this.leftBullet);
    }
    if (this.rightBullet.x - this.rightBullet.body.width < 0) {
      this.resetBullet(this.rightBullet);
    }
  }

  doCollisions() {
    super.doCollisions();

    this.physics.collide(this.rightBullet, this.leftPaddle, this.bulletHit, null, this);
    this.physics.collide(this.leftBullet, this.rightPaddle, this.bulletHit, null, this);
    this.physics.collide(this.rightBullet, this.ball, this.ballHit, null, this);
    this.physics.collide(this.leftBullet, this.ball, this.ballHit, null, this);
  }

  bulletHit(bullet, paddle) {
    this.pointSFX.play();
    paddle.body.setEnable(false);
    paddle.setVisible(false);
    this.resetBullet(bullet);
  }

  ballHit(bullet, ball) {
    this.pointSFX.play();

    if (bullet.body.velocity.x < 0) {
      this.leftScore++;
    } else if (bullet.body.velocity.x > 0) {
      this.rightScore++;
    }
    this.setScores();

    this.resetBullet(bullet);

    this.resetPlay();
  }

  resetPlay() {
    super.resetPlay();

    this.ball.setActive(true);

    this.leftPaddle.body.setEnable(true);
    this.rightPaddle.body.setEnable(true);
    this.leftPaddle.setVisible(true);
    this.rightPaddle.setVisible(true);

    this.resetBullet(this.leftBullet);
    this.resetBullet(this.rightBullet);
  }

  handlePaddleInput() {
    super.handlePaddleInput();

    if (this.keys.d.isDown && this.leftBullet.ready) {
      this.leftBullet.setPosition(this.leftPaddle.x + this.leftBullet.body.width * 2, this.leftPaddle.y);
      this.leftBullet.setVelocity(300, 0);
      this.leftBullet.ready = false;
    }

    if (this.keys.left.isDown && this.rightBullet.ready) {
      this.rightBullet.setPosition(this.rightPaddle.x - this.rightBullet.body.width * 2, this.rightPaddle.y);
      this.rightBullet.setVelocity(-300, 0);
      this.rightBullet.ready = false;
    }
  }
}