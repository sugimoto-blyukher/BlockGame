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
    PImage texture;
    /*
    Enemy(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.texture = null;
    }
    */
    Enemy(float x, float y, float z, PImage texture) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.texture = texture;
    }

    void update() {
        z += 10;
    }

    void display() {
        pushMatrix();
        translate(x, y, z);
        
        if (texture != null) {
            texture(this.texture);
            textureMode(IMAGE);
            fill(255);
            drawTexturedBox(400, 400, 400);
        } else {
            fill(255, 0, 0);
            box(400, 400, 400);
        }
        
        popMatrix();
    }
    
    void drawTexturedBox(float w, float h, float d) {
        float x1 = -w/2, x2 = w/2;
        float y1 = -h/2, y2 = h/2;
        float z1 = -d/2, z2 = d/2;
        
        beginShape(QUADS);
        // Front
        texture(this.texture);
        vertex(x1, y1, z2, 0, 0);
        vertex(x2, y1, z2, 500, 0);
        vertex(x2, y2, z2, 500, 500);
        vertex(x1, y2, z2, 0, 500);
        // Back
        vertex(x2, y1, z1, 0, 0);
        vertex(x1, y1, z1, 50, 0);
        vertex(x1, y2, z1, 50, 50);
        vertex(x2, y2, z1, 0, 50);
        // Top
        vertex(x1, y1, z1, 0, 0);
        vertex(x2, y1, z1, 500, 0);
        vertex(x2, y1, z2, 500, 500);
        vertex(x1, y1, z2, 0, 500);
        // Bottom
        vertex(x1, y2, z2, 0, 0);
        vertex(x2, y2, z2, 500, 0);
        vertex(x2, y2, z1, 500, 500);
        vertex(x1, y2, z1, 0, 500);
        // Left
        vertex(x1, y1, z1, 0, 0);
        vertex(x1, y1, z2, 500, 0);
        vertex(x1, y2, z2, 500, 500);
        vertex(x1, y2, z1, 0, 500);
        // Right
        vertex(x2, y1, z2, 0, 0);
        vertex(x2, y1, z1, 500, 0);
        vertex(x2, y2, z1, 500, 500);
        vertex(x2, y2, z2, 0, 500);
        endShape();
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
