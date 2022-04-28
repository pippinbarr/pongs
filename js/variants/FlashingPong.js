class FlashingPong extends Pong {
  constructor() {
    super({
      key: `FLASHING PONG`
    });
  }

  create() {
    super.create();

    this.bgColors = [0x000000, 0xffffff];
    this.currentBG = 0;

    this.instructionsText.text = "WARNING: INTENSE FLASHING LIGHTS!\n\n" + this.instructionsText.text;
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    if (value) {
      this.flipTimer = setInterval(() => {
        this.flipBackground();
      }, 20);
    }
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearInterval(this.flipTimer);
  }

  update() {
    super.update();
  }

  flipBackground() {
    if (this.state !== State.INSTRUCTIONS) {
      this.currentBG = 1 - this.currentBG;
      this.cameras.main.setBackgroundColor(this.bgColors[this.currentBG]);
    }
  }
}