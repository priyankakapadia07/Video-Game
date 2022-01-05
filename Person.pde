
class Person {
  //fields
  float x;
  float y;
  float speed;
  float sizeW;
  float sizeH;
  int s;
  float sizeRatio = 10;
  
  PImage graphic; 

  Person (PImage g, float _sizePercent) {
    
    graphic = g;
    
    sizeW = graphic.width * _sizePercent;
    sizeH = graphic.height * _sizePercent;
    
    x = random(width);
    y = height/2 - sizeH / 2;
    
    
    speed = 5 * _sizePercent; //Speed controls
  }

  void display() {
    //image(img0, x, y, sizeW * sizeRatio, sizeH * sizeRatio); //Loaded image + coords
    imageMode(CORNER);
    image(graphic, x, y, sizeW, sizeH);
    x += speed;
    if (x > width+sizeW) x = -sizeW;
  }
}
