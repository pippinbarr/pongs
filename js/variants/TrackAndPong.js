class TrackAndPong extends Pong {
  constructor() {
    super({
      key: `TRACK AND PONG`
    });
  }

  create() {
    super.create();

    this.instructionsText.text = "" +
      "PLAYER 1: RAPIDLY ALTERNATE [W] AND [S] TO MOVE\n\n" +
      "PLAYER 2: RAPIDLY ALTERNATE [UP] AND [DOWN] TO MOVE\n\n" +
      "AVOID MISSING BALL FOR HIGH SCORE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.keys.up.next = true;
    this.keys.up.lastPress = Date.now() * 2;
    this.keys.down.lastPress = Date.now() * 2;
    this.keys.w.next = true;
    this.keys.w.lastPress = Date.now() * 2;
    this.keys.s.lastPress = Date.now() * 2;

  }

  update() {
    super.update();

    if (this.state === State.PLAYING) {
      this.updateAI(this.leftPaddle, this.keys.up, this.keys.down);
      this.updateAI(this.rightPaddle, this.keys.w, this.keys.s);
    }
  }

  updateAI(paddle, up, down) {
    paddle.setVelocity(0, 0);

    let pressDiff = Math.min(Math.abs(Date.now() - down.lastPress), Math.abs(Date.now() - up.lastPress));
    let active = pressDiff < 100;

    if (up.next && up.isDown && !down.isDown) {
      up.lastPress = Date.now();
      up.next = false;
      down.next = true;
      active = true;
    } else if (down.next && down.isDown && !up.isDown) {
      down.lastPress = Date.now();
      down.next = false;
      up.next = true;
      active = true;
    }

    if (!active) return;

    let dx = paddle.x - this.ball.x;
    let vx = this.ball.body.velocity.x;

    // Paddle is to the left and ball is moving left
    // This is WRONG right now
    if (dx < 0 && vx < 0 || dx > 0 && vx > 0) {
      // It's coming
      if (paddle.y < this.ball.y - 10) {
        paddle.setVelocityY(PADDLE_SPEED);
      } else if (paddle.y > this.ball.y + 10) {
        paddle.setVelocityY(-PADDLE_SPEED);
      }
    } else {
      // It's not coming, move to centre
      if (paddle.y < this.height / 2 - 10) {
        paddle.setVelocityY(PADDLE_SPEED);
      } else if (paddle.y > this.height / 2 + 10) {
        paddle.setVelocityY(-PADDLE_SPEED);
      }
    }
  }

}