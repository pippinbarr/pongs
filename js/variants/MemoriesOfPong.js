class MemoriesOfPong extends Pong {
  constructor() {
    super({
      key: `MEMORIES OF PONG`
    });
  }

  create() {
    this.memoryLeftPaddle = this.createPhysicsRect(
        PADDLE_INSET, this.height / 2,
        PADDLE_WIDTH, PADDLE_HEIGHT)
      .setAlpha(0.5)
      .setVisible(false);

    this.memoryRightPaddle = this.createPhysicsRect(
        this.width - PADDLE_INSET, this.height / 2,
        PADDLE_WIDTH, PADDLE_HEIGHT)
      .setAlpha(0.5)
      .setVisible(false);

    this.memoryBall = this.createPhysicsRect(
        this.width / 2, this.height / 2,
        BALL_SIZE, BALL_SIZE, false)
      .setAlpha(0.5)
      .setVisible(false);

    super.create();

    this.leftPaddlePositions = []
    this.rightPaddlePositions = [];
    this.ballPositions = [];

    this.playbackLeftPaddlePositions = [];
    this.playbackRightPaddlePositions = [];
    this.playbackBallPositions = [];

    this.playbackIndex = 0;




  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      if (this.playbackIndex < this.playbackLeftPaddlePositions.length) {
        this.memoryLeftPaddle.y = this.playbackLeftPaddlePositions[this.playbackIndex];
        this.memoryRightPaddle.y = this.playbackRightPaddlePositions[this.playbackIndex];
        this.memoryBall.x = this.playbackBallPositions[this.playbackIndex].x;
        this.memoryBall.y = this.playbackBallPositions[this.playbackIndex].y;

        this.playbackIndex++;
      }

      this.leftPaddlePositions.push(this.leftPaddle.y);
      this.rightPaddlePositions.push(this.rightPaddle.y);
      this.ballPositions.push({
        x: this.ball.x,
        y: this.ball.y
      });
    }
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    this.memoryBall.setVisible(value);
    this.memoryLeftPaddle.setVisible(value);
    this.memoryRightPaddle.setVisible(value);
  }

  resetPlay() {
    super.resetPlay();

    this.playbackIndex = 0;

    this.playbackLeftPaddlePositions = [...this.leftPaddlePositions];
    this.playbackRightPaddlePositions = [...this.rightPaddlePositions];
    this.playbackBallPositions = [...this.ballPositions];

    this.leftPaddlePositions = [];
    this.rightPaddlePositions = [];
    this.ballPositions = [];
  }
}