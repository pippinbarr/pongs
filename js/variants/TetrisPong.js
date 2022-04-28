/**

To do:
- I think it's not meant to drop blocks in the middle zone
- Check the timing on block release
- What happens if the ball is trapped or the blocks exceed the top?

*/

class TetrisPong extends Pong {
  constructor() {
    super({
      key: `TETRIS PONG`
    });
  }

  create() {
    super.create();

    // Oh boy.

    this.createShapeData();
    this.falling = this.physics.add.group();
    this.landed = this.physics.add.group();

    this.blockInterval = undefined;
  }

  setPlayVisible(value) {
    super.setPlayVisible(value);

    if (value) {
      this.falling.clear(true, true);
      this.landed.clear(true, true);

      this.blockInterval = setInterval(() => {
        let unit = 20;
        let x = 0;
        let offsetX = Math.floor(Math.random() * 190 / unit) * unit;
        if (Math.random() < 0.5) {
          x = 40 + unit / 2;
        } else {
          x = this.width / 2 + 45 + unit / 2;
        }
        this.addBlock(x + offsetX, -100);
      }, 4000);
    }
  }

  clearTimeouts() {
    super.clearTimeouts();
    clearInterval(this.blockInterval);
  }

  addBlock(x, y) {
    let unit = 20;
    let block = this.physics.add.group();
    let shape = this.shapes[Math.floor(Math.random() * this.shapes.length)].shape;
    for (let r = 0; r < shape.length; r++) {
      for (let c = 0; c < shape[r].length; c++) {
        if (shape[r][c] === `X`) {
          let bit = this.createPhysicsRect(x + unit * c, y + unit * r, unit, unit);
          block.add(bit);
          this.falling.add(bit);
          bit.setBounce(0, 0);
          bit.parent = block;
          bit.setImmovable(true);
        }
      }
    }
    block.setVelocityY(150);
  }

  doCollisions() {
    super.doCollisions();

    this.physics.collide(this.ball, this.blocks);

    this.physics.collide(this.ball, this.landed, this.blockHit, null, this);
    this.physics.collide(this.ball, this.falling, this.blockHit, null, this);

    this.physics.collide(this.falling, this.bottomWall, this.landBottom, null, this);
    this.physics.collide(this.falling, this.landed, null, this.landBlock, this);
  }

  blockHit(ball, block) {
    this.wallSFX.play();
  }

  landBottom(wall, bit) {
    let bits = bit.parent.getChildren();
    let dy = (bit.y + bit.body.height / 2) - (wall.y - wall.body.height / 2);
    bits.forEach((b) => {
      b.setVelocityY(0);
      this.falling.remove(b);
      this.landed.add(b);
      b.setImmovable(true);
      b.y -= dy;
    });
  }

  landBlock(faller, landed) {
    let bits = faller.parent.getChildren();
    let dy = (faller.body.y + faller.body.height / 2) - (landed.body.y - landed.body.height / 2);
    bits.forEach((b) => {
      b.setVelocityY(0);
      this.falling.remove(b);
      this.landed.add(b);
      b.setImmovable(true);
      b.y -= dy;
    });
  }

  update() {
    super.update();


  }

  createShapeData() {
    this.shapes = [{
      name: `t-down`,
      shape: [
        [` `, ` `, ` `],
        [`X`, `X`, `X`],
        [` `, `X`, ` `]
      ],
    }, {
      name: `t-up`,
      shape: [
        [` `, `X`, ` `],
        [`X`, `X`, `X`],
        [` `, ` `, ` `]
      ],
    }, {
      name: `t-left`,
      shape: [
        [` `, `X`, ` `],
        [`X`, `X`, ` `],
        [` `, `X`, ` `]
      ],
    }, {
      name: `t-right`,
      shape: [
        [` `, `X`, ` `],
        [` `, `X`, `X`],
        [` `, `X`, ` `]
      ],
    }, {
      name: `square`,
      shape: [
        [`X`, `X`, ` `],
        [`X`, `X`, ` `],
        [` `, ` `, ` `]
      ],
    }, {
      name: `l-1`,
      shape: [
        [`X`, ` `, ` `],
        [`X`, ` `, ` `],
        [`X`, `X`, ` `]
      ],
    }, {
      name: `l-2`,
      shape: [
        [` `, ` `, ` `],
        [` `, ` `, `X`],
        [`X`, `X`, `X`]
      ],
    }, {
      name: `l-3`,
      shape: [
        [` `, `X`, `X`],
        [` `, ` `, `X`],
        [` `, ` `, `X`]
      ],
    }, {
      name: `l-4`,
      shape: [
        [`X`, `X`, `X`],
        [`X`, ` `, ` `],
        [` `, ` `, ` `]
      ],
    }, {
      name: `r-1`,
      shape: [
        [`X`, `X`, ` `],
        [`X`, ` `, ` `],
        [`X`, ` `, ` `]
      ],
    }, {
      name: `r-2`,
      shape: [
        [` `, ` `, ` `],
        [`X`, ` `, ` `],
        [`X`, `X`, `X`]
      ],
    }, {
      name: `r-3`,
      shape: [
        [` `, ` `, `X`],
        [` `, ` `, `X`],
        [` `, `X`, `X`]
      ],
    }, {
      name: `r-4`,
      shape: [
        [`X`, `X`, `X`],
        [` `, ` `, `X`],
        [` `, ` `, ` `]
      ],
    }, {
      name: `s-1`,
      shape: [
        [` `, `X`, `X`],
        [`X`, `X`, ` `],
        [` `, ` `, ` `]
      ],
    }, {
      name: `s-2`,
      shape: [
        [`X`, ` `, ` `],
        [`X`, `X`, ` `],
        [` `, `X`, ` `]
      ],
    }, {
      name: `z-1`,
      shape: [
        [`X`, `X`, ` `],
        [` `, `X`, `X`],
        [` `, ` `, ` `]
      ],
    }, {
      name: `z-2`,
      shape: [
        [` `, `X`, ` `],
        [`X`, `X`, ` `],
        [`X`, ` `, ` `]
      ],
    }, ]
  }
}