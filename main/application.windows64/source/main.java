import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

//Definindo coordenadas
static Point Objective_Final;                                                     //Ponto do objetivo final
int x_final = 640, y_final = 620;                                                 //Coordenadas do objetivo
int Objective_Size = 20;                                                          //Tamanho do objetivo final

int population_size = 500;                                                        //Tamanho população
int generation = 0;                                                               //Variável de controle das gerações

FlyPopulation population;
static boolean dead;


static Point p1_init , p1_end, p2_init, p2_end, p3_init, p3_end;                  //Pontos do obstáculos
float r =  3;     // circle radius

public void setup(){
  
  background(0);
  frameRate(301989888);                         
  population = new FlyPopulation(population_size);
  
  
  p1_init = new Point(400, height / 2 );
  p1_end = new Point(width - 400, height / 2);
  
  p2_init = new Point(200,400);
  p2_end = new Point(500,600);
  
  p3_init = new Point(1080,400);
  p3_end = new Point(780,600);
  
  Objective_Final = new Point(x_final, y_final);
  
  strokeWeight(5);    // make it a little easier to see
}

public void draw(){
  background(0);
  strokeWeight(5);
  stroke(255);
  line(p1_init.x , p1_init.y , p1_end.x , p1_end.y);                            //Desenha o obstáculo
  line(p2_init.x , p2_init.y , p2_end.x , p2_end.y);                            //Desenha o obstáculo
  line(p3_init.x , p3_init.y , p3_end.x , p3_end.y);                            //Desenha o obstáculo

  fill(255,255,0);
  textSize(32);
  text("Generation: " + generation, 10, 40);
  
  population.update();
  population.show();
  if(!dead)
  population.allDeadCheck();
  
  fill(255,0,0);
  ellipse(Objective_Final.x,Objective_Final.y,Objective_Size,Objective_Size);  //Desenha o objetivo final
}


//Escolhe a posição do final manualmente
public void mouseClicked(){
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final);                            
   population = new FlyPopulation(population_size);                                         //Reseta e cria uma nova população
   generation = 0;
}
class Collision{
  float x1; 
  float y1; 
  float x2; 
  float y2; 
  float cx; 
  float cy; 
  float r;
  Collision(float x1, float y1, float x2, float y2, float r){
      this.x1 = x1; 
      this.y1 = y1; 
      this.x2 = x2; 
      this.y2 = y2; 
      this.r = r;
    }
// LINE/CIRCLE
public boolean lineCircle(float cx, float cy) {
  float x1 = this.x1; 
  float y1 = this.y1; 
  float x2 = this.x2; 
  float y2 = this.y2; 
  float r = this.r;
  
  // is either end INSIDE the circle?
  // if so, return true immediately
  boolean inside1 = pointCircle(x1,y1, cx,cy,r);
  boolean inside2 = pointCircle(x2,y2, cx,cy,r);
  if (inside1 || inside2) return true;

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(x1,y1,x2,y2, closestX,closestY);
  if (!onSegment) return false;

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= r) {
    return true;
  }
  return false;
}


// POINT/CIRCLE
public boolean pointCircle(float px, float py, float cx, float cy, float r) {

  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  float distX = px - cx;
  float distY = py - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the circle's
  // radius the point is inside!
  if (distance <= r) {
    return true;
  }
  return false;
}


// LINE/POINT
public boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

  // get distance from the point to the two ends of the line
  float d1 = dist(px,py, x1,y1);
  float d2 = dist(px,py, x2,y2);

  // get the length of the line
  float lineLen = dist(x1,y1, x2,y2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1f;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}
}
class Direction{

  PVector[] directions;
  int index;
  
  Direction(int s){
    directions = new PVector[s];
    for(int i = 0 ; i < s ; i++){
      directions[i] = PVector.fromAngle(random(PI*2));
    }
  }
}
class FlyPopulation{

 Fly[] flies ;
 int s;
 int allDead;
 
 
 FlyPopulation(int s){
   this.s = s;
   flies = new Fly[s];
 
 for(int i = 0; i < s ; i++){
    flies[i] = new Fly(width/2  ,20);
   }
 
 }
 
 public void update(){
  for(int i = 0; i < this.s ; i++){
    flies[i].update();
   }
 }
 
 public void show(){
  for(int i = 0; i < s ; i++){
    
    flies[i].show();
   }
 }
 
 public void allDeadCheck(){
   allDead = 0;
   for(int i = 0 ; i < s ; i++){
   
     if(flies[i].canNotMove){
     allDead++;
     }
   }
   
   if(allDead == s){
    main.dead = true;
    println('d');
    newPopulation();
   }
 }
 
 
public void newPopulation(){
    generation++;
    main.dead = false;
	
    Fly bestFly = updateFitness();

	Fly[] newflies = new Fly[s];
	newflies[0] = new Fly(width/2  ,20);
	newflies[1] = new Fly(width/2  ,20);

	newflies[0].copy(bestFly);
	newflies[1].copy(bestFly);

    for(int i = 2; i < s ; i++){

		Fly bestFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
		//Random pool of individuals, the best ones are mated 
		for(int j = 0; j < 20; j++){
			Fly newFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
			if(newFlyMate.fitness < bestFlyMate.fitness ){
				bestFlyMate = newFlyMate;
			}
		}

		Fly bestFlyMateMother = flies[abs(PApplet.parseInt(random(s)) -1 )];

		//Random pool of individuals, the best ones are mated 
		for(int j = 0; j < 20; j++){
			Fly newFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
			if(newFlyMate.fitness < bestFlyMateMother.fitness ){
				bestFlyMateMother = newFlyMate;
			}
		}

	    newflies[i] = new Fly(width/2  ,20);
      	newflies[i].mate(bestFlyMateMother,bestFlyMate);
    }

	for(int i = 0; i < s; i++){
		flies[i] = new Fly(width/2  ,20);
		flies[i].copy(newflies[i]);
	}
	

    allDead = 0;
}

 
public Fly updateFitness(){
   Fly result = flies[0];
   float record = 100000;
   
  for(int i = 0; i < s ; i++){
    
    float dis = dist(flies[i].position.x , flies[i].position.y , main.Objective_Final.x , main.Objective_Final.y);

	flies[i].fitness = dis;

    if(dis < record){
      record = dis;
      result = flies[i];
    }
  
  }
 return result;
 
 }
}
class Fly{
PVector position;

PVector velocity;

PVector accelerate;

boolean canNotMove;

int index ;

float fitness = 0;

Direction dir;

Collision line1; //Linha de obstáculo 1
Collision line2; //Linha de obstáculo 2
Collision line3; //Linha de obstáculo 3

Fly(int x , int y){
position = new PVector(x,y);
velocity = new PVector(0,0);
dir = new Direction(2000);

index = 0;
canNotMove = false;
}

public void update(){
  obstecleCheck();
  
  if(canNotMove){
  return;
  }
  
    
  accelerate = dir.directions[index];
  index++;
  velocity.add(accelerate);
  velocity.limit(5);
  position.add(velocity);

}

public void show(){
  fill(255,255,0);
  noStroke();
  ellipse(this.position.x , this.position.y , 5,5);
}

public void obstecleCheck(){
  float x = this.position.x;
  float y = this.position.y;
  line1 = new Collision(main.p1_init.x,main.p1_init.y, main.p1_end.x,main.p1_end.y,r);
  line2 = new Collision(main.p2_init.x,main.p2_init.y, main.p2_end.x,main.p2_end.y,r);
  line3 = new Collision(main.p3_init.x,main.p3_init.y, main.p3_end.x,main.p3_end.y,r);
  
  // Checa por colisões nas extremidades da janela
  if((x > width - 2 || x < 2 || y > height - 2 || y < 2 ) || (x >= main.Objective_Final.x - 10 && x <= main.Objective_Final.x + 10 && y >= main.Objective_Final.y - 10 && y <= main.Objective_Final.y + 10) || (index == dir.directions.length))
  canNotMove = true;
  
  //Checa por colisões nas linhas de obstáculos
  boolean hit1 = line1.lineCircle(x,y);
  if (hit1) canNotMove = true;
  boolean hit2 = line2.lineCircle(x,y);
  if (hit2) canNotMove = true;
  boolean hit3 = line3.lineCircle(x,y);
  if (hit3) canNotMove = true;
}

public void copy(Fly best){
  for(int i = 0; i < dir.directions.length ; i++){
    dir.directions[i] = best.dir.directions[i];
  }
}

public void mate(Fly father, Fly mother){
    for(int i = 0; i < dir.directions.length ; i++){
    if(random(1) < 0.02f){
      dir.directions[i] = PVector.fromAngle(random(PI*2));
    }  
    else{
      dir.directions[i].x = (father.dir.directions[i].x + mother.dir.directions[i].x) / 2;
      dir.directions[i].y = (father.dir.directions[i].y + mother.dir.directions[i].y) / 2;

    }
  }
}

}
class Point{
float x;
float y;

Point(float x , float y){
    this.x = x;
    this. y = y;
  }
}
  public void settings() {  size(1280,720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
