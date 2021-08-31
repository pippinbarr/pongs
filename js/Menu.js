class Menu extends Phaser.Scene {

  constructor(config) {
    super({
      key: "menu"
    });
  }

  create() {
    // this.cameras.main.setBackgroundColor(0xfefefe);
    this.cameras.main.setBackgroundColor(0xcccccc);

    this.pageInset = 100;
    this.pageWidth = this.game.canvas.width - 2 * this.pageInset;
    this.pageMargin = 32;
    this.textWidth = this.pageWidth - 2 * this.pageMargin;

    this.titleStyle = {
      font: "bold 24px sans-serif",
      color: "#000",
      padding: {
        top: 5,
        bottom: 5,
      },
      align: "center",
      fixedWidth: this.textWidth,
      backgroundColor: "#eb4034",
    };
    this.standardBoldStyle = {
      font: "bold 12px sans-serif",
      color: "#000",
      padding: {
        top: 0,
        bottom: 0,
      },
      align: "left",
      fixedWidth: this.textWidth,
      wordWrap: {
        width: this.textWidth
      }
    };
    this.standardStyle = {
      font: "12px sans-serif",
      color: "#000",
      padding: {
        top: 0,
        bottom: 0,
      },
      align: "left",
      fixedWidth: this.textWidth,
      wordWrap: {
        width: this.textWidth
      }
    };

    this.displayPage();
    this.displayTitle();
    this.displayInstruction();
    this.displayGames();

    this.cursors = this.input.keyboard.createCursorKeys();
  }

  displayPage() {
    this.page = this.add.sprite(this.pageInset, 0, 'atlas', 'pixel.png')
      .setTint(0xfafaf4)
      .setScale(this.pageWidth, this.game.canvas.height)
      .setOrigin(0, 0)
  }

  displayTitle() {
    this.titleText = this.add.text(this.pageInset + this.pageMargin, this.pageMargin, "COMBAT AT THE MOVIES", this.titleStyle);
  }

  displayInstruction() {
    this.instructionText = this.add.text(this.pageInset + this.pageMargin, 80, "Use the Arrow Keys and Space Bar with this Game Program.", this.standardBoldStyle);
    this.explanationText = this.add.text(this.pageInset + this.pageMargin, 100, "COMBAT AT THE MOVIES is a unique series of games from Pippin Barr. In each game you will encounter a classic film as acted out by one or more tanks from the game Combat by Atari. Specific instructions are provided after you select your chosen game mode. COMBAT AT THE MOVIES is a one-player game.", this.standardStyle);
    this.menuInstructionText = this.add.text(this.pageInset + this.pageMargin, 400, "Use the Arrow Keys to choose a game and press Space Bar to play it. Press Escape during any game to return to this menu.", this.standardStyle);
  }

  displayGames() {
    this.games = [{
      key: "citizenkane",
      title: "Citizen Kane",
      year: 1941,
      menuKey: "K"
    }, {
      key: "beautravail",
      title: "Beau Travail",
      year: 1999,
      menuKey: "B"
    }, {
      key: "auhasardbalthazar",
      title: "Au Hasard Balthazar",
      year: 1966,
      menuKey: "A"
    }, {
      key: "lavventura",
      title: "L'Avventura",
      year: 1960,
      menuKey: "L"
    }, {
      key: "rashomon",
      title: "Rashomon",
      year: 1950,
      menuKey: "R"
    }, {
      key: "tokyostory",
      title: "Tokyo Story",
      year: 1953,
      menuKey: "S"
    }, {
      key: "taxidriver",
      title: "Taxi Driver",
      year: 1976,
      menuKey: "T"
    }, {
      key: "theconversation",
      title: "The Conversation",
      year: 1974,
      menuKey: "C"
    }, {
      key: "thegodfather",
      title: "The Godfather",
      year: 1972,
      menuKey: "G"
    }, {
      key: "twothousandandoneaspaceodyssey",
      title: "2001: A Space Odyssey",
      year: 1968,
      menuKey: "TWO"
    }, ];

    let gameMenuItemStyle = {
      font: "bold 12px sans-serif",
      color: "#000",
      padding: {
        top: 0,
        bottom: 0,
      },
      align: "left",
      fixedWidth: this.textWidth,
    };

    this.games.sort((a, b) => a.year - b.year);
    let y = 180;
    this.menuItems = [];
    this.labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (let i = 0; i < this.games.length; i++) {
      let title = `${i+1}. ${this.games[i].title} (${this.games[i].year})`
      let item = this.add.text(this.pageInset + this.pageMargin, y, title, gameMenuItemStyle);
      y += 20;
      item.game = this.games[i];
      this.menuItems.push(item);
      this.scene.get(item.game.key).figureLabel = this.labels[i];
    }

    this.currentItem = 0;
    this.menuItems[this.currentItem].setBackgroundColor("orange");
  }

  update(time, delta) {
    this.handleInput();
  }

  handleInput() {
    if (Phaser.Input.Keyboard.JustDown(this.cursors.up)) {
      this.menuItems[this.currentItem].setBackgroundColor("transparent");
      this.currentItem--;
      if (this.currentItem === -1) this.currentItem = this.menuItems.length - 1;
      this.menuItems[this.currentItem].setBackgroundColor("orange");
    }
    else if (Phaser.Input.Keyboard.JustDown(this.cursors.down)) {
      this.menuItems[this.currentItem].setBackgroundColor("transparent");
      this.currentItem++;
      if (this.currentItem === this.menuItems.length) this.currentItem = 0;
      this.menuItems[this.currentItem].setBackgroundColor("orange");
    }
    else if (Phaser.Input.Keyboard.JustDown(this.cursors.space)) {
      this.scene.start(this.menuItems[this.currentItem].game.key);
    }
  }
}