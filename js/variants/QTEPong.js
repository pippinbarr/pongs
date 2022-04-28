class QTEPong extends Pong {
  constructor() {
    super({
      key: `QTE PONG`
    });
  }

  create() {
    super.create();

    this.qteState = `not-triggerd`; // not-triggered, triggered, success, failure
    this.qteTimer = undefined;
    this.qteText = this.add.text(this.width / 4, this.height / 2, ``, {
        font: "48px Commodore",
        color: "#fff",
        align: "center",
      })
      .setOrigin(0.5, 0.5);
    this.qteText.setVisible(false);

    this.qteKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(``);
    this.qteIndex = undefined;

    this.input.keyboard.on(`keydown`, this.handleQTEInput.bind(this));
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.qteTimer);
  }

  checkBall(ball) {
    if ((ball.x < 60 || ball.x > this.width - 60) && this.qteState === `not-triggered`) {
      this.triggerQTE();
    }

    super.checkBall(ball);
  }

  triggerQTE() {
    this.state = State.NONE;
    this.qteState = `triggered`;

    this.deactivate();

    if (this.ball.x < this.width / 2) {
      this.qteText.x = this.width / 4;
    } else if (this.ball.x > this.width / 2) {
      this.qteText.x = 3 * this.width / 4;
    }

    this.qteIndex = Math.floor(Math.random() * this.qteKeys.length);
    this.qteText.text = `(${this.qteKeys[this.qteIndex]})`;
    this.qteText.setVisible(true);

    this.qteTimer = setTimeout(() => {
      this.qteFailed();
    }, 1000);
  }



  resetPlay() {
    super.resetPlay();
    this.qteState = `not-triggered`;
  }

  handleInput() {
    super.handleInput();
  }

  handleQTEInput(event) {
    if (this.state === State.NONE && this.qteState === `triggered`) {
      clearTimeout(this.qteTimer);
      if (event.key.toUpperCase() === this.qteKeys[this.qteIndex]) {
        this.qteSucceeded();
      } else {
        this.qteFailed();
      }
    }
  }

  qteFailed() {
    this.qteText.setVisible(false);
    if (this.ball.x < this.width / 2) {
      if (this.ball.y < this.height / 2) {
        this.leftPaddle.y = PADDLE_HEIGHT / 2;;
      } else {
        this.leftPaddle.y = this.height - PADDLE_HEIGHT / 2;
      }
    } else {
      if (this.ball.y < this.height / 2) {
        this.rightPaddle.y = PADDLE_HEIGHT / 2;;
      } else {
        this.rightPaddle.y = this.height - PADDLE_HEIGHT / 2;
      }
    }

    this.state = State.PLAYING;
    this.activate()
  }

  qteSucceeded() {
    clearTimeout(this.qteTimer);
    this.qteText.setVisible(false);
    if (this.ball.x < this.width / 2) {
      this.leftPaddle.y = this.ball.y;
    } else {
      this.rightPaddle.y = this.ball.y;
    }
    this.state = State.PLAYING;
    this.activate();
    this.qteTimer = setTimeout(() => {
      this.resetTrigger();
    }, 1000);
  }

  resetTrigger() {
    this.qteState = `not-triggered`;
  }
}