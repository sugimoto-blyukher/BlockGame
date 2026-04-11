void setup() {
    size(1280, 720, P3D);
    // String[] cameras = Capture.list();
    // cam = new Capture(this, 1280, 720, cameras[0]);
    // cam.start();
    // startMovie = new Movie(this, "video.mp4");
    // startMovie.play();
}

void draw() {
    background(135, 206, 250);
    drawCurrentScene();
}

void mousePressed() {
    if (scene == SCENE_PLAY) {
        bullets.add(new PVector(playerPos.x, playerPos.y, 0));
    }
}

/*
void movieEvent(Movie m) {
  m.read();
}
*/
