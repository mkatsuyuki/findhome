//Definindo coordenadas
//Ponto do objetivo final
static Point Objective_Final;

//Coordenadas do objetivo
int x_final = 640, y_final = 620;  

//Tamanho do objetivo final
int Objective_Size = 20;                                                          

//Tamanho população
int population_size = 500;

//Variável de controle das gerações
int generation = 0;                                                               

//Cria variável da população de moscas
FlyPopulation population;
static boolean dead;

//Pontos dos obstáculos
static Point p1_init , p1_end, p2_init, p2_end, p3_init, p3_end;                  
float r =  3;

//Inicialização
void setup(){
  
  //Inicialização gráfica
  size(1280,720);
  background(0);
  frameRate(301989888);
  
  //Inicialização da população de moscas
  population = new FlyPopulation(population_size);
  
  //Inicialização dos pontos dos obstáculos
  p1_init = new Point(400, height / 2 );
  p1_end = new Point(width - 400, height / 2);
  
  p2_init = new Point(200,400);
  p2_end = new Point(500,600);
  
  p3_init = new Point(1080,400);
  p3_end = new Point(780,600);
  
  //Geração do objetivo final
  Objective_Final = new Point(x_final, y_final);
  
  strokeWeight(5);
}

//Loop principal de funcionamento e gráfico
void draw(){
  
  //Mostrar background e configurar desenhos
  background(0);
  strokeWeight(5);
  stroke(255);
  
  //Mostra obstáculos
  line(p1_init.x , p1_init.y , p1_end.x , p1_end.y);                            
  line(p2_init.x , p2_init.y , p2_end.x , p2_end.y);                            
  line(p3_init.x , p3_init.y , p3_end.x , p3_end.y);                            
  
  //Mostra geração
  fill(255,255,0);
  textSize(32);
  text("Generation: " + generation, 10, 40);
  
  //Atualiza e mostra população
  population.update();
  population.show();
  
  //Checa se estão todos mortos
  if(!dead)
    population.allDeadCheck();
  
  //Mostra Objetivo final
  fill(255,0,0);
  ellipse(Objective_Final.x,Objective_Final.y,Objective_Size,Objective_Size);  
}


//Escolhe a posição do final manualmente
void mouseClicked(){
   //Atualiza posição do objetivo final
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final); 
   
   //Reseta e cria uma nova população
   population = new FlyPopulation(population_size);                                         
   generation = 0;
}
