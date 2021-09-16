const PADDLE_WIDTH = 10;
const PADDLE_HEIGHT = 60;
const PADDLE_SPEED = 350 / 60;
const PADDLE_INSET = 20;

const BALL_SIZE = 10;
const BALL_SPEED = 350 / 60;
const BALL_LAUNCH_DELAY = 1000;

const GAME_OVER_SCORE = 5;

class Pong {
  constructor() {
    this.topWall = new Rect(width / 2, 0 - PADDLE_HEIGHT / 2, width, PADDLE_HEIGHT);
    this.bottomWall = new Rect(width / 2, height + PADDLE_HEIGHT / 2, width, PADDLE_HEIGHT);

    this.left = new Rect(PADDLE_INSET, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.right = new Rect(width - PADDLE_INSET, height / 2, PADDLE_WIDTH, PADDLE_HEIGHT);
    this.ball = new Rect(width / 2, height / 2, BALL_SIZE, BALL_SIZE);

    this.ball.vx = BALL_SPEED;
  }

  update() {
    background(0);

    this.handleInput();
    this.updatePaddles();
    this.constrainPaddles();

    this.ball.update();

    this.checkPaddleBounces();
    this.checkWallBounces();

    this.displayPaddles();
    this.ball.display();
  }

  handleInput() {
    this.handlePaddle(this.left, 87, 83);
    this.handlePaddle(this.right, UP_ARROW, DOWN_ARROW);
  }

  handlePaddle(paddle, up, down) {
    if (keyIsDown(up)) {
      paddle.vy = -PADDLE_SPEED;
    } else if (keyIsDown(down)) {
      paddle.vy = PADDLE_SPEED;
    } else {
      paddle.vy = 0;
    }
  }

  updatePaddles() {
    this.left.update();
    this.right.update();
  }

  constrainPaddles() {
    this.left.y = constrain(this.left.y, 0 + this.left.h / 2, height - this.left.h / 2);
    this.right.y = constrain(this.right.y, 0 + this.right.h / 2, height - this.right.h / 2);
  }

  checkPaddleBounces() {
    this.checkBounce(this.ball, this.right);
    this.checkBounce(this.ball, this.left);
  }

  checkBounce(ball, paddle) {
    if (ball.overlap(paddle)) {
      if (ball.vx > 0) {
        ball.x = paddle.x - paddle.w / 2 - ball.w / 2;
      } else {
        ball.x = paddle.x + paddle.w / 2 + ball.w / 2;
      }
      ball.vx = -ball.vx;
      ball.vy = constrain(ball.vy + paddle.vy, -BALL_SPEED * 2, BALL_SPEED * 2);
    }
  }

  checkWallBounces() {
    this.checkWallBounce(this.ball, this.topWall);
    this.checkWallBounce(this.ball, this.bottomWall);
  }

  checkWallBounce(ball, wall) {
    if (ball.overlap(wall)) {
      ball.vy = -ball.vy;
    }
  }

  displayPaddles() {
    this.left.display();
    this.right.display();
  }
}