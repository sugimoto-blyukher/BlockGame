//import processing.video.*;
//import processing.camera.*;

//Capture cam;

int scene = 0;
ArrayList<PVector> bullets = new ArrayList<PVector>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();
ArrayList<Building> buildings = new ArrayList<Building>();
PVector playerPos = new PVector();

class Building {
    float x, y, z, w, h, d;
    Building(float x, float y, float z, float w, float h, float d) {
        this.x = x; this.y = y; this.z = z;
        this.w = w; this.h = h; this.d = d;
    }
    void update() {
        z += 10;
    }
    void display() {
        pushMatrix(); 
        translate(x, y, z); 
        noStroke();
        fill(255, 255, 255, 150); // 半透明の白
        sphereDetail(8); // 描画負荷軽減
        float s = (w + h + d) / 6.0; // サイズ調整
        sphere(s);
        pushMatrix(); translate(s*0.8, 0, 0); sphere(s*0.7); popMatrix();
        pushMatrix(); translate(-s*0.8, 0, 0); sphere(s*0.7); popMatrix();
        popMatrix();
    }
    boolean checkCollision(float tx, float ty, float tz, float r) {
        return (tx > x - w/2 - r && tx < x + w/2 + r &&
                ty > y - h/2 - r && ty < y + h/2 + r &&
                tz > z - d/2 - r && tz < z + d/2 + r);
    }
}

class Enemy {
    float x, y, z;
    Enemy(float x, float y, float z) {
        this.x = x; this.y = y; this.z = z;
    }
    void update() {
        z += 10;
    }
    void display() {
        pushMatrix(); translate(x, y, z); rotateY(PI); fill(255, 0, 0);
        box(20, 10, 60); // 機体
        pushMatrix(); translate(0, 2, 10); box(80, 2, 20); popMatrix(); // 主翼
        pushMatrix(); translate(0, -5, -25); box(30, 2, 10); popMatrix(); // 尾翼
        popMatrix();
    }
}

class EnemyBullet {
    PVector pos, vel;
    EnemyBullet(float x, float y, float z, float tx, float ty, float tz) {
        pos = new PVector(x, y, z);
        vel = new PVector(tx - x, ty - y, tz - z).normalize().mult(15);
    }
    void update() {
        pos.add(vel);
    }
    void display() {
        pushMatrix(); translate(pos.x, pos.y, pos.z); fill(255, 255, 0); sphere(8); popMatrix();
    }
}

void setup() {
    size(1280, 720, P3D);
    //String[] cameras = Capture.list();
    //cam = new Capture(this, 1280, 720, cameras[0]);
    //cam.start();
    //startMovie = new Movie(this, "video.mp4");
    //startMovie.play();
}

void draw() {
    background(135, 206, 250);

    switch(scene) {
        case 0:
            //image(startMovie,0,0);
            GameStart();
            break;
        case 1:
            PlayGame();
            break;
        case 2:
            GameOver();
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
        bullets.clear();
        enemies.clear();
        enemyBullets.clear();
        buildings.clear();
        scene = 1;
    } else if (keyPressed == true) {
        bullets.clear();
        enemies.clear();
        enemyBullets.clear();
        buildings.clear();
        scene = 1;
    }
    text("GAME START(to press any keys)", width/2, height/2);
    //print("GAME SATRT");
}

void GameOver() {
    camera();
    hint(DISABLE_DEPTH_TEST);
    noLights();
    textAlign(CENTER, CENTER);
    fill(255, 0, 0); textSize(64); text("GAME OVER", width/2, height/2);
    fill(255); textSize(32); text("Click to Title", width/2, height/2 + 80);
    if (mousePressed) {
        scene = 0;
    }
}

void PlayGame() {
    lights();
    
    // HUD (2D表示)
    camera();
    hint(DISABLE_DEPTH_TEST);
    noLights();
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Enemies: " + enemies.size(), 20, 20);
    
    hint(ENABLE_DEPTH_TEST);
    lights();

    // 建物の生成
    if (frameCount % 100 == 0) {
        float bw = random(100, 300);
        float bh = random(100, 300);
        float bd = random(100, 500);
        buildings.add(new Building(random(width), random(height), -2500, bw, bh, bd));
    }

    // 建物の更新と描画
    for (int i = buildings.size() - 1; i >= 0; i--) {
        Building b = buildings.get(i);
        b.update();
        b.display();
        if (b.z > 500) buildings.remove(i);
    }

    // プレイヤーの位置計算（建物との当たり判定と補正）
    playerPos.set(mouseX, mouseY, 0);
    for (Building b : buildings) {
        if (b.checkCollision(playerPos.x, playerPos.y, playerPos.z, 20)) {
            float dx = playerPos.x - b.x;
            float dy = playerPos.y - b.y;
            float ox = (b.w/2 + 20) - abs(dx);
            float oy = (b.h/2 + 20) - abs(dy);
            if (ox < oy) {
                if (dx > 0) playerPos.x += ox; else playerPos.x -= ox;
            } else {
                if (dy > 0) playerPos.y += oy; else playerPos.y -= oy;
            }
        }
    }

    // プレイヤー（戦闘機）の描画
    pushMatrix();
    translate(playerPos.x, playerPos.y, 0);
    // マウス位置に応じた機体の傾き
    rotateZ(radians((playerPos.x - width/2) * 0.1));
    rotateX(radians((playerPos.y - height/2) * 0.1));
    
    noStroke();
    fill(100, 150, 255);
    box(20, 10, 60); // 機体
    pushMatrix(); translate(0, 2, 10); box(80, 2, 20); popMatrix(); // 主翼
    pushMatrix(); translate(0, -5, -25); box(30, 2, 10); popMatrix(); // 尾翼
    popMatrix();

    // 3D照準（機体の前方に表示）
    pushMatrix();
    translate(playerPos.x, playerPos.y, -500);
    stroke(0, 255, 0);
    noFill();
    ellipse(0, 0, 40, 40);
    popMatrix();
    noStroke();
    
    // 敵の生成
    if (frameCount % 30 == 0) {
        enemies.add(new Enemy(random(width), random(height), -2000));
    }
    
    // 敵の更新と描画
    for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy e = enemies.get(i);
        e.update();
        
        // 敵と建物の当たり判定（衝突したら敵消滅）
        boolean crashed = false;
        for (Building b : buildings) {
            if (b.checkCollision(e.x, e.y, e.z, 20)) {
                crashed = true;
                break;
            }
        }
        if (crashed) { enemies.remove(i); continue; }

        e.display();
        
        if (e.z > 500) enemies.remove(i);
    }
    
    // 10秒に一回、ランダムな敵1機が銃撃
    if (frameCount % 600 == 0 && enemies.size() > 0) {
        Enemy shooter = enemies.get(int(random(enemies.size())));
        enemyBullets.add(new EnemyBullet(shooter.x, shooter.y, shooter.z, playerPos.x, playerPos.y, playerPos.z));
    }

    // 敵の弾の更新と描画
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
        EnemyBullet eb = enemyBullets.get(i);
        eb.update();
        eb.display();
        
        // 弾と建物の当たり判定
        boolean hitBuilding = false;
        for (Building build : buildings) {
            if (build.checkCollision(eb.pos.x, eb.pos.y, eb.pos.z, 5)) {
                hitBuilding = true;
                break;
            }
        }
        if (hitBuilding) { enemyBullets.remove(i); continue; }

        // プレイヤーとの当たり判定
        if (dist(eb.pos.x, eb.pos.y, eb.pos.z, playerPos.x, playerPos.y, playerPos.z) < 30) {
            scene = 2; // Game Over
        }
        if (eb.pos.z > 1000 || eb.pos.z < -3000) enemyBullets.remove(i);
    }
    
    // 弾の更新と描画
    for (int i = bullets.size() - 1; i >= 0; i--) {
        PVector b = bullets.get(i);
        b.z -= 50; // 奥へ移動
        
        // 弾と建物の当たり判定
        boolean hitBuilding = false;
        for (Building build : buildings) {
            if (build.checkCollision(b.x, b.y, b.z, 5)) {
                hitBuilding = true;
                break;
            }
        }
        if (hitBuilding) { bullets.remove(i); continue; }

        pushMatrix();
        translate(b.x, b.y, b.z);
        fill(0, 255, 255);
        sphere(10);
        popMatrix();
        
        boolean hit = false;
        for (int j = enemies.size() - 1; j >= 0; j--) {
            if (dist(b.x, b.y, b.z, enemies.get(j).x, enemies.get(j).y, enemies.get(j).z) < 60) {
                enemies.remove(j);
                hit = true;
                break;
            }
        }
        if (hit || b.z < -3000) bullets.remove(i);
    }
}

/*
void movieEvent(Movie m) {
  m.read();
}
*/

void mousePressed() {
    if (scene == 1) {
        bullets.add(new PVector(playerPos.x, playerPos.y, 0));
    }
}
