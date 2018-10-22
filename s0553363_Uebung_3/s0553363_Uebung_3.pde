/* Leonid Barsht //<>//
 * s0553363
 * 18.10.2018 */
 

float meterInPixel; // Stell dar, wie viele Pixel = 1 Meter; Maßstab M
float offsetGround; // Der Abstand des Bodens vom unteren Bildschirmrand
int frameRate = 60; // Gewünschte Framerate
// Zeit
float deltaT = 1 / (float)frameRate;
float timeScale = 0.1; // < 1 = langsamer; > 1 = schneller
float deltaTtimeLapse = timeScale * deltaT; // Zeitraffer
float speed = 500 / 60f / 60f; // 0.5 km/h auf Sekunden runtergerechnet
float t = 0; // bereits vergangene Zeit
// Maße
float wholeWidth = 1.60; // Gesamte Breite in m → 1,2m + L+R Offset
float fieldWidth = 1.20; // Spielfeld Breite in m
float LROffset = 0.20; // Länge des Offsets links und rechts in m
float targetBallWidth = 0.032; // Spielball Durchmesser in m
float lengthTriangle = 0.04; // Seitenlänge der Dreiecke in m
float plankLength = 0.25; // Planke Länge in m
float groundPosition; // Position des Bodenlinie
float g = 9.81; // Schwerkraft in m / s²
// Punktestand der Spieler
int pointsLeft = 0;
int pointsRight = 0;
// Positionen der Ziellinien
float leftGoalX = Float.MAX_VALUE;
float rightGoalX = Float.MAX_VALUE;
// Bewegung roter Ball
float movement = 0; // Für den in jedem Frame berechneten X-Wert des roten Balls verantwortlich 
float startPointBall = 0; // Start Position des roten Balls
boolean movingDirection = false; // false = right; true = left
// Bewegung Geschützbälle
boolean leftIsFlying; // Ob der linke Ball fliegt
boolean rightIsFlying; // Ob der rechte Ball fliegt
float leftStartY; // Y Startposition linker Ball
float rightStartY; // Y Startposition rechter Ball
boolean startYSet; // Ob die Startpositionen bereits abgespeichtert wurden


void setup() {
  //fullScreen();
  size(1200, 1000);
  background(255);
  frameRate(frameRate);
  smooth();
  meterInPixel = width / wholeWidth; 
  offsetGround = normValue(0.05); // 5cm Abstand
  groundPosition = height - offsetGround; // Boden Position
}



// Draw - is the game loop
void draw() {
  drawPlayField();
  // Zeit vergeht nur, wenn einer der Bälle sich bewegt
  if (leftIsFlying || rightIsFlying)
    t += deltaTtimeLapse;
}

void mousePressed() {
  // Linker Button
  if (mouseX < normValue(targetBallWidth*2) && mouseY < groundPosition && mouseY > groundPosition - normValue(targetBallWidth*2)) {
    if (!leftIsFlying && !rightIsFlying) {
      leftIsFlying = true;
      println("Linker Ball");
    }
  }
  // Rechter Button
  if (mouseX > width - normValue(targetBallWidth*2) && mouseY < groundPosition && mouseY > groundPosition - normValue(targetBallWidth*2)) {
    if (!leftIsFlying && !rightIsFlying) {
      rightIsFlying = true;
      println("Rechter Ball");
    }
  }
}

// Wandelt den übergebenen Wert entsprechend des Maßstabs um
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
  textSize(normValue(textSize));
  text("Treffer " + pointsLeft + ":" + pointsRight, width / 2.0f - textWidth, height / 3);


  int groundThickness = 2; // Boden Dicke

  // Skalierte Werte
  float ballWidthNormed = normValue(targetBallWidth);
  float fieldWidthNormed = normValue(fieldWidth);
  float LROffsetNormed = normValue(LROffset);
  float lengthTriangleNormed = normValue(lengthTriangle);
  float plankLengthNormedHalf = normValue(plankLength) / 2f;
  float wholeWidthNormed = normValue(wholeWidth);

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


  /* Bei der Aufgabenstellung war mir leider nicht klar, ob der Ball nun permanent hin und her
   * rollen, oder ob dieser beim Erreichen des ersten Ziels anhalten soll.
   * Aktuell rollt dieser hin und her. Würde ich diesen anhalten wollen, könnte ich z.B.
   * die Variable speed in der folgenden Bedigung auf 0 setzen */
  leftGoalX = -LROffsetNormed*2 - ballWidthNormed/2;
  rightGoalX = LROffsetNormed*2 + ballWidthNormed/2;
  movement = startPointBall + t * speed;
  if ( movement <= leftGoalX || movement >= rightGoalX) { // Wenn eine der roten Linien erreicht wurde
    t = 0;
    speed *= -1;
    if (movingDirection) {
      startPointBall = leftGoalX; // Startposition auf aktuelle Position ändern
      movingDirection = !movingDirection; // Richtung umdrehen
    } else {
      startPointBall = rightGoalX;
      movingDirection = !movingDirection;
    }
  }

  // Roter Ball in der Mitte
  fill(250, 131, 100);
  ellipse(movement, ballWidthNormed / 2 + groundThickness, ballWidthNormed, ballWidthNormed);

  // Start Buttons
  fill(250, 0, 0);
  // links
  ellipse(-wholeWidthNormed/2f + ballWidthNormed, ballWidthNormed*2 / 2 + groundThickness, ballWidthNormed*2, ballWidthNormed*2);
  // rechts
  ellipse(wholeWidthNormed/2f - ballWidthNormed, ballWidthNormed*2 / 2 + groundThickness, ballWidthNormed*2, ballWidthNormed*2);

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



  // Ballhalterungen (Dreiecke auf den Planken)
  fill(100, 160, 215);
  noStroke();
  float triangleShortSideLength = normValue(0.025);
  float triangleLongSideLength = normValue(0.04);

  // links
  float x1 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength; // check
  float y1 = gradientPlankLeft * x1 + plusBLeft;
  // rechts
  float x2 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength * 2;
  float y2 = gradientPlankLeft * x2 + plusBLeft;
  // Spitze
  float x3 = -fieldWidthNormed / 2 - plankLengthNormedHalf + triangleLongSideLength * 1.7;
  float y3 = gradientPlankLeft * x3 + plusBLeft + triangleShortSideLength;
  triangle(x1, y1, x2, y2, x3, y3);



  // rechts
  float x12 = fieldWidthNormed / 2 + plankLengthNormedHalf - triangleLongSideLength;
  float y12 = gradientPlankRight * x12 + plusBRight;
  // links
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
  
  // Startpositionen abspeichern
  if (!startYSet) {
    startYSet = true;
    leftStartY = y3;
    rightStartY = y32;
  }

  // links
  ellipse(x1, calcBallFflight(y3, leftIsFlying), ballWidthNormed, ballWidthNormed);
  // rechts
  ellipse(x12, calcBallFflight(y32, rightIsFlying), ballWidthNormed, ballWidthNormed);
  scale(1, -1); // Dreht die Szene wieder um, damit die Schrift korrekt dargestellt wird
  // Text in Bällen
  fill(#0000FF);
  float textOffsetX = 4;
  float textOffsetY = 8;
  textSize(normValue(textSize) / 2f);
  text("L", x1 - textOffsetX, (calcBallFflight(y1, leftIsFlying) + textOffsetY) * - 1);
  text("R", x12 - textOffsetX, (calcBallFflight(y12, rightIsFlying) + textOffsetY) * -1);


  popMatrix();
}

// Geschützball Kinematik
public float calcBallFflight(float startY, boolean flying) {
  float v0 = 4.8; // Anfangsgeschwindigkeit
  float h0 = startY / meterInPixel; // Setzt den bereits an das Spielfeld angepassten Wert auf die Größe im echten Leben zurück
  float flyingY = normValue(-g * sq(t)/2 + v0 * t + h0); 
  // Nach einer gewissen Zeit (um den Start zu übergehen), wenn wieder die Startposition erreicht wurde, wird alles zurückgesetzt
  if (t > 0.2 && (flyingY <= leftStartY || flyingY <= rightStartY)) {
    leftIsFlying = false;
    rightIsFlying = false;
    t = 0;
  }
  if (flying) {
    return flyingY;
  }
  return startY;
}
