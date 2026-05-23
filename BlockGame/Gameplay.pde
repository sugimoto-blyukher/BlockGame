void playGame() {
    lights();
    drawHud();
    spawnBuildingIfNeeded();
    updateBuildings();
    updatePlayer();
    drawPlayer();
    drawReticle();
    spawnEnemyIfNeeded();
    updateEnemies();
    fireEnemyBulletIfNeeded();
    updateEnemyBullets();
    updatePlayerBullets();
}

void drawHud() {
    camera();
    hint(DISABLE_DEPTH_TEST);
    noLights();
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Enemies: " + enemies.size(), 20, 20);
    hint(ENABLE_DEPTH_TEST);
    lights();
}

void spawnBuildingIfNeeded() {
    if (frameCount % 100 != 0) {
        return;
    }

    float bw = random(100, 300);
    float bh = random(100, 300);
    float bd = random(100, 500);
    buildings.add(new Building(random(width), random(height), -2500, bw, bh, bd));
}

void updateBuildings() {
    for (int i = buildings.size() - 1; i >= 0; i--) {
        Building building = buildings.get(i);
        building.update();
        building.display();

        if (building.z > 500) {
            buildings.remove(i);
        }
    }
}

void updatePlayer() {
    playerPos.set(mouseX, mouseY, 0);
    resolvePlayerBuildingCollision();
}

void resolvePlayerBuildingCollision() {
    for (Building building : buildings) {
        if (!building.checkCollision(playerPos.x, playerPos.y, playerPos.z, 20)) {
            continue;
        }

        float dx = playerPos.x - building.x;
        float dy = playerPos.y - building.y;
        float ox = (building.w / 2 + 20) - abs(dx);
        float oy = (building.h / 2 + 20) - abs(dy);

        if (ox < oy) {
            if (dx > 0) {
                playerPos.x += ox;
            } else {
                playerPos.x -= ox;
            }
        } else {
            if (dy > 0) {
                playerPos.y += oy;
            } else {
                playerPos.y -= oy;
            }
        }
    }
}

void drawPlayer() {
    pushMatrix();
    translate(playerPos.x, playerPos.y, 0);
    rotateZ(radians((playerPos.x - width / 2) * 0.1));
    rotateX(radians((playerPos.y - height / 2) * 0.1));
    noStroke();
    fill(100, 150, 255);
    box(20, 10, 60);
    pushMatrix();
    translate(0, 2, 10);
    box(80, 2, 20);
    popMatrix();
    pushMatrix();
    translate(0, -5, -25);
    box(30, 2, 10);
    popMatrix();
    popMatrix();
}

void drawReticle() {
    pushMatrix();
    translate(playerPos.x, playerPos.y, -500);
    stroke(0, 255, 0);
    noFill();
    ellipse(0, 0, 40, 40);
    popMatrix();
    noStroke();
}

void spawnEnemyIfNeeded() {
    if (frameCount % 30 == 0) {
        enemies.add(new Enemy(random(width), random(height), -500, capturedTexture));
    }
}

void updateEnemies() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        enemy.update();

        if (hitsAnyBuilding(enemy.x, enemy.y, enemy.z, 20)) {
            enemies.remove(i);
            continue;
        }

        enemy.display();

        if (enemy.z > 500) {
            enemies.remove(i);
        }
    }
}

void fireEnemyBulletIfNeeded() {
    if (frameCount % 600 != 0 || enemies.size() == 0) {
        return;
    }

    Enemy shooter = enemies.get(int(random(enemies.size())));
    enemyBullets.add(new EnemyBullet(
        shooter.x,
        shooter.y,
        shooter.z,
        playerPos.x,
        playerPos.y,
        playerPos.z
    ));
}

void updateEnemyBullets() {
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
        EnemyBullet bullet = enemyBullets.get(i);
        bullet.update();
        bullet.display();

        if (hitsAnyBuilding(bullet.pos.x, bullet.pos.y, bullet.pos.z, 5)) {
            enemyBullets.remove(i);
            continue;
        }

        if (dist(bullet.pos.x, bullet.pos.y, bullet.pos.z, playerPos.x, playerPos.y, playerPos.z) < 30) {
            scene = SCENE_GAME_OVER;
        }

        if (bullet.pos.z > 1000 || bullet.pos.z < -3000) {
            enemyBullets.remove(i);
        }
    }
}

void updatePlayerBullets() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
        PVector bullet = bullets.get(i);
        bullet.z -= 50;

        if (hitsAnyBuilding(bullet.x, bullet.y, bullet.z, 5)) {
            bullets.remove(i);
            continue;
        }

        drawPlayerBullet(bullet);

        if (hitEnemy(bullet) || bullet.z < -3000) {
            bullets.remove(i);
        }
    }
}

boolean hitsAnyBuilding(float x, float y, float z, float radius) {
    for (Building building : buildings) {
        if (building.checkCollision(x, y, z, radius)) {
            return true;
        }
    }
    return false;
}

void drawPlayerBullet(PVector bullet) {
    pushMatrix();
    translate(bullet.x, bullet.y, bullet.z);
    fill(0, 255, 255);
    sphere(10);
    popMatrix();
}

boolean hitEnemy(PVector bullet) {
    for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        if (dist(bullet.x, bullet.y, bullet.z, enemy.x, enemy.y, enemy.z) < 60) {
            enemies.remove(i);
            return true;
        }
    }
    return false;
}
