class ViennesePong extends Pong {
  constructor() {
    super({
      key: `VIENNESE PONG`
    });
  }

  create() {
    super.create();

    this.question = "" +
      "ARE YOU CURRENTLY IN VIENNA?\n\n" +
      "(Y)ES    OR    (N)O";

    this.denied = "" +
      "THEN YOU CANNOT PLAY VIENNESE PONG\n\n" +
      "PRESS [ESCAPE] TO EXIT";

    this.vienneseText = this.add.text(64, 128, this.question, {
      font: "16px Commodore",
      color: "#fff",
      align: "left",
    });

    this.state = State.NONE;
    this.substate = `question`; // denied

    this.keys.y = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.Y);
    this.keys.n = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.N);

    this.setInstructionsVisible(false);
  }

  update() {
    super.update();

    if (this.state === State.NONE) {
      if (this.substate === `question`) {
        if (this.keys.y.isDown) {
          this.state = State.INSTRUCTIONS;
          this.vienneseText.setVisible(false);
          this.setInstructionsVisible(true);
        } else if (this.keys.n.isDown) {
          this.substate = `denied`;
          this.vienneseText.text = this.denied;
        }
      }
    }
  }
}