class PongForTwo extends Pong {
  constructor() {
    super({
      key: `PONG FOR TWO`
    });
  }

  create() {
    super.create();

    this.lastBounce = Player.NONE;
    this.leftPaddle.setBounce(1);
    this.rightPaddle.setBounce(1);

    this.ball.setGravityY(500);

    this.divider.clear(true, true);
    for (let i = 0; i < 4; i++) {
      let block = this.createPhysicsRect(this.width / 2, this.height - i * 15 - 7.5, 10, 10)
        .setBounce(1);
      this.divider.add(block);
      block.setImmovable(true);

      this.setPlayVisible(false);
    }

    this.ballLaunchDelay = 800;
  }

  doCollisions() {
    super.doCollisions();
    this.physics.collide(this.ball, this.divider);
  }

  paddleHit(paddle, ball) {

    ball.body.velocity.y += paddle.body.velocity.y * 0.1;

    this.lastBounce = Player.NONE;

    // Handle double hits...
    if (paddle.x < this.width / 2 && this.lastHit === Player.ONE) {
      this.rightScore++;
      this.setScores();
      if (!this.gameIsOver()) {
        this.postPoint();
      }
    } else if (paddle.x > this.width / 2 && this.lastHit === Player.TWO) {
      this.leftScore++;
      this.setScores();
      if (!this.gameIsOver()) {
        this.postPoint();
      }
    }

    super.paddleHit(paddle, ball);
  }

  wallHit(ball, wall) {
    super.wallHit(ball, wall);

    let rightPoint = this.checkPlayer(ball.x < this.width / 2, Player.ONE);
    let leftPoint = this.checkPlayer(ball.x > this.width / 2, Player.TWO);

    if (rightPoint) {
      this.rightScore++;
    }
    if (leftPoint) {
      this.leftScore++;
    }

    this.setScores();
    if ((rightPoint || leftPoint) && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  checkPlayer(condition, player) {
    let point = false;
    if (condition) {
      if (this.lastBounce === player) {
        point = true;
      } else {
        this.lastBounce = player;
        if (this.lastHit === player) {
          point = true;
        }
      }
    }
    return point;
  }

  resetPlay() {
    super.resetPlay();
    this.lastBounce = Player.NONE;
  }
}