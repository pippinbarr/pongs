/**

Handled:

- Straight man √
- Spin doctor √
- No hands √
- Well-travelled √
- Flying blind √
- Hattrick √
- Big lead √
- Made em miss √
- Top achiever √
- Highs and lows √
*/

class TrophyPong extends Pong {
  constructor() {
    super({
      key: `TROPHY PONG`
    });
  }

  create() {
    this.achievements = [];

    super.create();

    this.createAchievements();
  }

  update() {
    super.update();

    this.updateWellTravelled(this.leftPaddle);
    this.updateWellTravelled(this.rightPaddle);

    this.updateNoHands(this.leftPaddle);
    this.updateNoHands(this.rightPaddle);
  }

  paddleHit(paddle, ball) {
    this.checkStraightMan(paddle);

    super.paddleHit(paddle, ball);

    this.achievementsData.highsAndLows.left.tracking.topWall = false;
    this.achievementsData.highsAndLows.left.tracking.bottomWall = false;
    this.achievementsData.highsAndLows.right.tracking.topWall = false;
    this.achievementsData.highsAndLows.right.tracking.bottomWall = false;

    this.updateSpinDoctor(paddle);
    this.checkNoHands(paddle);
  }

  wallHit(ball, wall) {
    super.wallHit(ball, wall);

    this.updateHighsAndLows(wall);

    this.achievementsData.straightMan.left.tracking.touchedWall = true;
    this.achievementsData.straightMan.right.tracking.touchedWall = true;
  }

  checkBall(ball) {
    let point = false;

    // Check if the ball has gone off the screen
    if (ball.x + ball.width / 2 < 0) {
      this.rightScore++;
      this.checkHattrick(this.rightPaddle);
      this.lastPoint = Player.TWO;
      point = true;
      this.checkFlyingBlind(this.rightPaddle);

      if (this.lastHit === this.rightPaddle.player) {
        this.addAchievement(this.achievementsData.madeEmMiss, this.rightPaddle);
      }
    } else if (ball.x - ball.width / 2 > this.width) {
      this.leftScore++;
      this.checkHattrick(this.leftPaddle);
      this.lastPoint = Player.ONE;
      point = true;
      this.checkFlyingBlind(this.leftPaddle);

      if (this.lastHit === this.leftPaddle.player) {
        this.addAchievement(this.achievementsData.madeEmMiss, this.leftPaddle);
      }
    }

    this.setScores();

    if (this.leftScore - this.rightScore >= 5) {
      this.addAchievement(this.achievementsData.bigLead, this.leftPaddle);
    } else if (this.rightScore - this.leftScore >= 5) {
      this.addAchievement(this.achievementsData.bigLead, this.rightPaddle);
    }

    if (point && !this.gameIsOver()) {
      this.postPoint();
    }
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    this.achievements.forEach((a) => {
      a.getChildren()
        .forEach((c) => {
          c.destroy();
        });
      a.destroy();
    });
    this.achievements = [];
  }

  resetPlay() {
    super.resetPlay();

    this.achievementsData.noHands.left.tracking.moved = false;
    this.achievementsData.noHands.right.tracking.moved = false;

    this.achievementsData.spinDoctor.left.tracking.spinsApplied = 0;
    this.achievementsData.spinDoctor.right.tracking.spinsApplied = 0;

    this.achievementsData.straightMan.left.tracking.touchedWall = false;
    this.achievementsData.straightMan.right.tracking.touchedWall = false;
  }

  gameOver() {
    super.gameOver();

    this.createAchievementsData();
  }

  updateHighsAndLows(wall) {
    if (this.lastHit === Player.NONE) {
      return;
    }

    let paddle = this.lastHit === Player.ONE ? this.leftPaddle : this.rightPaddle;
    let data = this.achievementsData.highsAndLows[paddle.id];
    if (wall === this.topWall) {
      data.tracking.topWall = true;
    } else if (wall === this.bottomWall) {
      data.tracking.bottomWall = true;
    }

    if (data.tracking.topWall && data.tracking.bottomWall) {
      this.addAchievement(this.achievementsData.highsAndLows, paddle);
    }
  }

  checkFlyingBlind(paddle) {
    if (this.lastPoint === paddle.player) {
      let achievements = 0;
      for (let achievement in this.achievementsData) {
        if (this.achievementsData[achievement][paddle.id].achieved) {
          achievements++;
        }
      }
      if (achievements >= 5) {
        this.addAchievement(this.achievementsData.flyingBlind, paddle);
      }
    }
  }

  checkHattrick(paddle) {
    let data = this.achievementsData.hattrick[paddle.id];
    if (this.lastPoint === paddle.player) {
      data.tracking.pointsInARow++;
      if (data.tracking.pointsInARow >= 2) {
        this.addAchievement(this.achievementsData.hattrick, paddle);
      }
    } else {
      console.log("Resetting hattrick")
      data.tracking.pointsInARow = 0;
    }
  }

  checkStraightMan(paddle) {
    if (this.lastHit === Player.NONE) return;

    let other = paddle.id === `left` ? this.rightPaddle : this.leftPaddle;

    let data = this.achievementsData.straightMan[other.id];
    if (data.achieved) return;

    if (!data.tracking.touchedWall) {
      this.addAchievement(this.achievementsData.straightMan, other);
    }

    this.achievementsData.straightMan.left.tracking.touchedWall = false;
    this.achievementsData.straightMan.right.tracking.touchedWall = false;
  }

  updateSpinDoctor(paddle) {
    if (paddle.body.velocity.y !== 0) {
      let data = this.achievementsData.spinDoctor[paddle.id];
      data.tracking.spinsApplied++;
    }

    this.checkSpinDoctor(paddle);
  }

  checkSpinDoctor(paddle) {
    let data = this.achievementsData.spinDoctor[paddle.id];
    if (data.tracking.spinsApplied >= 3) {

      this.addAchievement(this.achievementsData.spinDoctor, paddle);
    }
  }

  updateWellTravelled(paddle) {
    let data = this.achievementsData.wellTravelled[paddle.id];
    if (data.achieved) return;

    if (paddle.y === paddle.body.height / 2) {
      data.tracking.touchedTop = true;
    } else if (paddle.y === this.height - paddle.body.height / 2) {
      data.tracking.touchedBottom = true;
    }

    this.checkWellTravelled(paddle);
  }

  checkWellTravelled(paddle) {
    let data = this.achievementsData.wellTravelled[paddle.id];
    if (data.achieved) return;

    if (data.tracking.touchedTop && data.tracking.touchedBottom) {
      this.addAchievement(this.achievementsData.wellTravelled, paddle);
    }
  }

  updateNoHands(paddle) {
    let data = this.achievementsData.noHands[paddle.id];
    if (data.achieved) return;

    if (paddle.body.velocity.y !== 0) {
      data.tracking.moved = true;
    }
  }

  checkNoHands(paddle) {
    let data = this.achievementsData.noHands[paddle.id];
    if (data.achieved) return;

    if (!data.tracking.moved && this.lastHit === paddle.player) {
      this.addAchievement(this.achievementsData.noHands, paddle);
    }

    this.achievementsData.noHands[`left`].tracking.moved = false;
    this.achievementsData.noHands[`right`].tracking.moved = false;
  }

  addAchievement(achievement, paddle) {
    if (achievement[paddle.id].achieved) {
      return;
    }

    achievement[paddle.id].achieved = true;

    let spacing = 5;
    let rows = 5;
    let cols = 2;

    let width = (this.width / 2 - 20 - 15) / cols - spacing;
    let height = (this.height - 90) / rows - spacing;

    let left = width / 2 + ((paddle.id === `left`) ? 25 + spacing : this.width / 2 + 15 - spacing);
    let top = 90 + height / 2;

    let x = left + achievement.position.x * (width + spacing);
    let y = top + achievement.position.y * (height + spacing);

    let achievementInfo = this.add.group();

    let achievementBG = this.add.graphics(x, y);
    achievementBG.fillStyle(0xffffff, 1.0);
    achievementBG.fillRect(x - width / 2, y - height / 2, width, height);

    let achievementText = this.add.text(x, y - height / 2.75, achievement.title, {
        font: "11px Commodore",
        color: "#000",
        align: "center",
        wordWrap: {
          width: width,
          useAdvancedWrap: true
        }
      })
      .setOrigin(0.5, 0.5);

    let resultText = this.add.text(x, y - height / 5, achievement.description, {
        font: "10px Commodore",
        color: "#000",
        align: "center",
        wordWrap: {
          width: width,
          useAdvancedWrap: true
        }
      })
      .setOrigin(0.5, 0);

    // console.log(x, y, width, height);

    achievementInfo.add(achievementBG);
    achievementInfo.add(achievementText);
    achievementInfo.add(resultText);

    this.achievements.push(achievementInfo);

    // return achievementInfo;

    // Shall we check for the top achiever?

    if (this.achievementsData.topAchiever[paddle.id].achieved) {
      return;
    }

    let achievements = 0;
    for (let a in this.achievementsData) {
      if (this.achievementsData[a][paddle.id].achieved) {
        achievements++;
      }
    }

    if (achievements === 9) {
      this.addAchievement(this.achievementsData.topAchiever, paddle);
    }
  }

  getAchievementData(achievement, paddle) {
    return this.achievementsData[achievement][paddle];
  }

  createAchievements() {
    this.leftPaddle.id = `left`;
    this.rightPaddle.id = `right`;

    this.leftPaddle.player = Player.ONE;
    this.rightPaddle.player = Player.TWO;

    this.achievements = [];

    this.createAchievementsData();
  }

  createAchievementsData() {
    this.achievementsData = {
      madeEmMiss: {
        title: `MADE 'EM MISS!`,
        description: `GOT THE BALL PAST YOUR OPPONENT WITHOUT THEM TOUCHING IT`,
        position: {
          x: 0,
          y: 0
        },
        left: {
          achieved: false,
          tracking: {
            opponentTouched: false
          }
        },
        right: {
          achieved: false,
          tracking: {
            opponentTouched: false
          }
        },
      },
      highsAndLows: {
        title: `HIGHS AND LOWS!`,
        description: `BOUNCED THE BALL OF THE TOP AND BOTTOM WALLS IN ONE SHOT`,
        position: {
          x: 0,
          y: 1
        },
        left: {
          achieved: false,
          tracking: {
            top: false,
            bottom: false
          }
        },
        right: {
          achieved: false,
          tracking: {
            top: false,
            bottom: false
          }
        }
      },
      spinDoctor: {
        title: `SPIN DOCTOR!`,
        description: `APPLIED "SPIN" TO THE BALL THREE TIMES IN ONE POINT`,
        position: {
          x: 0,
          y: 2
        },
        left: {
          achieved: false,
          tracking: {
            spinsApplied: 0
          }
        },
        right: {
          achieved: false,
          tracking: {
            spinsApplied: 0
          }
        },
      },
      bigLead: {
        title: `BIG LEAD!`,
        description: `GOT AHEAD BY FIVE POINTS`,
        position: {
          x: 0,
          y: 3
        },
        left: {
          achieved: false,
          tracking: {

          }
        },
        right: {
          achieved: false,
          tracking: {

          }
        },
      },
      wellTravelled: {
        title: `WELL TRAVELLED!`,
        description: `TOUCHED THE TOP AND BOTTOM OF THE SCREEN WITH YOUR PADDLE`,
        position: {
          x: 0,
          y: 4
        },
        left: {
          achieved: false,
          tracking: {
            touchedTop: false,
            touchedBottom: false
          }
        },
        right: {
          achieved: false,
          tracking: {
            touchedTop: false,
            touchedBottom: false
          }
        },
      },
      straightMan: {
        title: `STRAIGHT MAN!`,
        description: `MADE A SHOT THAT DIDN'T TOUCH ANY WALLS`,
        position: {
          x: 1,
          y: 0
        },
        left: {
          achieved: false,
          tracking: {
            touchedWall: false
          }
        },
        right: {
          achieved: false,
          tracking: {
            touchedWall: false
          }
        },
      },
      hattrick: {
        title: `HATTRICK!`,
        description: `WON THREE POINTS IN A ROW`,
        position: {
          x: 1,
          y: 1
        },
        left: {
          achieved: false,
          tracking: {
            pointsInARow: 0
          }
        },
        right: {
          achieved: false,
          tracking: {
            pointsInARow: 0
          }
        },
      },
      noHands: {
        title: `NO HANDS!`,
        description: `RETURNED THE BALL WITHOUT MOVING THE PADDLE`,
        position: {
          x: 1,
          y: 2
        },
        left: {
          achieved: false,
          tracking: {
            moved: false
          }
        },
        right: {
          achieved: false,
          tracking: {
            moved: false
          }
        },
      },
      flyingBlind: {
        title: `FLYING BLIND!`,
        description: `WON A POINT WITH 5 OR MORE TROPHIES ON SCREEN`,
        position: {
          x: 1,
          y: 3
        },
        left: {
          achieved: false,
          tracking: {

          }
        },
        right: {
          achieved: false,
          tracking: {

          }
        },
      },
      topAchiever: {
        title: `TOP ACHIEVER!`,
        description: `GOT ALL THE ACHIEVEMENTS, EVEN THIS ONE`,
        position: {
          x: 1,
          y: 4
        },
        left: {
          achieved: false,
          tracking: {

          }
        },
        right: {
          achieved: false,
          tracking: {

          }
        },
      },
    }
  }
}