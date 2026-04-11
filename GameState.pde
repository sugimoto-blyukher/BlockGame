final int SCENE_START = 0;
final int SCENE_PLAY = 1;
final int SCENE_GAME_OVER = 2;

int scene = SCENE_START;

ArrayList<PVector> bullets = new ArrayList<PVector>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();
ArrayList<Building> buildings = new ArrayList<Building>();

PVector playerPos = new PVector();

void resetGameState() {
    bullets.clear();
    enemies.clear();
    enemyBullets.clear();
    buildings.clear();
}

void startGame() {
    resetGameState();
    scene = SCENE_PLAY;
}
