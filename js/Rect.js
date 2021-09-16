class Rect {
  constructor(x, y, w, h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.vx = 0;
    this.vy = 0;
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;
  }

  display() {
    push();
    fill(255);
    noStroke();
    rect(this.x, this.y, this.w, this.h);
    pop();
  }

  overlap(other) {
    return (abs(this.x - other.x) < (this.w / 2 + other.w / 2) &&
      abs(this.y - other.y) < (this.h / 2 + other.h / 2));
  }
}