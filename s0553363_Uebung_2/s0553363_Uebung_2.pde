/*  //<>// //<>//
 * Leonid Barsht
 * s0553363
 * 04.10.2018
 */

float meterInPixel; // Stell dar, wie viele Pixel = 1 Meter; Maßstab M
float offsetGround; // Der Abstand des Bodens vom unteren Bildschirmrand
int frameRate = 60; // Gewünschte Framerate
// Zeit
float deltaT = 1 / (float)frameRate;
float t = 0;
float timeScale = 500; // < 1 = langsamer; > 1 = schneller
float deltaTtimeLapse = timeScale * deltaT;
float speed = 500 / 60f / 60f; // 500m pro h auf s runtergerechnet

float wholeWidth = 1.60; // Gesamte Breite in m → 1,2m + L+R Offset
float fieldWidth = 1.20; // Spielfeld Breite in m
float LROffset = 0.20; // Länge des Offsets links und rechts in m
float targetBallWidth = 0.032; // Spielball Durchmesser in m
float lengthTriangle = 0.04; // Seitenlänge der Dreiecke in m
float plankLength = 0.25; // Planke Länge in m
// Punktestand der Spieler
int pointsLeft = 0;
int pointsRight = 0;
// Positionen der Ziellinien
float leftGoalX = Float.MAX_VALUE;
float rightGoalX = Float.MAX_VALUE;

void setup() {
  //fullScreen();
  size(1000, 400);
  background(255);
  frameRate(frameRate);
  smooth();
  meterInPixel = width / wholeWidth; 
  offsetGround = meterInPixel * 0.05; // 5cm Abstand
}


// Draw - is the game loop
void draw() {
  t += deltaTtimeLapse;
  drawPlayField();
}

float normValue(float val) {
  float normedValue = val * meterInPixel;
  return normedValue;
}

void drawPlayField() {
  background(255);
  float textSize = 0.04;
  float textWidth = textWidth("Treffer " + pointsLeft + ":" + pointsRight);
  // Punktestand
  fill(0);
  textSize(meterInPixel * textSize);
  text("Treffer " + pointsLeft + ":" + pointsRight, width / 2.0f - textWidth, height / 3);

  float groundPosition = height - offsetGround; // Boden Position
  int groundThickness = 2; // Boden Dicke

  // Skalierte Werte
  float ballWidthNormed = targetBallWidth * meterInPixel;
  float fieldWidthNormed = fieldWidth * meterInPixel;
  float LROffsetNormed = LROffset * meterInPixel;
  float lengthTriangleNormed = lengthTriangle * meterInPixel;
  float plankLengthNormedHalf = (plankLength * meterInPixel) / 2;
  float wholeWidthNormed = wholeWidth * meterInPixel;

  pushMatrix();
  translate(width / 2, groundPosition); // Setzt das Koordinatensystem in die Mitte unter den roten Ball
  scale(1, -1); // Dreht die Angaben der Y Werte um

  // Boden vom Spielfeld
  stroke(133, 102, 0); 
  strokeWeight(groundThickness);
  line(-wholeWidthNormed / 2, 0, wholeWidthNormed / 2, 0);
  strokeWeight(1);
  for (float i = meterInPixel / 100; i <= width; i+=meterInPixel/100) {
    line(-wholeWidthNormed / 2 + i, 0, -wholeWidthNormed / 2 + i-meterInPixel / 100, -offsetGround);
  }
  
  
  leftGoalX = -LROffsetNormed*2 - ballWidthNormed/2;
  rightGoalX = LROffsetNormed*2 + ballWidthNormed/2;
  float movement = 0 + t * speed;
  if( movement <= leftGoalX || movement >= rightGoalX){
    speed *= -1;
    println(leftGoalX);
    println(rightGoalX);
    println(movement);
    
  }
  // Roter Ball in der Mitte
  fill(250, 131, 100);
  ellipse(movement, ballWidthNormed / 2 + groundThickness, ballWidthNormed, ballWidthNormed);


  // Ziellinien
  stroke(#ff0000);
  strokeWeight(5);

  

  // links
  line(-LROffsetNormed*2, -groundThickness, -LROffsetNormed*2 - ballWidthNormed, -groundThickness);
  
  // rechts
  line(LROffsetNormed*2, -groundThickness, LROffsetNormed*2 + ballWidthNormed, -groundThickness);


  // Standfüße
  fill(100, 160, 215);
  stroke(#0000DD); 
  strokeWeight(1);
  float triangleHeight = (lengthTriangleNormed / 2) * sqrt(3);
  // links
  triangle(-fieldWidthNormed / 2 - lengthTriangleNormed / 2, groundThickness, -fieldWidthNormed / 2, groundThickness + triangleHeight, -fieldWidthNormed / 2 + lengthTriangleNormed / 2, groundThickness);
  // rechts
  triangle(fieldWidthNormed / 2 + lengthTriangleNormed / 2, groundThickness, fieldWidthNormed / 2, groundThickness + triangleHeight, fieldWidthNormed / 2 - lengthTriangleNormed / 2, groundThickness);



  // Planken
  noFill();
  float plankThinkness = 4;
  // Beim Verändern dieser Werte wird die Planke gebogen
  float plankBendLeft = 1.8;
  float plankBendRight = 1.8;


  stroke(100, 160, 215);
  strokeWeight(plankThinkness);
  // Planke links
  beginShape();
  // Start- und Endpunkt müssen doppelt vorkommen
  curveVertex(-fieldWidthNormed / 2 - plankLengthNormedHalf, groundThickness + plankThinkness + lengthTriangleNormed * plankBendLeft);
  curveVertex(-fieldWidthNormed / 2 - plankLengthNormedHalf, groundThickness + plankThinkness + lengthTriangleNormed * plankBendLeft); // Startpunkt
  curveVertex(-fieldWidthNormed / 2, groundThickness + triangleHeight + plankThinkness); // Mittelpunkt
  curveVertex(-fieldWidthNormed / 2 + plankLengthNormedHalf, groundThickness); // Endpunkt
  curveVertex(-fieldWidthNormed / 2 + plankLengthNormedHalf, groundThickness);
  endShape();
  // Planke rechts
  beginShape();
  // Start- und Endpunkt müssen doppelt vorkommen
  curveVertex(fieldWidthNormed / 2 + plankLengthNormedHalf, groundThickness + plankThinkness + lengthTriangleNormed * plankBendRight);
  curveVertex(fieldWidthNormed / 2 + plankLengthNormedHalf, groundThickness + plankThinkness + lengthTriangleNormed * plankBendRight); // Startpunkt
  curveVertex(fieldWidthNormed / 2, groundThickness + triangleHeight + plankThinkness); // Mittelpunkt
  curveVertex(fieldWidthNormed / 2 - plankLengthNormedHalf, groundThickness); // Endpunkt
  curveVertex(fieldWidthNormed / 2 - plankLengthNormedHalf, groundThickness);
  endShape();



  /* Im folgenden Stelle ich eine lineare Gleichung zwischen dem Mittelpunkt der Planke und deren oberen Punkt auf
   * Mit deren Hilfe lassen sich auf dieser versetzt dynamisch Elemente platzieren
   * Die Dynamik soll voraussichtlich auch beim Biegen der Planke bestehen */

  // Steigung der Planke m
  float gradientPlankLeft = ((groundThickness + triangleHeight + plankThinkness) - (groundThickness + plankThinkness + lengthTriangleNormed * plankBendLeft)) /
    ((-fieldWidthNormed / 2) - (-fieldWidthNormed / 2 - plankLengthNormedHalf));
  float gradientPlankRight = ((groundThickness + plankThinkness + lengthTriangleNormed * plankBendRight) - (groundThickness + triangleHeight + plankThinkness)) /
    ((fieldWidthNormed / 2 + plankLengthNormedHalf) - fieldWidthNormed / 2);
  // +b in der linearen Gleichung → y - m * x = b
  float plusBLeft = (groundThickness + triangleHeight + plankThinkness) - gradientPlankLeft * -fieldWidthNormed / 2;
  float plusBRight = (groundThickness + triangleHeight + plankThinkness) - gradientPlankRight * fieldWidthNormed / 2;





  /* TODO orthogonale Funktion berechnen
   * Außerdem ist bei allem Folgendem Refactoring nötig */

  // Ballhalterungen
  fill(100, 160, 215);
  noStroke();
  float triangleShortSideLength = 0.025 * meterInPixel;
  float triangleLongSideLength = 0.04 * meterInPixel;

  // links
  float x1 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength; // check
  float y1 = gradientPlankLeft * x1 + plusBLeft;
  float x2 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength * 2;
  float y2 = gradientPlankLeft * x2 + plusBLeft;
  // Spitze
  float x3 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength * 1.7;
  float y3 = gradientPlankLeft * x3 + plusBLeft + triangleShortSideLength;
  triangle(x1, y1, x2, y2, x3, y3);



  // rechts
  float x12 = fieldWidthNormed / 2 + plankLengthNormedHalf - triangleLongSideLength;
  float y12 = gradientPlankRight * x12 + plusBRight;
  float x22 = fieldWidthNormed / 2 + plankLengthNormedHalf - triangleLongSideLength * 2;
  float y22 = gradientPlankRight * x22 + plusBRight;
  // Spitze
  float x32 = fieldWidthNormed / 2 + plankLengthNormedHalf - triangleLongSideLength * 1.7;
  float y32 = gradientPlankRight * x32 + plusBRight + triangleShortSideLength;
  triangle(x12, y12, x22, y22, x32, y32);



  // Geschützbälle
  fill(#DFDFDF);
  stroke(0);
  strokeWeight(1);
  float ballOffsetY = 13;

  // links
  ellipse(x1, y1+ballOffsetY, ballWidthNormed, ballWidthNormed);
  // rechts
  ellipse(x12, y12+ballOffsetY, ballWidthNormed, ballWidthNormed);
  scale(1, -1); // Dreht die Szene wieder um, damit die Schrift korrekt dargestellt wird
  // Text in Bällen
  fill(#0000FF);
  float textOffsetX = 4;
  float textOffsetY = 8;
  textSize(meterInPixel * textSize / 2);
  text("L", x1 - textOffsetX, (y1 + textOffsetY) * - 1);
  text("R", x12 - textOffsetX, (y12 + textOffsetY) * -1);

  popMatrix(); // TODO wo anders hin machen
}
