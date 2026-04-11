class Building {
    float x, y, z, w, h, d;

    Building(float x, float y, float z, float w, float h, float d) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
        this.h = h;
        this.d = d;
    }

    void update() {
        z += 10;
    }

    void display() {
        pushMatrix();
        translate(x, y, z);
        noStroke();
        fill(255, 255, 255, 150);
        sphereDetail(8);
        float s = (w + h + d) / 6.0;
        sphere(s);
        pushMatrix();
        translate(s * 0.8, 0, 0);
        sphere(s * 0.7);
        popMatrix();
        pushMatrix();
        translate(-s * 0.8, 0, 0);
        sphere(s * 0.7);
        popMatrix();
        popMatrix();
    }

    boolean checkCollision(float tx, float ty, float tz, float r) {
        return tx > x - w / 2 - r && tx < x + w / 2 + r &&
               ty > y - h / 2 - r && ty < y + h / 2 + r &&
               tz > z - d / 2 - r && tz < z + d / 2 + r;
    }
}

class Enemy {
    float x, y, z;

    Enemy(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    void update() {
        z += 10;
    }

    void display() {
        pushMatrix();
        translate(x, y, z);
        rotateY(PI);
        fill(255, 0, 0);
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
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        fill(255, 255, 0);
        sphere(8);
        popMatrix();
    }
}
