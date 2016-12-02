var VECTORS = {
  'U' : { x: 0, y: -1 },
  'R' : { x: 1, y: 0 },
  'D' : { x: 0, y: 1 },
  'L' : { x: -1, y: 0 }
};

var BathroomDecoder = function(start, instructions) {
  this.currentButton = start;
  this.instructions = instructions.split('');

  this.followInstruction = function(instruction) {
    var newButton = {};
    newButton.x = this.currentButton.x;
    newButton.y = this.currentButton.y;
    var instructionVector = VECTORS[instruction];
    newButton.x += instructionVector.x;
    newButton.y += instructionVector.y;
    if (Math.abs(newButton.x) <= 1 && Math.abs(newButton.y) <= 1) {
      this.currentButton = newButton;
    }
  }

  this.followInstructions = function() {
    for (var i = 0; i < this.instructions.length; i++) {
      this.followInstruction(this.instructions[i]);
    }
  }
};

var firstNumber = new BathroomDecoder({ x: 0, y: 0 }, 'ULL');
firstNumber.followInstructions();
console.log(firstNumber.currentButton);
var secondNumber = new BathroomDecoder(firstNumber.currentButton, 'RRDDD');
secondNumber.followInstructions();
console.log(secondNumber.currentButton);
var thirdNumber = new BathroomDecoder(secondNumber.currentButton, 'LURDL');
thirdNumber.followInstructions();
console.log(thirdNumber.currentButton);
var fourthNumber = new BathroomDecoder(thirdNumber.currentButton, 'UUUUD');
fourthNumber.followInstructions();
console.log(fourthNumber.currentButton);
