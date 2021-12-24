/**
 * Bouncy Bubbles  
 * based on code from Keith Peters. 
 * 
 * Multiple-object collision.
 */
 
ParticleSystem ps;

int numBalls = 50;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];

void setup() {
  size(1900, 950);
  for (int i = 0; i < numBalls; i++) {
      balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
  ps = new ParticleSystem(new PVector(width/2, 50));
  noStroke();
}

void draw() {
  background(0);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id, c;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    c = color(int(random(255)), int(random(255)), int(random(255)));
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
        ps.addParticle();
        ps.run(x, y);
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
      c = color(random(255), random(255), random(255));
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
      c = color(random(255), random(255), random(255));
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
      //if (
      c = color(random(255), random(255), random(255));
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
      c = color(random(255), random(255), random(255));
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
    fill(c);
  }
}

// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255.0;
  }

  void run(float x, float y) {
    update();
    display(x, y);
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display(float x, float y) {
    //stroke(255, lifespan);
    fill(random(255), random(255), random(255), lifespan);
    ellipse(x-position.x + (width/4) , y-position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run(float x, float y) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run(x, y);
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
