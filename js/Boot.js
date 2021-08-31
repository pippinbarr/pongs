let Boot = new Phaser.Class({

  Extends: Phaser.Scene,

  initialize: function Boot() {
    Phaser.Scene.call(this, {
      key: 'boot'
    });
  },

  preload: function() {
    this.load.image('clown_logo', 'assets/clown_logo.png');
  },

  create: function() {
    this.scene.start('preloader');
  },
});