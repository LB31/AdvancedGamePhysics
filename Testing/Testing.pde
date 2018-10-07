//void setup() {
  size(1000, 400);
//  // keine Umrandung
//  noStroke();
//  // anti-alising
  smooth();
//  background(#dfdfdf);
//}

//void draw() {
  
  
  // Bezier Curve
  noFill();
  stroke(#0000FF);
  strokeWeight(3);
  bezier(100,50,180,20,50,200,300,250);
  // Visualisierung control points
  stroke(0);
  line(100,50,180,20);
  line(50,200,300,250);
  
  //noFill();
  //beginShape();
  //// Start- und Endpunkt müssen aus Gründen doppelt vorkommen
  //curveVertex(200,100);
  //curveVertex(200,100);
  //curveVertex(400,200);
  //curveVertex(600,300);
  //curveVertex(800,100);
  //curveVertex(800,100);
  //endShape();


  
  //noFill();
  //curveTightness(-2);
  //curve(300,100,100,100,200,100,0,0);
  

  //beginShape();
  //vertex(20,50);
  //vertex(100,150);
  //vertex(120,170);
  //vertex(90,100);
  //// CLOSE Parameter schließt das Polygon
  //endShape(CLOSE);
  
  
  //quad(50,50, 300, 10, 500,300,10,388);
  
  //triangle(0,0,100,200,10,100);
  
  //// xLinks, yLinks, Breite, Höhe
  //rect(0, 0, 50, 50);
  
  //// Position von Mitte aus
  //rectMode(CENTER);
  //rect(0, 0, 50, 50);
  
    
  //rectMode(CORNERS);
  //rect(50, 50, 100, 100);
  
  
  //noFill();
  //// arc(xMitte, yMitte, Breite, Höhe, Startwinkel in PI; beginnt bei 45 Grad, Endwinkel +=; PI = 180
  //arc(100, 150, 100, 100, PI, PI*2);
  
  //// radians Wandelt die Gradzahl um
  //arc(200, 250, 150, 150, 0, radians(180));
  
  //stroke(255, 0, 0);
  //strokeWeight(1);
  //fill(200,100,50,255);
  //// Position beschreibt die Mitte
  //ellipse(100, 200, 100, 150);
  
  //// Ändert die Positionsbeschreibung der Ellipse an die obere linke 'Ecke'
  //ellipseMode(CORNER);
  //fill(0,100,50,10);
  //ellipse(width-100, 0, 100, 100);

  //// Umrandung
  //stroke(255, 0, 0);
  //// Randdicke
  //strokeWeight(20);
  //point(600, 200);


  //stroke(0, 255, 0);
  //fill(50, 0, 250);
  //ellipse(100, 100, 50, 100);
//}

//void mousePressed() {
//  fill(200, 0, 0, 255);
//}

//void mouseReleased() {
//  fill(200, 0, 0, 0);
//}
