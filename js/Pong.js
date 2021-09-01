const PADDLE_WIDTH = 10;
const PADDLE_HEIGHT = 60;
const PADDLE_SPEED = 350;

const BALL_SIZE = 10;
const BALL_SPEED = 350;
const BALL_LAUNCH_DELAY = 1000;

const GAME_OVER_SCORE = 2;

class Pong extends Phaser.Scene {

  constructor(config) {
    super({
      key: config && config.key ? config.key : `pong`
    });

    this.OVERRIDE_CREATE = false;
    this.OVERRIDE_UPDATE = false;
    this.titleString = `PONG`;
  }

  create() {
    this.width = this.game.canvas.width;
    this.height = this.game.canvas.height;

    this.instructionsString = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

AVOID MISSING BALL FOR HIGH SCORE

[SPACE] TO START
[ESCAPE] TO QUIT`;
    this.winnerString = `WINNER`;

    this.resultString = `[SPACE] TO RESTART
[ESCAPE] TO EXIT`

    this.leftScore = 0;
    this.rightScore = 0;

    this.cameras.main.setBackgroundColor(0x000000);

    // Only used for METAPONG
    if (this.OVERRIDE_CREATE) return;

    // Paddles and ball

    this.leftPaddle = this.createRect(20, 220, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.leftPaddle.setCollideWorldBounds(true, 0, 0);

    this.rightPaddle = this.createRect(this.game.canvas.width - 20, 220, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.rightPaddle.setCollideWorldBounds(true, 0, 0);

    this.ball = this.createRect(this.width / 2, this.height / 2, BALL_SIZE, BALL_SIZE, false);
    this.ball.setBounce(1);

    // Top and bottom (unseen) walls

    this.walls = this.physics.add.group();
    this.topWall = this.createRect(this.width / 2, -5, this.game.canvas.width, 10);
    this.bottomWall = this.createRect(this.width / 2, this.height + 5, this.game.canvas.width, 10);
    this.walls.add(this.topWall);
    this.walls.add(this.bottomWall);
    this.topWall.setImmovable(true);
    this.bottomWall.setImmovable(true);

    // That dotty line

    this.divider = this.physics.add.group();
    for (let i = 0; i < 24; i++) {
      let dot = this.createRect(this.width / 2, i * 20 + 10, 10, 10, false);
      this.divider.add(dot);
    }

    // Sound

    this.paddleSFX = this.sound.add(`paddle`);
    this.wallSFX = this.sound.add(`wall`);
    this.pointSFX = this.sound.add(`point`);

    // Text

    this.leftScoreText = this.add.text(this.width / 2 - 50, 0, this.leftScore, {
        fontFamily: `Commodore`,
        fontSize: 84,
        fill: `#fff`,
        align: `right`
      })
      .setOrigin(1, 0);
    this.leftScoreLabel = this.add.text(this.width / 2 - 50, 80, ``, {
        fontFamily: `Commodore`,
        fontSize: 18,
        fill: `#fff`,
        align: `right`
      })
      .setOrigin(1, 0);
    this.rightScoreText = this.add.text(this.width / 2 + 50, 0, this.rightScore, {
      fontFamily: `Commodore`,
      fontSize: 84,
      fill: `#fff`,
      align: `left`
    });
    this.rightScoreLabel = this.add.text(this.width / 2 + 50, 80, ``, {
      fontFamily: `Commodore`,
      fontSize: 18,
      fill: `#fff`,
      align: `left`
    });
    this.titleText = this.add.text(64, 64, this.titleString, {
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

    // Frames and BGs
    this.winnerGraphics = this.add.container();

    this.winnerBlackFrame = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 20, this.height / 2 - 0)
      .setTint(0x000000);
    this.winnerGraphics.add(this.winnerBlackFrame);

    this.winnerWhiteFrame = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 30, this.height / 2 - 10)
      .setTint(0xFFFFFF);
    this.winnerGraphics.add(this.winnerWhiteFrame);

    this.winnerBG = this.add.image(this.width / 2, this.height / 2, `particle`)
      .setScale(this.width / 2 - 40, this.height / 2 - 20)
      .setTint(0x000000);
    this.winnerGraphics.add(this.winnerBG);

    this.resultText = this.add.text(this.width / 2, 250, this.resultString, {
        fontFamily: `Commodore`,
        fontSize: 18,
        fill: `#fff`,
        align: `center`
      })
      .setOrigin(0.5, 0.5);
    this.winnerGraphics.add(this.resultText);

    this.winnerText = this.add.text(this.width / 2, 200, this.winnerString, {
        fontFamily: `Commodore`,
        fontSize: 32,
        fill: `#fff`,
        align: `center`
      })
      .setOrigin(0.5, 0.5);
    this.winnerGraphics.add(this.winnerText);

    this.instructionGraphics = this.add.group();
    this.instructionGraphics.addMultiple([
      this.instructionText, this.titleText
    ]);

    this.playGraphics = this.add.group();
    this.playGraphics.addMultiple([
      this.topWall, this.bottomWall, this.leftPaddle,
      this.rightPaddle, this.ball, this.leftScoreText,
      this.rightScoreText, this.leftScoreLabel, this.rightScoreLabel,
      ...this.divider.getChildren()
    ]);

    // Input
    this.esc = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.ESC);
    this.space = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.w = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.W);
    this.s = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.S);
    this.up = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.UP);
    this.down = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.DOWN);

    // And off we go...

    this.state = `INSTRUCTIONS`;
    this.instructionGraphics.setVisible(true);
    this.playGraphics.setVisible(false);
    this.winnerGraphics.setVisible(false);
  }


  update(time, delta) {
    if (this.OVERRIDE_UPDATE) return;

    this.handleInput();

    if (this.state === `PLAYING`) {
      this.doCollisions();
      this.checkBall(this.ball);
      this.checkGameOver();
    }
  }

  handleInput() {
    this.handleEscapeInput();

    this.handleSpaceInput();

    this.handlePaddleInput();
  }

  handleEscapeInput() {
    if (Phaser.Input.Keyboard.JustDown(this.esc)) {
      this.scene.start(`menu`);
    }
  }

  handleSpaceInput() {
    if (Phaser.Input.Keyboard.JustDown(this.space)) {
      if (this.state === `INSTRUCTIONS`) {
        this.lastPoint = Math.random() < 0.5 ? `PLAYER 1` : `PLAYER 2`;
        this.setScores(0, 0);
        this.resetPlay();
        this.showPlay();
      } else if (this.state === `GAME OVER`) {
        this.winnerGraphics.setVisible(false);
        this.showInstructions();
      }
    }
  }

  handlePaddleInput() {
    if (this.state !== `PLAYING`) {
      return;
    }

    this.handlePaddle(this.leftPaddle, this.w, this.s);
    this.handlePaddle(this.rightPaddle, this.up, this.down);
  }

  handlePaddle(paddle, up, down) {
    if (up.isDown && paddle.body.velocity.y >= 0) {
      paddle.setVelocityY(-PADDLE_SPEED);
    } else if (down.isDown && paddle.body.velocity.y <= 0) {
      paddle.setVelocityY(PADDLE_SPEED);
    } else {
      paddle.setVelocityY(0);
    }
  }

  resetPlay() {
    this.state = `PLAYING`;
    this.lastHit = `NONE`;
    this.activate();
    this.resetBall();
    setTimeout(() => {
      this.launchBall();
    }, BALL_LAUNCH_DELAY);
  }

  resetBall() {
    this.ball.setPosition(this.width / 2, this.height / 2);
    this.ball.setVelocity(0, 0);
  }

  launchBall() {
    this.state = `PLAYING`;
    this.wallSFX.play();
    this.setLaunchVelocity(this.ball);
  }

  setLaunchVelocity() {
    let ballDirection;
    if (this.lastPoint === `PLAYER 1`) {
      ballDirection = Math.random() * Math.PI / 4 - Math.PI / 8;
    } else if (this.lastPoint === `PLAYER 2`) {
      ballDirection = Math.random() * Math.PI / 4 + Math.PI - Math.PI / 8;
    }

    this.ball.setVelocity(Math.cos(ballDirection) * BALL_SPEED, Math.sin(ballDirection) * BALL_SPEED);
  }

  showPlay() {
    this.playGraphics.setVisible(true);
    this.instructionGraphics.setVisible(false);
    this.state = `PLAYING`;
  }

  showInstructions() {
    this.playGraphics.setVisible(false);
    this.instructionGraphics.setVisible(true);
    this.state = `INSTRUCTIONS`;
  }

  swapTitleAndPlayVisibles() {
    this.playGraphics.setVisible
  }

  setScores(left, right) {
    this.leftScore = left;
    this.rightScore = right;
    this.leftScoreText.text = this.leftScore;
    this.rightScoreText.text = this.rightScore;
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit.bind(this));
    this.physics.collide(this.leftPaddle, this.ball, this.paddleHit.bind(this));
    this.physics.collide(this.rightPaddle, this.ball, this.paddleHit.bind(this));
  }

  wallHit() {
    this.wallSFX.play();
  }

  paddleHit(paddle, ball) {
    this.paddleSFX.play();

    this.lastHit = paddle.x < this.width / 2 ? `LEFT` : `RIGHT`;

    ball.body.velocity.y += paddle.body.velocity.y;
  }

  checkBall(ball) {
    let point = false;

    if (ball.x - ball.width / 2 < 0) {
      point = true;
      this.lastPoint = `PLAYER 2`;
      this.rightScore++;
    } else if (ball.x + ball.width / 2 > this.width) {
      point = true;
      this.lastPoint = `PLAYER 1`
      this.leftScore++;
    }

    this.setScores(this.leftScore, this.rightScore);

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  gameIsOver() {
    return (this.leftScore >= GAME_OVER_SCORE && this.leftScore - 2 >= this.rightScore) ||
      (this.rightScore >= GAME_OVER_SCORE && this.rightScore - 2 >= this.leftScore);
  }

  postPoint() {
    this.pointSFX.play();
    this.resetPlay();
  }

  checkGameOver() {
    if (this.gameIsOver()) {
      this.pointSFX.play();
      this.gameOver();
    }
  }

  gameOver() {
    this.state = `GAME OVER`;

    this.leftPaddle.setVelocity(0, 0);
    this.rightPaddle.setVelocity(0, 0);
    this.ball.setVelocity(0, 0);
    this.deactivate();

    this.winnerGraphics.setVisible(true);

    if (this.leftScore > this.rightScore) {
      this.winnerGraphics.setPosition(-160, 0);
    } else if (this.rightScore > this.leftScore) {
      this.winnerGraphics.setPosition(160, 0);
    }

    this.ball.visible = false;
  }

  activate() {
    this.ball.active = true;
    this.leftPaddle.active = true;
    this.rightPaddle.active = true;
  }

  deactivate() {
    this.ball.active = false;
    this.leftPaddle.active = false;
    this.rightPaddle.active = false;
  }

  createRect(x, y, w, h, immovable = true) {
    return this.physics.add.image(x, y, `particle`)
      .setScale(w, h)
      .setImmovable(immovable);
  }
}