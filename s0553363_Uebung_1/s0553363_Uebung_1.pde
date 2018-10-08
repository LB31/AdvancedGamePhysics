/* //<>// //<>//
Leonid Barsht
 s0553363
 04.10.2018
 */

// Stell dar, wie viele Pixel = 1 Centimeter
float centimeterInPixel;
// Der Abstand des Bodens vom unteren Bildschirmrand
float offsetGround;
// Gewünschte Framerate
int frameRate = 60;
// Gesamte Breite in cm → 1,2m + L+R Offset
float wholeWidth = 160;
// Spielfeld Breite in cm
float fieldWidth = 120;
// Länge des Offsets links und rechts in cm
float LROffset = 20;
// Spielball Durchmesser in cm
float targetBallWidth = 3.2;
// Seitenlänge der Dreiecke in cm
float lengthTriangle = 4.0;
// Planke Länge in cm
float plankLength = 25;

void setup() {
  //fullScreen();
  size(1000, 400);
  background(255);
  frameRate(frameRate);
  smooth();
  centimeterInPixel = width / wholeWidth; 
  offsetGround = centimeterInPixel * 5; // 5cm Abstand
}


// Draw - is the game loop
void draw() {
  drawPlayField();
}


void drawPlayField() {
  int pointsLeft = 0;
  int pointsRight = 0;
  int textSize = 5;
  
  // Punktestand
  fill(0);
  textSize(centimeterInPixel * textSize);
  text("Treffer" + pointsLeft + ":" + pointsRight, width / (float)2 - (centimeterInPixel * textSize), height / 3);
  
  // Boden Position
  float groundPosition = height - offsetGround;
  // Boden Dicke
  int groundThickness = 2;

  // Skalierte Werte
  float ballWidthNormed = targetBallWidth * centimeterInPixel;
  float fieldWidthNormed = fieldWidth * centimeterInPixel;
  float LROffsetNormed = LROffset * centimeterInPixel;
  float lengthTriangleNormed = lengthTriangle * centimeterInPixel;
  float plankLengthNormedHalf = (plankLength * centimeterInPixel) / 2;

  // Boden vom Spielfeld
  stroke(133, 102, 0); 
  strokeWeight(groundThickness);
  line(0, groundPosition + groundThickness, width, groundPosition + groundThickness);
  strokeWeight(1);
  for (float i = centimeterInPixel; i <= width; i+=centimeterInPixel) {
    line(i, groundPosition + groundThickness, i-centimeterInPixel, height);
  }

  // Roter Ball in der Mitte
  fill(250, 131, 100);
  ellipse(width / (float)2, groundPosition - ballWidthNormed / 2, ballWidthNormed, ballWidthNormed);


  
  // Ziellinien
  stroke(#ff0000);
  strokeWeight(5);
  float distanceToPlank = 2;
  // links
  line(LROffsetNormed * distanceToPlank, groundPosition + groundThickness*3, LROffsetNormed * distanceToPlank + ballWidthNormed, groundPosition + groundThickness*3);
  // rechts
  float xOne = (LROffsetNormed + fieldWidthNormed) - (LROffsetNormed * distanceToPlank - LROffsetNormed);
  float xTwo = (LROffsetNormed + fieldWidthNormed) - (LROffsetNormed * distanceToPlank - LROffsetNormed) - ballWidthNormed;
  line(xOne, groundPosition + groundThickness*3, xTwo, groundPosition + groundThickness*3);




  // Standfüße
  fill(100, 160, 215);
  stroke(#0000DD); 
  strokeWeight(1);
  float triangleHeight = (lengthTriangleNormed / 2) * sqrt(3);
  // links
  triangle(LROffsetNormed - lengthTriangleNormed / 2, groundPosition, LROffsetNormed, groundPosition - triangleHeight, LROffsetNormed + lengthTriangleNormed / 2, groundPosition);
  // rechts
  triangle(LROffsetNormed + fieldWidthNormed - lengthTriangleNormed / 2, groundPosition, LROffsetNormed + fieldWidthNormed, groundPosition - triangleHeight, LROffsetNormed + fieldWidthNormed + lengthTriangleNormed / 2, groundPosition);

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
  curveVertex(LROffsetNormed - plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendLeft);
  curveVertex(LROffsetNormed - plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendLeft); // Startpunkt
  curveVertex(LROffsetNormed, groundPosition - triangleHeight - plankThinkness); // Mittelpunkt
  curveVertex(LROffsetNormed + plankLengthNormedHalf, groundPosition); // Endpunkt
  curveVertex(LROffsetNormed + plankLengthNormedHalf, groundPosition);
  endShape();
  // Planke rechts
  beginShape();
  // Start- und Endpunkt müssen doppelt vorkommen
  curveVertex(LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendRight);
  curveVertex(LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendRight); // Startpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed, groundPosition - triangleHeight - plankThinkness); // Mittelpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed - plankLengthNormedHalf, groundPosition); // Endpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed - plankLengthNormedHalf, groundPosition);
  endShape();


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
   * Außerdem ist bei allem Folgendem etwas Refactoring nötig */
   
  // Ballhalterungen
  fill(100, 160, 215);
  noStroke();
  float triangleShortSideLength = 2.5 * centimeterInPixel;
  float triangleLongSideLength = 4 * centimeterInPixel;

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



}
