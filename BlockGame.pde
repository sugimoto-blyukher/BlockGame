import processing.video.*;
//import processing.camera.*;

Capture cam;

int scene = 0;

void setup() {
    size(1280, 720);
    String[] cameras = Capture.list();
    cam = new Capture(this, 1280, 720, cameras[0]);
    cam.start();
    //startMovie = new Movie(this, "video.mp4");
    //startMovie.play();
}

void draw() {

    switch(scene) {
        case 0:
            //image(startMovie,0,0);
            GameStart();
            break;
        case 1:
            PlayGame();
            break;
        default:
            break;
    }

}

void  GameStart() {
    int m = millis();
    textSize(64);
    textAlign(CENTER, CENTER);
    fill(255);
    if (100 == m) {
        scene = 1;
    } else if (keyPressed == true) {
        scene = 1;
    }
    text("GAME START(to press any keys)", width/2, height/2);
    print("GAME SATRT");
}

void PlayGame() {
    if (cam.available() == true) {
        cam.read();
        image(cam, 0, 0);
    
    }
    print("PLAY GAME");
}

/*
void movieEvent(Movie m) {
  m.read();
}
*/