class Menu extends Phaser.Scene {

  constructor(config) {
    super({
      key: `menu`
    });
  }

  create() {
    this.cameras.main.setBackgroundColor(0x000000);

    // Menu items and input

    let menu = [{
      text: `(A) BALL PONG`,
      key: `A`,
      scene: `ball-pong`
    }, {
      text: `(B) BLIND PONG`,
      key: `B`,
      scene: `blind-pong`
    }, {
      text: `(G)HOST PONG`,
      key: `G`,
      scene: `ghost-pong`
    }, ];

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
      let item = menu[i];
      let itemText = this.add.text(x, y, item.text, itemStyle);
      y += verticalSpacing;
    }
  }

  update(time, delta) {

  }
}