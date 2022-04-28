class TwoDPong extends Pong {
  constructor() {
    super({
      key: `2D PONG`
    });
  }

  create() {
    super.create();

    this.instructionsText.text = "" +
      "PLAYER 1: [W] / [A] / [S] / [D] TO MOVE\n\n" +
      "PLAYER 2: [UP] / [DOWN] / [LEFT] / [RIGHT] TO MOVE\n\n" +
      "AVOID MISSING BALL FOR HIGH SCORE\n\n" +
      "[SPACE] TO START\n[ESCAPE] TO QUIT";

    this.keys.left = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.LEFT);
    this.keys.right = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.RIGHT);
    this.keys.a = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.A);
    this.keys.d = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.D);
  }

  doCollisions() {
    super.doCollisions();

    // This works but it's not amazing
    this.leftPaddle.setImmovable(false);
    this.rightPaddle.setImmovable(false);
    this.physics.collide(this.leftPaddle, this.rightPaddle, this.undoMove, null, this);
    this.leftPaddle.setImmovable(true);
    this.rightPaddle.setImmovable(true);
  }

  undoMove(paddle1, paddle2) {
    // This is pretty bad but it seems to work sort of okay-ish
    paddle1.x -= paddle1.body.velocity.x / 60;
    paddle1.y -= paddle1.body.velocity.y / 60;

    paddle2.x -= paddle2.body.velocity.x / 60;
    paddle2.y -= paddle2.body.velocity.y / 60;
  }

  handlePaddleInput() {
    this.handleSpecificPaddleInput(this.rightPaddle, this.keys.up, this.keys.down, this.keys.left, this.keys.right);
    this.handleSpecificPaddleInput(this.leftPaddle, this.keys.w, this.keys.s, this.keys.a, this.keys.d);
  }

  handleSpecificPaddleInput(paddle, up, down, left, right) {
    super.handleSpecificPaddleInput(paddle, up, down);

    if (left.isDown) {
      paddle.body.velocity.x = -PADDLE_SPEED / 2;
    } else if (right.isDown) {
      paddle.body.velocity.x = PADDLE_SPEED / 2;
    }
    if (paddle.x < PADDLE_INSET) paddle.x = PADDLE_INSET;
    if (paddle.x > this.width - PADDLE_INSET) paddle.x = this.width - PADDLE_INSET;
  }
}