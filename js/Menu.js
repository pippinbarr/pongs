class Menu extends Phaser.Scene {

  constructor(config) {
    super({
      key: `menu`
    });
  }

  create() {
    this.cameras.main.setBackgroundColor(0xFF112233);

    // Menu items and input

    let menuKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let scenes = [
      `2D PONG`, `BALL PONG`, `BLIND PONG`, `BREAKDOWN PONG`, `BREAKOUT PONG`,
      `B.U.T.T.O.N. PONG`, `CONJOINED PONG`, `COUNTDOWN PONG`,
      `EDUTAINMENT PONG`, `FERTILITY PONG`, `FLASHING PONG`, `GHOST PONG`,
      `INVERSE PONG`, `LASER PONG`, `MEMORIES OF PONG`, `PERLIN PONG`,
      `PONG FOR TWO`, `PONG IN THE MIDDLE`, `PONG PONG`, `PONG SANS FRONTIERS`,
      `PRISONER PONG`, `QTE PONG`, `REVERSE PONG`, `SERIOUS PONG`, `SHIT PONG`,
      `SHRINK PONG`, `SNAKE PONG`, `SWAPPING PONG`, `TEAM PONG`,
      `TETRIS PONG`, `TRACE PONG`, `TRACK AND PONG`, `TROPHY PONG`,
      `TURN-BASED PONG`, `UNFAIR PONG`, `VIENNESE PONG`
    ];

    let menu = [];
    for (let i = 0; i < scenes.length; i++) {
      menu.push({
        text: `(${menuKeys[i]}) ${scenes[i]}`,
        key: menuKeys[i],
        scene: scenes[i]
      });
    }

    this.input.keyboard.on('keydown', (e) => {
      let key = e.key.toUpperCase();
      let game = menu.filter((o, i) => o.key === key);
      if (game.length > 0) {
        this.scene.start(game[0].scene);
      }
    });

    // Title and menu list

    let titleStyle = {
      fontFamily: 'Commodore',
      fontSize: '100px',
      fill: '#fff',
      wordWrap: true,
      align: 'center'
    };
    let title = this.add.text(this.game.canvas.width / 2, 20, "PONGS", titleStyle);
    title.setOrigin(0.5, 0);

    let x = 80;
    let y = 170;
    let verticalSpacing = 14;
    let itemStyle = {
      fontFamily: 'Commodore',
      fontSize: '14px',
      fill: '#fff',
      wordWrap: true,
      align: 'center'
    };
    for (let i = 0; i < menu.length; i++) {
      if (i === 18) {
        x = this.game.canvas.width / 2 + 35;
        y = 170;
      }
      let item = menu[i];
      let itemText = this.add.text(x, y, item.text, itemStyle);
      y += verticalSpacing;
    }
  }

  update(time, delta) {

  }
}