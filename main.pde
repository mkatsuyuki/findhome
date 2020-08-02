//Definindo coordenadas
static Point p1 , p2, p3, p4;                  //Obstáculos
static Point Objective_Final;                  //Obstáculos
int x_final = 640, y_final = 620;              //Coordenadas do objetivo

//Declarando a população
BallsPop population;
int endhw;
static boolean dead;

Obstaculo[] obs = new Obstaculo[4];            //Vetor com todos os obstáculos

void setup(){
  size(1280,720);
  background(0);
  population = new BallsPop(100);
  
  p1 = new Point(400, height / 2 );
  p2 = new Point(width - 400, height / 2);
  Objective_Final = new Point(x_final, y_final);
  
  endhw = 20;
}

void draw(){
  background(0);
  strokeWeight(5);
  stroke(255);
  line(p1.x , p1.y , p2.x , p2.y);
  line(p1.x , p1.y , p2.x , p2.y);
  line(p1.x , p1.y , p2.x , p2.y);
  population.update();
  population.show();
  if(!dead)
  population.allDeadCheck();
  
  fill(255,255,0);
  ellipse(Objective_Final.x,Objective_Final.y,endhw,endhw);
}

//Escolhe a posição do final manualmente
void mouseClicked(){
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final);
}
