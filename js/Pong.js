const PADDLE_WIDTH = 10;
const PADDLE_HEIGHT = 60;
const BALL_SIZE = 10;

class Pong extends Phaser.Scene {

  constructor(config) {
    super({
      key: `pong`
    });

    this.OVERRIDE_CREATE = false;
    this.OVERRIDE_UPDATE = false;
  }

  create() {
    this.width = this.game.canvas.width;
    this.height = this.game.canvas.height;

    this.instructionsString = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

AVOID MISSING BALL FOR HIGH SCORE

[SPACE] TO START
[ESCAPE] TO QUIT`;
    this.winnerString = `WINNER

`;

    this.resultString = `[SPACE] TO RESTART
[ESCAPE] TO EXIT`

    this.leftScore = 0;
    this.rightScore = 0;

    this.cameras.main.setBackgroundColor(0x000000);

    // Only used for METAPONG
    if (this.OVERRIDE_CREATE) return;

    // Paddles and ball

    this.leftPaddle = this.createRect(20, 220, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.rightPaddle = this.createRect(this.game.canvas.width - 20, 220, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.ball = this.createRect(200, 200, BALL_SIZE, BALL_SIZE);

    // Top and bottom (unseen) walls

    this.walls = this.physics.add.group();
    this.topWall = this.createRect(this.width / 2, -5, this.game.canvas.width, 10);
    this.bottomWall = this.createRect(this.width / 2, this.height + 5, this.game.canvas.width, 10);
    this.walls.add(this.topWall);
    this.walls.add(this.bottomWall);

    // That dotty line

    this.divider = this.physics.add.group();
    for (let i = 0; i < 24; i++) {
      let dot = this.createRect(this.width / 2, i * 20 + 10, 10, 10);
      this.divider.add(dot);
    }

    // Text

    this.leftScoreText = this.add.text(this.width / 2 - 200 - 50, 0, this.leftScore, {
      fontFamily: `Commodore`,
      fontSize: 84,
      fill: `#fff`,
      align: `left`
    });
    this.leftScoreLabel = this.add.text(this.width / 2 - 200 - 50, 0, `label`, {
      fontFamily: `Commodore`,
      fontSize: 18,
      fill: `#fff`,
      align: `left`
    });
    this.rightScoreText = this.add.text(this.width / 2 + 50, 0, this.rightScore, {
      fontFamily: `Commodore`,
      fontSize: 84,
      fill: `#fff`,
      align: `right`
    });
    this.rightScoreLabel = this.add.text(this.width / 2 + 50, 0, `label`, {
      fontFamily: `Commodore`,
      fontSize: 18,
      fill: `#fff`,
      align: `right`
    });
    this.titleText = this.add.text(64, 64, `PONG`, {
      fontFamily: `Commodore`,
      fontSize: 32,
      fill: `#fff`,
      align: `left`
    });
    this.instructionText = this.add.text(64, 128, this.instructionsString, {
      fontFamily: `Commodore`,
      fontSize: 16,
      fill: `#fff`,
      align: `left`
    });
    this.winnerText = this.add.text(0, 0, this.winnerString, {
      fontFamily: `Commodore`,
      fontSize: 32,
      fill: `#fff`,
      align: `center`
    });
    this.resultText = this.add.text(0, 0, this.resultString, {
      fontFamily: `Commodore`,
      fontSize: 18,
      fill: `#fff`,
      align: `center`
    });

    // Frames and BGs

    this.winnerBlackFrame = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 20, this.height / 2 - 0)
      .setTint(0xFF0000);

    this.winnerWhiteFrame = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 30, this.height / 2 - 10)
      .setTint(0xFFFFFF);

    this.winnerBG = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 40, this.height / 2 - 20)
      .setTint(0xFF0000);

    this.leftPaddle.visible = false;
    this.rightPaddle.visible = false;
    this.ball.visible = false;
    this.walls.visible = false;
    this.divider.setVisible(false);
    this.leftScoreText.visible = false;
    this.rightScoreText.visible = false;
    this.leftScoreLabel.visible = false;
    this.rightScoreLabel.visible = false;
    this.winnerText.visible = false;
    this.resultText.visible = false;
    this.winnerBG.visible = false;
    this.winnerWhiteFrame.visible = false;
    this.winnerBlackFrame.visible = false;

    // And off we go...

    this.state = `INSTRUCTIONS`;
  }

  update(time, delta) {
    if (this.OVERRIDE_UPDATE) return;

    // this.handleInput();

    if (this.state === `PLAYING`) {
      // this.doCollisions();
      // this.checkBall(this.ball);
      // this.checkGameOver();
    }
  }

  doCollisions() {

  }

  createRect(x, y, w, h) {
    let rect = this.physics.add.image(x, y, `particle`);
    rect.setScale(w, h);
    rect.immovable = true;
    return rect;
  }
}