class PrisonerPong extends Pong {
  constructor() {
    super({
      key: `PRISONER PONG`
    });
  }

  create() {

    this.prisonWall = this.createPhysicsRect(this.width / 2, this.height / 2, 10, this.height);
    this.ball2 = this.createPhysicsRect(
        this.width / 2 + 5 * BALL_SIZE, this.height / 2,
        BALL_SIZE, BALL_SIZE, false)
      .setBounce(1)
      .setMaxVelocity(350, 350);

    super.create();

    this.substate = `none`; // left out, right out, both out
    this.leftMissed = false;
    this.rightMissed = false;

    this.ball.x = this.width / 2 - 5 * BALL_SIZE;

    this.leftTimer = undefined;
    this.rightTimer = undefined;

    this.divider.setVisible(false);

    this.ball.setVisible(false);
    this.ball2.setVisible(false);
    this.prisonWall.setVisible(false);

    this.OVERRIDE_UPDATE = true;
  }

  update() {
    super.update();

    // this.handleInput();
    if (this.keys.esc.isDown) {
      this.clearTimeouts();
      this.scene.start(`menu`); // For now, until there's a menu
    }

    if (this.state === State.PLAYING) {
      this.checkLeftBall();
      this.physics.collide(this.ball, this.walls, this.wallHit, null, this);
      this.physics.collide(this.ball, this.prisonWall, this.prisonWallHit, null, this);
      this.physics.collide(this.leftPaddle, this.ball, this.paddleHit, null, this);

      this.checkRightBall();
      this.physics.collide(this.ball2, this.walls, this.wallHit, null, this);
      this.physics.collide(this.ball2, this.prisonWall, this.prisonWallHit, null, this);
      this.physics.collide(this.rightPaddle, this.ball2, this.paddleHit, null, this);

      this.handlePaddleInput();

      this.checkScores();
    } else {
      if (this.keys.space.isDown) {
        this.setScores(0, 0);
        this.setInstructionsVisible(false);
        this.setGameOverVisible(false);
        this.setPlayVisible(true);
        this.resetPlay();
        this.state = State.PLAYING;
      }
    }
  }

  resetPlay() {
    clearTimeout(this.leftTimer);
    clearTimeout(this.rightTimer);
    this.resetLeft();
    this.resetRight();
    this.lastHit = Player.NONE;
    this.activate();
  }

  checkLeftBall() {
    if (this.ball.x < 0 - this.ball.body.width) {
      this.pointSFX.play();
      this.resetLeft();
    }
  }

  checkRightBall() {
    if (this.ball2.x > this.width + this.ball2.body.width) {
      this.pointSFX.play();
      this.resetRight();
    }
  }

  resetLeft() {
    this.ball.setVelocity(0, 0);
    this.ball.setPosition(this.width / 2 - BALL_SIZE * 5, this.height / 2);
    this.leftTimer = setTimeout(() => {
      this.launchLeftBall();
    }, BALL_LAUNCH_DELAY);
  }

  resetRight() {
    this.ball2.setVelocity(0, 0);
    this.ball2.setPosition(this.width / 2 + BALL_SIZE * 5, this.height / 2);
    this.rightTimer = setTimeout(() => {
      this.launchRightBall();
    }, BALL_LAUNCH_DELAY);
  }

  checkScores() {
    if ((this.leftScore >= GAME_OVER_SCORE && this.leftScore - 2 >= this.rightScore) ||
      (this.rightScore >= GAME_OVER_SCORE && this.rightScore - 2 >= this.leftScore)) {
      this.gameOver();
    }
  }

  gameOver() {
    super.gameOver();
    this.ball2.setVisible(false);
  }

  prisonWallHit(ball, wall) {
    this.wallSFX.play();
    if (ball.x < this.width / 2) {
      this.leftScore++;
    } else if (ball.x > this.width / 2) {
      this.rightScore++;
    }
    this.setScores();
  }

  clearTimeouts() {
    clearTimeout(this.leftTimer);
    clearTimeout(this.rightTimer);
  }

  activate() {
    super.activate();
    this.ball2.setActive(true);
  }

  deactivate() {
    super.deactivate();
    this.ball2.setActive(false);
  }

  launchLeftBall() {
    this.state = State.PLAYING;
    let ballDirection = (Math.random() * Math.PI / 4) + Math.PI - Math.PI / 8;
    this.ball.setVelocity(Math.cos(ballDirection) * BALL_SPEED, Math.sin(ballDirection) * BALL_SPEED);
  }

  launchRightBall() {
    this.state = State.PLAYING;
    let ballDirection = (Math.random() * Math.PI / 4) - Math.PI / 8;
    this.ball2.setVelocity(Math.cos(ballDirection) * BALL_SPEED, Math.sin(ballDirection) * BALL_SPEED);
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);
    this.prisonWall.setVisible(value);
    this.ball2.setVisible(value);
  }

}