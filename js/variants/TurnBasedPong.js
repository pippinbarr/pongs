class TurnBasedPong extends Pong {
  constructor() {
    super({
      key: `TURN-BASED PONG`
    });
  }

  create() {
    this.createTurnTexts();

    super.create();

    this.turnTime = 150; // Length of a turn in terms of motion?

    this.keys.a = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.A);
    this.keys.right = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.RIGHT);

    this.turnTimer = undefined;

    this.substate = `selecting`; // selected
  }

  update() {
    super.update();

    if (this.state === State.NONE) {
      this.handlePaddleInput();
    }

    this.constrainPaddle(this.leftPaddle);
    this.constrainPaddle(this.rightPaddle);
  }

  constrainPaddle(paddle) {
    if (paddle.y < paddle.body.height / 2) paddle.y = paddle.body.height / 2;
    if (paddle.y > this.height - paddle.body.height / 2) paddle.y = this.height - paddle.body.height / 2;
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);
    if (!value) {
      this.leftTurnText.setVisible(false);
      this.rightTurnText.setVisible(false);
    }
  }

  gameOver() {
    super.gameOver();

    clearTimeout(this.turnTimer);
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.turnTimer);
  }

  resetPlay() {
    super.resetPlay();

    clearTimeout(this.turnTimer);

    this.leftPaddle.setVelocityY(0);
    this.rightPaddle.setVelocityY(0);


    this.leftTurnText.text = this.leftTurnString;
    this.rightTurnText.text = this.rightTurnString;

    this.leftTurnText.setVisible(false);
    this.rightTurnText.setVisible(false);
  }

  launchBall() {
    super.launchBall();

    this.turnTimer = setTimeout(() => {
      this.selectMode();
    }, this.turnTime);
  }

  selectMode() {
    this.state = State.NONE;
    this.substate = `selecting`;

    this.deactivate();

    this.leftPaddle.next = undefined;
    this.rightPaddle.next = undefined;

    this.leftTurnText
      .setText(this.leftTurnString)
      .setVisible(true);
    this.rightTurnText
      .setText(this.rightTurnString)
      .setVisible(true);
  }

  handlePaddleInput() {
    if (this.state === State.NONE) {
      if (this.substate === `selecting`) {
        this.handleSpecificPaddleInput(this.leftPaddle, this.keys.w, this.keys.s, this.keys.a, this.leftTurnText);
        this.handleSpecificPaddleInput(this.rightPaddle, this.keys.up, this.keys.down, this.keys.right, this.rightTurnText);
      }

      if (this.substate === `selecting` && this.leftPaddle.next !== undefined && this.rightPaddle.next !== undefined) {
        // Ready to move on
        this.leftPaddle.next = undefined;
        this.rightPaddle.next = undefined;
        this.substate = `selected`;

        this.turnTimer = setTimeout(() => {
          this.playMode();
        }, 1000);
      }
    }
  }

  handleSpecificPaddleInput(paddle, up, down, skip, turnText) {

    if (paddle.next === undefined) {
      if (up.isDown) {
        paddle.next = `up`;
        paddle.setVelocityY(-PADDLE_SPEED);
      } else if (down.isDown) {
        paddle.next = `down`;
        paddle.setVelocityY(PADDLE_SPEED);
      } else if (skip.isDown) {
        paddle.next = `skip`;
        paddle.setVelocityY(0);
      } else {
        paddle.setVelocityY(0);
      }
    }

    if (paddle.next) {
      turnText.text = this.moveSelectedString;
    }
  }

  playMode() {
    this.state = State.PLAYING;
    this.substate = undefined;

    this.activate();

    this.leftTurnText.setVisible(false);
    this.rightTurnText.setVisible(false);

    this.turnTimer = setTimeout(() => {
      this.selectMode();
    }, this.turnTime);
  }

  createTurnTexts() {
    this.leftTurnString = "" +
      "SELECT YOUR MOVE\n\n" +
      "[W] = UP\n" +
      "[S] = DOWN\n" +
      "[A] = SKIP TURN";

    this.rightTurnString = "" +
      "SELECT YOUR MOVE\n\n" +
      "[UP] = UP\n" +
      "[DOWN] = DOWN\n" +
      "[RIGHT] = SKIP TURN";

    this.leftTurnText = this.add.text(this.width / 4, this.height / 2, this.leftTurnString, {
        font: "18px Commodore",
        color: "#fff",
        align: "center",
      })
      .setOrigin(0.5, 0.5)
      .setVisible(false)

    this.moveSelectedString = `MOVE SELECTED`;

    this.rightTurnText = this.add.text(3 * this.width / 4, this.height / 2, this.rightTurnString, {
        font: "18px Commodore",
        color: "#fff",
        align: "center",
      })
      .setOrigin(0.5, 0.5)
      .setVisible(false);
  }
}