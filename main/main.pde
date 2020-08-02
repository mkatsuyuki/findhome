//Definindo coordenadas
static Point p1 , p2, p3, p4;                  //Obstáculos
static Point Objective_Final;                  //Obstáculos
int x_final = 640, y_final = 620;              //Coordenadas do objetivo
int generation = 0;
FlyPopulation population;
int Objective_Size;
static boolean dead;

void setup(){
  size(1280,720);
  background(0);
  population = new FlyPopulation(100);
  
  p1 = new Point(400, height / 2 );
  p2 = new Point(width - 400, height / 2);
  Objective_Final = new Point(x_final, y_final);
  
  Objective_Size = 20;
}

void draw(){
  background(0);
  strokeWeight(5);
  stroke(255);
  line(p1.x , p1.y , p2.x , p2.y);                                              //Desenha o obstáculo
  
  textSize(32);
  text("Generation: " + generation, 10, 40);
  
  population.update();
  population.show();
  if(!dead)
  population.allDeadCheck();
  
  fill(255,255,0);
  ellipse(Objective_Final.x,Objective_Final.y,Objective_Size,Objective_Size);  //Desenha o objetivo final
}

//Escolhe a posição do final manualmente
void mouseClicked(){
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final);
   population = new FlyPopulation(100);
   generation = 0;
}
