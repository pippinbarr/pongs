class SwappingPong extends Pong {
  constructor() {
    super({
      key: `SWAPPING PONG`
    });
  }

  create() {
    super.create();

    this.flippedControls = false;
    this.flipTimer = setTimeout(() => {
      this.flipControls();
    }, Math.random() * 5000 + 1000);
  }

  flipControls() {
    this.flippedControls = !this.flippedControls;
    this.flipTimer = setTimeout(() => {
      this.flipControls();
    }, Math.random() * 5000 + 1000);
  }

  handlePaddleInput() {
    if (!this.flippedControls) {
      super.handlePaddleInput();
    } else {
      this.handleSpecificPaddleInput(this.leftPaddle, this.keys.up, this.keys.down);
      this.handleSpecificPaddleInput(this.rightPaddle, this.keys.w, this.keys.s);
    }
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearTimeout(this.flipTimer);
  }

}