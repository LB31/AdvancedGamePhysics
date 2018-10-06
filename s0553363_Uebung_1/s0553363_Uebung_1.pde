/*
Leonid Barsht
s0553363
04.10.2018
*/

// Stell dar, wie viele Pixel = 1 Centimeter
float centimeterInPixel;
// Der Abstand des Bodens vom unteren Bildschirmrand
float offsetGround;


void setup() {
  size(1000 , 400);
  background(255);
  centimeterInPixel = width / 160;
  offsetGround = centimeterInPixel * 5;
  print(centimeterInPixel);
}



//translate(140, 0);

// Draw - is the game loop
void draw(){
  
stroke(133,102,0);

line(0,height - offsetGround,centimeterInPixel*160,height - offsetGround);
for(int i = 0; i < width; i+=2){
line(i,height - offsetGround,i-2, height);  
}

// Draw white point
stroke(100);
point(100, 100);
}
