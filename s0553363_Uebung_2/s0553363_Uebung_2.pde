/*  //<>//
 * Leonid Barsht
 * s0553363
 * 04.10.2018
 r*/

float meterInPixel; // Stell dar, wie viele Pixel = 1 Centimeter
float offsetGround; // Der Abstand des Bodens vom unteren Bildschirmrand
int frameRate = 60; // Gewünschte Framerate
float deltaT = 1 / (float)frameRate;
float t = 0;
float speed = 500 / 60f / 60f; // 500m pro h auf s runtergerechnet
float wholeWidth = 1.60; // Gesamte Breite in cm → 1,2m + L+R Offset
float fieldWidth = 1.20; // Spielfeld Breite in cm
float LROffset = 0.20; // Länge des Offsets links und rechts in cm
float targetBallWidth = 0.032; // Spielball Durchmesser in cm
float lengthTriangle = 0.04; // Seitenlänge der Dreiecke in cm
float plankLength = 0.25; // Planke Länge in cm
// Punktestand der Spieler
int pointsLeft = 0;
int pointsRight = 0;

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
  t += deltaT;
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


  // Roter Ball in der Mitte
  fill(250, 131, 100);
  ellipse(0 + t * speed, ballWidthNormed / 2 + groundThickness, ballWidthNormed, ballWidthNormed);



  // Ziellinien
  stroke(#ff0000);
  strokeWeight(5);
  float distanceToPlank = 2;
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
  float plankBendLeft = 1.4;
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
  
  popMatrix(); // TODO wo anders hin machen

  /* Im folgenden Stelle ich eine lineare Gleichung zwischen dem Mittelpunkt der Planke und deren oberen Punkt auf
   * Mit deren Hilfe lassen sich auf dieser versetzt dynamisch Elemente platzieren
   * Die Dynamik soll voraussichtlich auch beim Biegen der Planke bestehen */
  // Steigung der Planke m
  float gradientPlankLeft = ((groundPosition - triangleHeight - plankThinkness) - (groundPosition - plankThinkness - lengthTriangleNormed * plankBendLeft)) / (LROffsetNormed - (LROffsetNormed - plankLengthNormedHalf));
  // TODO folgende Variable und plusB umschreiben
  float gradientPlankRight = gradientPlankLeft * -1;
  // +b in der linearen Gleichung → y - m * x = b
  float plusB = (groundPosition - triangleHeight - plankThinkness) - gradientPlankLeft * LROffsetNormed;

  /* TODO orthogonale Funktion berechnen
   * Außerdem ist bei allem Folgendem Refactoring nötig */

  // Ballhalterungen
  fill(100, 160, 215);
  noStroke();
  float triangleShortSideLength = 0.025 * meterInPixel;
  float triangleLongSideLength = 0.04 * meterInPixel;

  // links
  float x1 = LROffsetNormed - plankLengthNormedHalf + triangleLongSideLength;
  float y1 = gradientPlankLeft * x1 + plusB;
  float x2 = LROffsetNormed - plankLengthNormedHalf + triangleLongSideLength * 2;
  float y2 = gradientPlankLeft * x2 + plusB;
  float x3 = LROffsetNormed - plankLengthNormedHalf + triangleLongSideLength * 1.7;
  float y3 = gradientPlankLeft * x3 + plusB - triangleShortSideLength;
  triangle(x1, y1, x2, y2, x3, y3);

  plusB = (groundPosition - triangleHeight - plankThinkness) - gradientPlankRight * (LROffsetNormed + fieldWidthNormed);
  // rechts
  float x12 = LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf - triangleLongSideLength;
  float y12 = gradientPlankRight * x12 + plusB;
  float x22 = LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf - triangleLongSideLength * 2;
  float y22 = gradientPlankRight * x22 + plusB;
  float x32 = LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf - triangleLongSideLength * 1.7;
  float y32 = gradientPlankRight * x32 + plusB - triangleShortSideLength;
  triangle(x12, y12, x22, y22, x32, y32);


  // Geschützbälle
  fill(#DFDFDF);
  stroke(0);
  strokeWeight(1);
  // links
  ellipse(x1+2, y3-3, ballWidthNormed, ballWidthNormed);
  // rechts
  ellipse(x12-2, y32-3, ballWidthNormed, ballWidthNormed);

  // Text in Bällen
  fill(#0000FF);
  textSize(meterInPixel * textSize / 2);
  text("L", x1-2, y3+1);
  text("R", x12-6, y32+1);
}
