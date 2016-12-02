var VECTORS = {
  0: { x: 0, y: 1 },
  1: { x: 1, y: 0 },
  2: { x: 0, y: -1 },
  3: { x: -1, y: 0 }
};

var EasterBunnySearcher = function(directions) {
  this.orientation = 0;
  this.visitedLocations = {};
  this.directions = directions.split(', ');
  this.coords = { x: 0, y: 0 };

  this.makeTurn = function(direction) {
    if (direction == 'L') {
      if (this.orientation === 0) {
        this.orientation = 3;
      } else {
        this.orientation -= 1;
      }
    } else if (direction == 'R') {
      this.orientation += 1;
      this.orientation = this.orientation % 4;
    }
  };

  this.makeMove = function() {
    var vector = VECTORS[this.orientation];
    this.coords.x += vector.x;
    this.coords.y += vector.y;
  };

  this.hasVisited = function(loc) {
   if (this.visitedLocations[loc.x] && this.visitedLocations[loc.x].includes(loc.y)) {
      return true;
    } else {
      return false;
    }
  };

  this.recordVisitedLocation = function(loc) {
    var xCoord = loc.x;
    var yCoord = loc.y;
    if (typeof(this.visitedLocations[xCoord]) === 'undefined') {
      this.visitedLocations[xCoord] = [yCoord];
    } else {
      this.visitedLocations[xCoord].push(yCoord);
    }
  };

  this.makeMoves = function() {
    var self = this;
    this.directions.forEach(function(direction) {
      var numSteps = direction.slice(1);
      self.makeTurn(direction.slice(0,1));
      for (var i = 0; i < numSteps; i++) {
        self.makeMove();
        var visited = self.hasVisited(self.coords);
        if (visited) {
          console.log ("Location visited twice! Shortest path is ", self.shortestPath());
        } else {
          self.recordVisitedLocation(self.coords);
        }
      }
    });
  };

  this.shortestPath = function() {
    return Math.abs(this.coords.x) + Math.abs(this.coords.y);
  };
};

// var test1 = new EasterBunnySearcher("R2, R3");
// var test2 = new EasterBunnySearcher("R2, R2, R2");
// var test3 = new EasterBunnySearcher("R5, L5, R5, R3");
// test1.makeMoves();
// console.log('Test 1 shortest path: ', test1.shortestPath());
// test2.makeMoves();
// console.log('Test 2 shortest path: ', test2.shortestPath());
// test3.makeMoves();
// console.log('Test 3 shortest path: ', test3.shortestPath());
var test4 = new EasterBunnySearcher("R8, R4, R4, R8");
test4.makeMoves();

var realInput = new EasterBunnySearcher("R3, L2, L2, R4, L1, R2, R3, R4, L2, R4, L2, L5, L1, R5, R2, R2, L1, R4, R1, L5, L3, R4, R3, R1, L1, L5, L4, L2, R5, L3, L4, R3, R1, L3, R1, L3, R3, L4, R2, R5, L190, R2, L3, R47, R4, L3, R78, L1, R3, R190, R4, L3, R4, R2, R5, R3, R4, R3, L1, L4, R3, L4, R1, L4, L5, R3, L3, L4, R1, R2, L4, L3, R3, R3, L2, L5, R1, L4, L1, R5, L5, R1, R5, L4, R2, L2, R1, L5, L4, R4, R4, R3, R2, R3, L1, R4, R5, L2, L5, L4, L1, R4, L4, R4, L4, R1, R5, L1, R1, L5, R5, R1, R1, L3, L1, R4, L1, L4, L4, L3, R1, R4, R1, R1, R2, L5, L2, R4, L1, R3, L5, L2, R5, L4, R5, L5, R3, R4, L3, L3, L2, R2, L5, L5, R3, R4, R3, R4, R3, R1");
realInput.makeMoves();
console.log('Real input shortest path: ', realInput.shortestPath());
