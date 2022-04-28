class CountdownPong extends Pong {
  constructor() {
    super({
      key: `COUNTDOWN PONG`
    });
  }

  create() {
    this.countdownText = this.add.text(-200, -200, ``, {
        font: "18px Commodore",
        color: "#fff",
        align: "center",
      })
      .setOrigin(0.5, 0.5);

    super.create();

    this.COUNTDOWN_MINIMUM = 5;
    this.COUNTDOWN_EXTRA = 5;

    this.count = 0;
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);
    console.log(this.countdownText);
    this.countdownText.setVisible(value);
  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      this.countdownText.text = this.count;
      this.countdownText.x = this.ball.body.x;
      this.countdownText.y = this.ball.body.y - this.ball.body.height;
    }
  }

  decrementCounter() {
    this.count--;
    if (this.count === 0) {
      this.startExplosion();
    }
  }

  paddleHit(paddle, ball) {
    super.paddleHit(paddle, ball);
    this.decrementCounter();
  }

  wallHit(ball, wall) {
    super.wallHit(ball, wall);
    this.decrementCounter();
  }

  startExplosion() {
    this.state = State.NONE;
    this.leftPaddle.setVelocity(0, 0);
    this.rightPaddle.setVelocity(0, 0);
    if (this.ball.x < this.width / 2) {
      this.rightScore++;
    } else {
      this.leftScore++;
    }
    this.setScores();

    this.ball.setVelocity(0, 0);

    this.explode();
  }

  resetBall(ball) {
    super.resetBall(ball);
    this.countdownText.x = this.ball.body.x;
    this.countdownText.y = this.ball.body.y - this.ball.body.height;
    this.count = Math.floor(Math.random() * this.COUNTDOWN_EXTRA) + this.COUNTDOWN_MINIMUM;
    this.countdownText.setVisible(false);
  }

  explode() {
    this.countdownText.setVisible(false);
    this.ball.setVisible(false);

    let explosion = this.add.particles('particle')
      .createEmitter({
        x: this.ball.x,
        y: this.ball.y,
        quantity: 100,
        speed: {
          min: -800,
          max: 800
        },
        angle: {
          min: 0,
          max: 360
        },
        // blendMode: 'SCREEN',
        //active: false,
        lifespan: 500,
        // gravityY: 800
      });
    explosion.explode();

    this.timer = setTimeout(() => {
      this.postExplosion()
    }, 1000);
  }

  postExplosion() {
    this.resetPlay();
  }

  resetPlay() {
    super.resetPlay();

    this.ball.setVisible(true);
    // this.countdownText.setVisible(true);
  }

  launchBall() {
    super.launchBall();
    this.countdownText.setVisible(true);
  }
}