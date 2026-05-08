import processing.video.*;

Capture cam;
PImage capturedTexture;

void setup() {
    fullScreen(P3D);
    String[] cameras = Capture.list();
    cam = new Capture(this, displayWidth, displayHeight, cameras[0]);
    cam.start();
    // startMovie = new Movie(this, "video.mp4");
    // startMovie.play();
}

void draw() {
    background(135, 206, 250);
    if (cam.available()) {
        cam.read();
    }
    image(cam, 0,0);

    drawCurrentScene();

}

void mousePressed() {
    if (scene == SCENE_PLAY) {
        bullets.add(new PVector(playerPos.x, playerPos.y, 0));
    }
}

void captureCam() {
    // カメラ画像の中央から500x500の正方形を切り抜く
    int cropSize = 500;
    int startX = (width - cropSize) / 2;
    int startY = (height - cropSize) / 2;
    capturedTexture = cam.get(startX, startY, cropSize, cropSize);
    println("Captured texture: " + startX + ", " + startY + ", " + cropSize + "x" + cropSize);
}

/*
void movieEvent(Movie m) {
  m.read();
}
*/
