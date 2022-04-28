/**

* 2D paddle collisions are pretty janky

*/

const State = {
  INSTRUCTIONS: 0,
  SERVING: 1,
  PLAYING: 2,
  AFTER_POINT: 3,
  GAMEOVER: 4,
  NONE: 5 // To allow variants to setup a sub state system that won't run anything
};

const Player = {
  ONE: `left`,
  TWO: `right`,
  NONE: `none`
};

const ZOOM = 1;

const PADDLE_WIDTH = 10;
const PADDLE_HEIGHT = 60;
const PADDLE_START_Y = 220;
const PADDLE_SPEED = 350;
const PADDLE_INSET = 20;
const PADDLE_BALL_INFLUENCE_FACTOR = 0.3;

const BALL_SIZE = 10;
const BALL_SPEED = 350;
const BALL_LAUNCH_DELAY = 1000;

const GAME_OVER_SCORE = 11;

class Pong extends Phaser.Scene {

  constructor(config) {
    super({
      key: config && config.key ? config.key : `STANDARD PONG`
    });

    // Useful to have abbreviated
    this.width = WIDTH;
    this.height = HEIGHT;

    this.OVERRIDE_CREATE = false;
    this.OVERRIDE_UPDATE = false;
  }

  create() {

    if (this.OVERRIDE_CREATE) {
      return;
    }

    // Background color
    this.cameras.main.setBackgroundColor(0x000000);


    this.ballLaunchDelay = BALL_LAUNCH_DELAY;

    this.leftScore = 0;
    this.rightScore = 0;

    this.instructionsString = `PLAYER 1: [W] / [S] TO MOVE

PLAYER 2: [UP] / [DOWN] TO MOVE

AVOID MISSING BALL FOR HIGH SCORE

[SPACE] TO START\n[ESCAPE] TO QUIT`;

    this.winnerString = `WINNER
`;
    this.resultString = `
[SPACE] TO RESTART
[ESCAPE] TO EXIT`;

    this.createPaddles();
    this.createBall();
    this.createWalls();
    this.createDivider();

    this.createTexts();

    this.setInstructionsVisible(true);
    this.setPlayVisible(false);
    this.setGameOverVisible(false);

    this.timer = undefined; // Placeholder for when we need a timer

    this.wallSFX = this.sound.add(`wall`);
    this.paddleSFX = this.sound.add(`paddle`);
    this.pointSFX = this.sound.add(`point`);

    this.ballSpeed = BALL_SPEED;
    this.paddleSpeed = PADDLE_SPEED
    this.paddleInfluence = PADDLE_BALL_INFLUENCE_FACTOR;

    this.lastPoint = Math.floor(Math.random() * 2);
    this.lastHit = Player.NONE;

    this.keys = {};
    this.keys.esc = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.ESC);
    this.keys.space = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.keys.up = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.UP);
    this.keys.down = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.DOWN);
    this.keys.w = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.W);
    this.keys.s = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.S);

    this.state = State.INSTRUCTIONS;
  }

  update() {
    if (this.OVERRIDE_UPDATE) return;

    switch (this.state) {
    case State.INSTRUCTIONS:
      this.handleInput();
      break;

    case State.SERVING:
      this.handleInput();
      break;

    case State.PLAYING:
      this.handleInput();

      this.doCollisions();
      this.checkBall(this.ball);
      this.checkGameOver();
      break;

    case State.AFTER_POINT:
      break;

    case State.GAMEOVER:
      this.handleInput();
      break;

    case State.NONE:
      this.handleInput();
      break;
    }
  }

  clearTimeouts() {
    clearTimeout(this.timer);
  }

  handleInput() {
    // Handle escape for any state
    if (this.keys.esc.isDown) {
      this.clearTimeouts();
      this.scene.start(`menu`); // For now, until there's a menu
      return;
    }

    switch (this.state) {
    case State.INSTRUCTIONS:
      if (this.keys.space.isDown) {
        this.setInstructionsVisible(false);
        this.setPlayVisible(true);
        this.setScores(0, 0);
        this.resetPlay();
      }
      break;

    case State.SERVING:
      this.handlePaddleInput();
      break;

    case State.PLAYING:
      this.handlePaddleInput();
      break;

    case State.GAMEOVER:
      if (this.keys.space.isDown) {
        this.setGameOverVisible(false);
        this.setPlayVisible(true);
        this.setScores(0, 0);
        this.resetPlay();
      }
      break;
    }
  }

  handlePaddleInput() {
    this.handleSpecificPaddleInput(this.rightPaddle, this.keys.up, this.keys.down);
    this.handleSpecificPaddleInput(this.leftPaddle, this.keys.w, this.keys.s);
  }

  handleSpecificPaddleInput(paddle, up, down) {
    paddle.setVelocity(0, 0);

    if (up.isDown && paddle.y > paddle.body.height / 2) {
      paddle.setVelocityY(-PADDLE_SPEED);
    } else if (down.isDown && paddle.y < this.height - paddle.body.height / 2) {
      paddle.setVelocityY(PADDLE_SPEED);
    }
    if (paddle.y < paddle.body.height / 2) paddle.y = paddle.body.height / 2;
    if (paddle.y > this.height - paddle.body.height / 2) paddle.y = this.height - paddle.body.height / 2;
  }

  setInstructionsVisible(value) {
    this.instructionsText.setVisible(value);
    this.titleText.setVisible(value);
  }

  setPlayVisible(value) {
    this.divider.setVisible(value);
    this.leftPaddle.setVisible(value);
    this.rightPaddle.setVisible(value);
    this.scoreInfo.setVisible(value);
    this.ball.setVisible(value);

    if (value) {
      this.resetBall(this.ball);
      this.resetPaddles();
    }
  }

  resetPlay() {
    clearTimeout(this.timer);

    this.activate();

    this.resetBall(this.ball);
    this.leftPaddle.setVelocity(0, 0);
    this.rightPaddle.setVelocity(0, 0);

    this.state = State.SERVING;
    this.lastHit = Player.NONE;

    this.timer = setTimeout(() => {
      this.launchBall();
    }, this.ballLaunchDelay);
  }

  activate() {
    // return;
    this.physics.world.resume();

    this.ball.setActive(true);
    this.leftPaddle.setActive(true);
    this.rightPaddle.setActive(true);
  }

  deactivate() {
    // return;
    this.ball.setActive(false);
    this.leftPaddle.setActive(false);
    this.rightPaddle.setActive(false);

    this.physics.world.pause();
  }

  resetBall(ball) {
    // OKAY WELL THE PROBLEM IS HERE.
    // IF I RESET BODY POSITION IT'S ACCURATE TO THE CENTER
    // BUT LEADS TO A DOUBLE COUNTING OF POINTS
    // IF I RESET SPRITE POSITION IT DOESN'T DOUBLE COUNT
    // BUT IT TAKES PREVIOUS PHYSICS STEP INTO ACCOUNT OR SOMETHING
    ball.body.position.x = this.width / 2 - ball.body.width / 2;
    ball.body.position.y = this.height / 2 - ball.body.height / 2;

    ball.setAcceleration(0, 0);
    ball.setVelocity(0, 0);
    // ball.x = this.width / 2;
    // ball.y = this.height / 2;
    // ball.update();
  }

  resetPaddles() {
    this.leftPaddle.setVelocity(0, 0);
    this.leftPaddle.setAcceleration(0, 0);
    this.leftPaddle.setPosition(PADDLE_INSET, this.height / 2);

    this.rightPaddle.setVelocity(0, 0);
    this.rightPaddle.setAcceleration(0, 0);
    this.rightPaddle.setPosition(this.width - PADDLE_INSET, this.height / 2);
  }

  launchBall() {
    this.state = State.PLAYING;

    this.wallSFX.play();

    this.setLaunchVelocity(this.ball);
  }

  setLaunchVelocity(ball) {
    let ballDirection = 0;
    if (this.lastPoint === Player.TWO) {
      ballDirection = (Math.random() * Math.PI / 4) - Math.PI / 8;
    } else if (this.lastPoint === Player.ONE) {
      ballDirection = (Math.random() * Math.PI / 4) + Math.PI - Math.PI / 8;
    } else {
      ballDirection = (Math.random() * Math.PI / 4) + Math.PI - Math.PI / 8;
      ballDirection += Math.random() < 0.5 ? 0 : Math.PI;
    }

    let vx = Math.cos(ballDirection) * this.ballSpeed;
    let vy = Math.sin(ballDirection) * this.ballSpeed;

    ball.setVelocity(vx, vy);
  }

  setGameOverVisible(value) {
    this.winnerInfo.setVisible(value);
  }

  setScores(left = this.leftScore, right = this.rightScore) {
    this.leftScore = left;
    this.leftScoreText.setText(this.leftScore);
    this.rightScore = right;
    this.rightScoreText.setText(this.rightScore);
  }

  doCollisions() {
    this.physics.collide(this.ball, this.walls, this.wallHit, null, this);
    this.physics.collide(this.leftPaddle, this.ball, this.paddleHit, null, this);
    this.physics.collide(this.rightPaddle, this.ball, this.paddleHit, null, this);
  }

  wallHit(ball, wall) {
    this.wallSFX.play();
  }

  paddleHit(paddle, ball) {
    this.paddleSFX.play();

    if (paddle.x > this.width / 2)
      this.lastHit = Player.TWO;
    else if (paddle.x < this.width / 2)
      this.lastHit = Player.ONE;

    // let ballDirection = Math.atan2(ball.body.velocity.y, ball.body.velocity.x);

    ball.body.velocity.y += paddle.body.velocity.y;

    if (ball.x + ball.width > paddle.x && ball.x < paddle.x + paddle.width) {
      if (ball.body.velocity.y < 0 && ball.body.velocity.y > paddle.body.velocity.y) {
        ball.body.velocity.y += (paddle.body.velocity.y - ball.body.velocity.y - 10);
      } else if (ball.body.velocity.y > 0 && ball.body.velocity.y < paddle.body.velocity.y) {
        ball.body.velocity.y += (paddle.body.velocity.y - ball.body.velocity.y + 10);
      }
    }
  }

  checkBall(ball) {
    let point = false;

    // Check if the ball has gone off the screen
    if (ball.body.x + ball.body.width / 2 < 0) {
      this.rightScore++;
      this.lastPoint = Player.TWO;
      point = true;
    } else if (ball.body.x - ball.body.width / 2 > this.width) {
      this.leftScore++;
      this.lastPoint = Player.ONE;
      point = true;
    }

    this.setScores();

    if (point && !this.gameIsOver()) {
      this.postPoint();
    } else if (this.gameIsOver()) {
      this.gameOver();
    }
  }

  gameIsOver() {
    return (this.leftScore >= GAME_OVER_SCORE && this.leftScore - 2 >= this.rightScore) ||
      (this.rightScore >= GAME_OVER_SCORE && this.rightScore - 2 >= this.leftScore)
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
    this.state = State.GAMEOVER;

    this.clearTimeouts();

    this.resetBall(this.ball);
    this.deactivate();

    if (this.leftScore > this.rightScore) {
      this.winnerInfo.setX(this.width / 4);
    } else if (this.rightScore > this.leftScore) {
      this.winnerInfo.setX(3 * this.width / 4);
    }

    this.setGameOverVisible(true);
  }

  createPhysicsRect(x, y, w, h, immovable = true) {
    return this.physics.add.image(x, y, `particle`)
      .setScale(w, h)
      .setImmovable(immovable);
  }

  createPaddles() {
    // Paddles
    this.leftPaddle = this.createPhysicsRect(
        PADDLE_INSET, this.height / 2,
        PADDLE_WIDTH, PADDLE_HEIGHT)
      .setBounce(1);

    this.rightPaddle = this.createPhysicsRect(
        this.width - PADDLE_INSET, this.height / 2,
        PADDLE_WIDTH, PADDLE_HEIGHT)
      .setBounce(1);
  }

  createBall() {
    // Ball
    this.ball = this.createPhysicsRect(
        this.width / 2, this.height / 2,
        BALL_SIZE, BALL_SIZE, false)
      .setBounce(1)
      .setMaxVelocity(350, 350);
  }

  createWalls() {
    // Walls
    this.walls = this.physics.add.group();

    this.topWall = this.createPhysicsRect(this.width / 2, -5, this.width, 10);
    this.walls.add(this.topWall);

    this.bottomWall = this.createPhysicsRect(this.width / 2, this.height + 5, this.width, 10);
    this.walls.add(this.bottomWall);

    // Have to reset immovable when added to group!
    this.topWall.setImmovable(true);
    this.bottomWall.setImmovable(true);
  }

  createDivider() {
    // Set up the dividing line
    this.divider = this.physics.add.group();
    for (let i = 0; i < 24; i++) {
      let block = this.createPhysicsRect(this.width / 2, i * 20 + 10, 10)
        .setBounce(1);
      this.divider.add(block);
      block.setImmovable(true);
    }
  }

  createTexts() {
    this.createScores();
    this.createInstructions();

    this.winnerInfo = this.createWinnerInfo();
  }

  createScores() {
    this.scoreInfo = this.add.group();

    this.leftScoreText = this.add.text(this.width / 2 - 50, 0, this.leftScore, {
        font: "84px Commodore",
        color: "#fff",
        align: "right",
      })
      .setOrigin(1, 0);
    this.leftScoreLabel = this.add.text(this.width / 2 - 50, 80, ``, {
        font: "18px Commodore",
        color: "#fff",
        align: "right",
      })
      .setOrigin(1, 0);

    this.rightScoreText = this.add.text(this.width / 2 + 50, 0, this.rightScore, {
        font: "84px Commodore",
        color: "#fff",
        align: "left",
      })
      .setOrigin(0, 0);
    this.rightScoreLabel = this.add.text(this.width / 2 + 50, 80, ``, {
        font: "18px Commodore",
        color: "#fff",
        align: "left",
      })
      .setOrigin(0, 0);
    this.scoreInfo.add(this.leftScoreText);
    this.scoreInfo.add(this.leftScoreLabel);
    this.scoreInfo.add(this.rightScoreText);
    this.scoreInfo.add(this.rightScoreLabel);
  }

  createInstructions() {
    this.titleText = this.add.text(64, 64, this.scene.key, {
      font: "32px Commodore",
      color: "#fff",
      align: "left",
    });

    this.instructionsText = this.add.text(64, 128, this.instructionsString, {
      font: "16px Commodore",
      color: "#fff",
      align: "left",
      wordWrap: {
        width: this.width - 128
      }
    });
  }

  createWinnerInfo() {
    let winnerInfo = this.physics.add.group();
    let winnerBlackFrame = this.createPhysicsRect(this.width / 4, this.height / 2, this.width / 2 - 20, this.height / 2)
      .setTint(0x000000);
    let winnerWhiteFrame = this.createPhysicsRect(this.width / 4, this.height / 2, this.width / 2 - 30, this.height / 2 - 10)
      .setTint(0xffffff);
    let winnerBG = this.createPhysicsRect(this.width / 4, this.height / 2, this.width / 2 - 40, this.height / 2 - 20)
      .setTint(0x000000);
    let winnerText = this.add.text(this.width / 4, this.height / 2 - 20, this.winnerString, {
        font: "32px Commodore",
        color: "#fff",
        align: "center",
      })
      .setOrigin(0.5, 0.5);
    let resultText = this.add.text(this.width / 4, this.height / 2 + 20, this.resultString, {
        font: "18px Commodore",
        color: "#fff",
        align: "center"
      })
      .setOrigin(0.5, 0.5);

    winnerInfo.add(winnerBlackFrame);
    winnerInfo.add(winnerWhiteFrame);
    winnerInfo.add(winnerBG);
    winnerInfo.add(winnerText);
    winnerInfo.add(resultText);

    winnerInfo.setDepth(10000);

    return winnerInfo;
  }
}