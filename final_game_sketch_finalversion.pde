import com.hamoid.*;

//group members: Dana Higuchi, Priyanka Kapadia, Ameena Pathan
//Game: Hands up!
//Town Image found from: https://scubasanmateo.com/explore/town-clipart-abstract/ 
//Music from Ryerson audio library "Chasing"

VideoExport videoExport;

Parallax[] test = new Parallax[10];
Person[] people = new Person[10];
import processing.sound.*;

PImage girlImg;
PImage guyImg;
PImage WomanImg;
PImage robberImg;
PImage img5;
PImage img6;
PImage img7;
PImage City;


int Opening = 0;
int Background = 1;
int Win = 2;
int GameOver = 3;

int gameState = Opening;

int Score = 0;
int Lives = 3;

SoundFile music;

void setup() {
  size(800, 800); 
  
  videoExport = new VideoExport(this);
  videoExport.startMovie();
  
  imageMode(CENTER);

  music = new SoundFile(this, "Song.wav");
  music.loop();

  girlImg = loadImage("Girl.png");
  guyImg = loadImage("Guy.png");
  WomanImg= loadImage("Woman.png");
  robberImg =loadImage("Robber.png");
  img5 =loadImage("GameOver.png");
  img6 =loadImage("Win.png");
  img7 =loadImage("Opening.png");
  City =loadImage("City.jpg");

  for (int i=0; i < 10; i++) { 
    float w = map(i, 0, 10, 20, 100);
    test[i] = new Parallax(w);
  }

  for (int i=0; i < people.length; i++) { 
    float w = map(i, 0, 10, 0.2, 1.5);
    // first two (i=0, i=1) will be robbers 
    if ( i < 2 ) {
      people[i] = new Person(robberImg, w);
    }
    // civilians 
    else {
      // come up with some other method 

      if (random(1) < 0.33) { 
        people[i] = new Person(girlImg, w);
      } else {
        people[i] = new Person(guyImg, w);
      }
      if (random(1) < 0.66) {
        people [i] = new Person(WomanImg, w);
      }
    }
  }
}


void draw() {
  background(128); 
  if (gameState == Opening) opening();
  else if (gameState == Background) backGround();
  else if (gameState == GameOver) gameOver();
  
  videoExport.saveFrame();
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}

void backGround() {
  imageMode(CENTER);
  image(City, width/2, height/2); //background image


  fill(255);
  //for (Parallax p : test) p.display(); // rectangles 
  for (Person g : people) g.display();

  //target 
  noFill();
  ellipse(mouseX, mouseY, 50, 50);
  line(mouseX-25, mouseY, mouseX+25, mouseY);
  line(mouseX, mouseY-25, mouseX, mouseY+25);

  //text
  fill(#02A7F7);
  textSize(20);
  text("Score: " + Score, 10, 30);

  textSize(20);
  text("Lives: " + Lives, 700, 30);
}



class Parallax {
  float x;
  float y;
  float speed; 
  float sizeW;
  float sizeH;

  Parallax(float _size) { 
    x = 0;  // try random(width) here also
    y = height/2;
    sizeW = _size;
    sizeH = _size*2;  

    // 40 is like a "speed factor". Lower to increase speed, raise to slow down
    // the main idea is to keep speed proportional to the size, to create the pseudo-3D
    // effect
    speed = _size / 40;
  }

  void display() {
    x += speed;
    if (x > width+sizeW) x = -sizeW;
    rectMode(CENTER); 
    rect(x, y, sizeW, sizeH);
  }
}


void opening() {
  imageMode(CENTER);
  image(img7, width/2, height/2); //Opening Image

  fill(#FFF41F);
  textSize(27);
  text("INSTRUCTIONS", 303, 543);
  fill(255);
  textSize(15);
  text("Gain points by shooting the robber!", 275, 578);
  textSize(15);
  text("3 citizen deaths = Game Over", 295, 607);

  fill(255, 0, 0); 
  textSize(29);
  text("Good Luck!!", 325, 689);
}


void gameOver() {
  imageMode(CENTER);
  image(img5, width/2, height/2); //Game Over Image
  fill(#02A7F7);
  textSize(50);
  text("Score: " + Score, 303, 184);
}

void mousePressed() {
  // Changing the game state simply means updating the value of "gameState" to 
  // contain a different number
  if (gameState == Opening) {
    gameState = Background;
  } 
  if (gameState == GameOver) {

    gameState = Opening;
    Score = 0;
    Lives = 3;
  } else if (gameState == Background) {

    for (int i=people.length-1; i >= 0; i--) {
      Person p = people[i];
      // is the mouse cursor over "p"??
      if ( mouseX > p.x && mouseX < p.x + p.sizeW ) { 
        if (mouseY > p.y && mouseY < p.y + p.sizeH) { 
          // found a hit  
          p.x = -p.sizeW;   


          // see if we did a good or a bad thing 
          if (p.graphic == robberImg) {
            // YES!  
            Score++;
          } else {
            // Nooooooo... 

            Lives--;
            if (Lives == 0) {  
              gameState = GameOver;
            }
          }

          break;
        }// cancel the loop
      }
    }
  }
}
