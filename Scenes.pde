void drawCurrentScene() {
    switch(scene) {
        case SCENE_START:
            drawStartScene();
            break;
        case SCENE_PLAY:
            playGame();
            break;
        case SCENE_GAME_OVER:
            drawGameOverScene();
            break;
        default:
            break;
    }
}

void drawStartScene() {
    int m = millis();

    textSize(64);
    textAlign(CENTER, CENTER);
    fill(255);

    if (m == 100 || keyPressed) {
        startGame();
    }

    text("GAME START(to press any keys)", width / 2, height / 2);
}

void drawGameOverScene() {
    camera();
    hint(DISABLE_DEPTH_TEST);
    noLights();
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(64);
    text("GAME OVER", width / 2, height / 2);
    fill(255);
    textSize(32);
    text("Click to Title", width / 2, height / 2 + 80);

    if (mousePressed) {
        scene = SCENE_START;
    }
}
