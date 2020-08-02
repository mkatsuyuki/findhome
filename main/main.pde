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

float x1
float x2
float x2 = 200;    // coordinates of line
float y2 = 400;

float x3 = 500;
float y3 = 600;

void setup(){
  size(1280,720);
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

void draw(){
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
void mouseClicked(){
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final);                            
   population = new FlyPopulation(population_size);                                         //Reseta e cria uma nova população
   generation = 0;
}


// LINE/CIRCLE
boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

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
boolean pointCircle(float px, float py, float cx, float cy, float r) {

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
boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

  // get distance from the point to the two ends of the line
  float d1 = dist(px,py, x1,y1);
  float d2 = dist(px,py, x2,y2);

  // get the length of the line
  float lineLen = dist(x1,y1, x2,y2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}
