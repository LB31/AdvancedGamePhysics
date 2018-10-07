/*
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
float wholeWith = 160;
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
  fullScreen();
  //size(1000, 400);
  background(#dfdfdf);
  frameRate(frameRate);
  smooth();
  centimeterInPixel = width / wholeWith; 
  offsetGround = centimeterInPixel * 5; // 5cm Abstand
  print(centimeterInPixel);
}


// Draw - is the game loop
void draw() {
  drawPlayField();
}


void drawPlayField() {
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

  // Dreiecke
  fill(100, 160, 215);
  stroke(0); 
  float triangleHeight = (lengthTriangleNormed / 2) * sqrt(3);
  // Dreieck links
  triangle(LROffsetNormed - lengthTriangleNormed / 2, groundPosition, LROffsetNormed, groundPosition - triangleHeight, LROffsetNormed + lengthTriangleNormed / 2, groundPosition);
  // Dreieck rechts
  triangle(LROffsetNormed + fieldWidthNormed - lengthTriangleNormed / 2, groundPosition, LROffsetNormed + fieldWidthNormed, groundPosition - triangleHeight, LROffsetNormed + fieldWidthNormed + lengthTriangleNormed / 2, groundPosition);

  // Planken
  float plankThinkness = 4;
  // Beim Verändern dieser Werte wird die Planke gebogen
  float plankBendLeft = 1.8;
  float plankBendRight = 1.8;

  stroke(100, 160, 215);
  strokeWeight(plankThinkness);
  // Planke links
  beginShape();
  // Start- und Endpunkt müssen aus Gründen doppelt vorkommen
  curveVertex(LROffsetNormed - plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendLeft);
  curveVertex(LROffsetNormed - plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendLeft); // Startpunkt
  curveVertex(LROffsetNormed, groundPosition - triangleHeight - plankThinkness); // Mittelpunkt
  curveVertex(LROffsetNormed + plankLengthNormedHalf, groundPosition); // Endpunkt
  curveVertex(LROffsetNormed + plankLengthNormedHalf, groundPosition);
  endShape();
  // Planke rechts
  beginShape();
  // Start- und Endpunkt müssen aus Gründen doppelt vorkommen
  curveVertex(LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendRight);
  curveVertex(LROffsetNormed + fieldWidthNormed + plankLengthNormedHalf, groundPosition - plankThinkness - lengthTriangleNormed * plankBendRight); // Startpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed, groundPosition - triangleHeight - plankThinkness); // Mittelpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed - plankLengthNormedHalf, groundPosition); // Endpunkt
  curveVertex(LROffsetNormed + fieldWidthNormed - plankLengthNormedHalf, groundPosition);
  endShape();


  // Draw point
  stroke(#ff0000);
  strokeWeight(5);
  point(LROffsetNormed, groundPosition);
}
