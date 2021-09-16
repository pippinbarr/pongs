/**
PONGS
Pippin Barr

I'm trying to remake my old Flash game PONGS in p5.js.
*/

"use strict";

let pong;

/**
Loads the various images and sounds needed.
*/
function preload() {

}


/**
Description of setup
*/
function setup() {
  createCanvas(640, 480);
  rectMode(CENTER);

  pong = new Pong();
}


/**
Description of draw()
*/
function draw() {
  pong.update();
}