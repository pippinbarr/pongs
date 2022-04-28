let Preloader = new Phaser.Class({

  Extends: Phaser.Scene,

  initialize: function Preloader() {
    Phaser.Scene.call(this, {
      key: 'preloader'
    });
  },

  preload: function () {
    // Assets

    // Tetris blocks
    this.load.image(`i-block`, `assets/blocks/IBlock.png`);
    this.load.image(`l-block`, `assets/blocks/LBlock.png`);
    this.load.image(`r-block`, `assets/blocks/RBlock.png`);
    this.load.image(`s-block`, `assets/blocks/SBlock.png`);
    this.load.image(`square-block`, `assets/blocks/SquareBlock.png`);
    this.load.image(`t-block`, `assets/blocks/TBlock.png`);
    this.load.image(`z-block`, `assets/blocks/ZBlock.png`);

    // Images
    this.load.image(`dial`, `assets/images/dial.png`);
    this.load.image(`dial2`, `assets/images/dial2.png`);
    this.load.image(`flag1`, `assets/images/flag1.png`);
    this.load.image(`flag2`, `assets/images/flag2.png`);
    this.load.image(`particle`, `assets/images/particle.png`);
    this.load.image(`pong-cabinet`, `assets/images/PongCabinet.png`);
    this.load.image(`pong-divider`, `assets/images/PongDivider.png`);
    this.load.image(`pong-wall`, `assets/images/PongWall.png`);
    this.load.image(`refugee`, `assets/images/refugee.png`);

    this.load.image(`particle`, `assets/particle.png`);

    // Audio
    this.load.audio('asharp', `assets/sounds/Asharp.mp3`);
    this.load.audio('csharp', `assets/sounds/Csharp.mp3`);
    this.load.audio('correct', `assets/sounds/correct.mp3`);
    this.load.audio('dsharp', `assets/sounds/Dsharp.mp3`);
    this.load.audio('f', `assets/sounds/F.mp3`);
    this.load.audio('fsharp', `assets/sounds/Fsharp.mp3`);
    this.load.audio('gsharp', `assets/sounds/Gsharp.mp3`);
    this.load.audio('incorrect', `assets/sounds/incorrect.mp3`);
    this.load.audio('paddle', `assets/sounds/paddle.mp3`);
    this.load.audio('point', `assets/sounds/point.mp3`);
    this.load.audio('wall', `assets/sounds/wall.mp3`);

    // Perlin plugin
    this.load.plugin('rexperlinplugin', 'js/libraries/rexperlinplugin.min.js', true);

    // Loading screen visuals

    let style = {
      fontFamily: 'Commodore',
    };
    let invisible = this.add.text(0, 0, "123456", style);
    invisible.visible = false;

    this.cameras.main.setBackgroundColor(0x000000);

    this.clown = this.add.sprite(this.game.canvas.width / 2, this.game.canvas.height / 2, `clown_logo`);

    let progressBar = this.add.graphics();

    this.load.on('progress', (value) => {
      progressBar.clear();
      progressBar.fillStyle(0xffffff, 1);
      progressBar.fillRect(this.clown.x - this.clown.width / 2, this.clown.y + this.clown.height / 2, this.clown.width * value, 5);
    });
  },

  create: function () {

    setTimeout(() => {
      this.scene.start(START_SCENE);
    }, 1000);
  },
});