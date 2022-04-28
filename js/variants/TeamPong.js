class TeamPong extends Pong {
  constructor() {
    super({
      key: `TEAM PONG`
    });
  }

  create() {
    super.create();

    this.winnerInfo2 = this.createWinnerInfo()
      .setVisible(false);
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);
    this.leftScore++;
    this.rightScore++;
    this.setScores();
  }

  checkBall(ball) {
    let point = false;

    // Check if the ball has gone off the screen
    if (ball.x + ball.width / 2 < 0) {
      this.rightScore -= 2;
      this.leftScore -= 2;
      this.lastPoint = Player.TWO;
      point = true;
    } else if (ball.x - ball.width / 2 > this.width) {
      this.rightScore -= 2;
      this.leftScore -= 2;
      this.lastPoint = Player.ONE;
      point = true;
    }

    if (this.leftScore < 0) {
      this.leftScore = 0;
      this.rightScore = 0;
    }
    this.setScores();

    if (point) {
      this.postPoint();
    }
  }

  setGameOverVisible(value) {
    super.setGameOverVisible(value);
    if (this.winnerInfo2) this.winnerInfo2.setVisible(value);

    if (value) {
      this.winnerInfo.setX(this.width / 4);
      this.winnerInfo2.setX(3 * this.width / 4);
    }
  }

  gameIsOver() {
    return (this.leftScore >= GAME_OVER_SCORE && this.rightScore >= GAME_OVER_SCORE);
  }

  gameOver() {
    super.gameOver();
  }
}