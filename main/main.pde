//Definindo coordenadas
static Point p1_init , p1_end, p2_init, p2_end, p3_init, p3_end;                  //Pontos do obstáculos
static Point Objective_Final;                                                     //Ponto do objetivo final
int x_final = 640, y_final = 620;                                                 //Coordenadas do objetivo
int Objective_Size = 20;                                                          //Tamanho do objetivo final

int population_size = 500;
int generation = 0;

FlyPopulation population;
static boolean dead;

void setup(){
  size(1280,720);
  background(0);
  population = new FlyPopulation(population_size);
  
  p1_init = new Point(400, height / 2 );
  p1_end = new Point(width - 400, height / 2);
  
  p2_init = new Point(200,400);
  p2_end = new Point(500,600);
  
  p3_init = new Point(1080,400);
  p3_end = new Point(780,600);
  
  Objective_Final = new Point(x_final, y_final);
}

void draw(){
  background(0);
  strokeWeight(5);
  stroke(255);
  line(p1_init.x , p1_init.y , p1_end.x , p1_end.y);                                              //Desenha o obstáculo
  line(p2_init.x , p2_init.y , p2_end.x , p2_end.y);                                              //Desenha o obstáculo
  line(p3_init.x , p3_init.y , p3_end.x , p3_end.y);                                              //Desenha o obstáculo

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
