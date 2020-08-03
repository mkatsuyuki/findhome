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
public void setup(){
  
  //Inicialização gráfica
  
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
public void draw(){
  
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
public void mouseClicked(){
   //Atualiza posição do objetivo final
   x_final = mouseX;
   y_final = mouseY;
   Objective_Final = new Point(x_final, y_final); 
   
   //Reseta e cria uma nova população
   population = new FlyPopulation(population_size);                                         
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
  
  //Vetor de direções da mosca
  PVector[] directions;
  int index;
  
  //Gera vetor de direçoes aleatório de tamanho s
  Direction(int s){
    directions = new PVector[s];
    for(int i = 0 ; i < s ; i++){
      directions[i] = PVector.fromAngle(random(PI*2));
    }
  }
}
class FlyPopulation{

  //Vetor de moscas
  Fly[] flies ;

  //Quantidade de moscas
  int s;

  //Quantidade de moscas mortas
  int allDead;

  //Construtor da população de moscas
  FlyPopulation(int s){
    this.s = s;
    flies = new Fly[s];
    
    //Gera todas as moscas no mesmo ponto inicial
    for(int i = 0; i < s ; i++){
      flies[i] = new Fly(width/2  ,20);
    }
 
  }
  
  //Atualiza todas as moscas da população
  public void update(){
   for(int i = 0; i < this.s ; i++){
     flies[i].update();
    }
  }
  
  //Mostra todas as moscas da população
  public void show(){
   for(int i = 0; i < s ; i++){
    
     flies[i].show();
    }
  }
  
  //Calcula quantidade de moscas mortas
  public void allDeadCheck(){
    allDead = 0;
    for(int i = 0 ; i < s ; i++){
      
      //Se uma mosca não pode se mover, ela esta morta
      if(flies[i].canNotMove){
        allDead++;
      }
    }
    
    //Se todas as moscas estiverem mortas, a geração se encessa e começa a próxima
    if(allDead == s){
      main.dead = true;
      println('d');
      newPopulation();
    }
  }
 
  //Criação da nova geração
  public void newPopulation(){
    
    generation++;
    main.dead = false;
  	
    //Busca a melhor mosca da geração anterior
    Fly bestFly = updateFitness();
   
    //Gera nova geração de moscas
  	Fly[] newflies = new Fly[s];
  
    //As duas primeiras delas são cópias da melhor
  	newflies[0] = new Fly(width/2  ,20);
  	newflies[1] = new Fly(width/2  ,20);
  	newflies[0].copy(bestFly);
  	newflies[1].copy(bestFly);
  
    //Reprodução 
    for(int i = 2; i < s ; i++){
  
      //Gera uma seleção aleatória de moscas, e seleciona a melhor delas para ser o pai
  		Fly bestFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
  		for(int j = 0; j < 20; j++){
  			Fly newFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
  			if(newFlyMate.fitness < bestFlyMate.fitness ){
  				bestFlyMate = newFlyMate;
  			}
  		}
      
      //Gera uma seleção aleatória de moscas, e seleciona a melhor delas para ser a mãe
  		Fly bestFlyMateMother = flies[abs(PApplet.parseInt(random(s)) -1 )];
  		for(int j = 0; j < 20; j++){
  			Fly newFlyMate = flies[abs(PApplet.parseInt(random(s)) -1 )];
  			if(newFlyMate.fitness < bestFlyMateMother.fitness ){
  				bestFlyMateMother = newFlyMate;
  			}
  		}
  
      //As outras moscas são geradas por reprodução entre o pai e a mãe selecionados da iteração
	    newflies[i] = new Fly(width/2  ,20);
    	newflies[i].mate(bestFlyMateMother,bestFlyMate);
    }
  
    //Atualiza as moscas atuais para serem as novas moscas geradas
  	for(int i = 0; i < s; i++){
  		flies[i] = new Fly(width/2  ,20);
  		flies[i].copy(newflies[i]);
  	}
  	
    //Reseta moscas mortas
    allDead = 0;
  }

  //Gera o fitness para todas as moscas e retorna a melhor (nessa lógica, quanto menor o fitness melhor o desempenho)
  public Fly updateFitness(){
    Fly result = flies[0];
    
    //Valor arbitrario inicial para melhor resultado (maior que o que uma mosca pode atingir para não retornar nulo)
    float record = 100000;
    
    
    for(int i = 0; i < s ; i++){
      
      //calcula a distancia final da mosca até o objetivo
      float dis = dist(flies[i].position.x , flies[i].position.y , main.Objective_Final.x , main.Objective_Final.y);
      
      //fitness da mosca é a distancia para o objetivo (quanto menor, melhor)
    	flies[i].fitness = dis;
      
      //se uma mosca bateu o recorda atual, o record atualiza e o result (melhor mosca) é atualizado para a nova mosca
      if(dis < record){
        record = dis;
        result = flies[i];
      }
    
    }
    
    //retorna a melhor mosca
    return result;
  }
  
}
class Fly{
  //Vetor posição (x,y) da mosca
  PVector position;
  
  //Vetor velocidade (Vx, Vy) da mosca
  PVector velocity;
  
  //Vetor aceleração (ax, ay) da mosca
  PVector accelerate;
  
  //booleano para checar se a mosca pode se mover (não bateu em nenhum obstaculo)
  boolean canNotMove;
  
  //index de interação do vetor direção (um index acessado por frame)
  int index ;
   
  //Função fitness da mosca
  float fitness = 0;
  
  //Vetor de direções da mosca (é a aceleração que a mosca vai ter em cada frame, basicamente (ax[i], ay[i]))
  Direction dir;
  
  Collision line1; //Linha de obstáculo 1
  Collision line2; //Linha de obstáculo 2
  Collision line3; //Linha de obstáculo 3
  
  //Construtor da mosca (iniciado na posição x,y)
  Fly(int x , int y){
    position = new PVector(x,y);
    velocity = new PVector(0,0);
    dir = new Direction(2000);
    
    index = 0;
    canNotMove = false;
  }
  
  //Instancia de atualização dentro do loop principal do código
  public void update(){
    
    //Aciona canNotMove se a mosca encostou em um obstáculo
    obstacleCheck();
    
    //Se a mostra não pode andar (por ex. bateu em obstaculo), fim
    if(canNotMove){
      return;
    }
    
      
     //atualiza o vetor aceleração baseado no vetor de direções
    accelerate = dir.directions[index];
    index++;
    
    //atualiza a velocidade baseado na aceleração
    velocity.add(accelerate);
    
    //Limita a velocidade para não passar de 5
    velocity.limit(5);
    
    //Soma a velocidade na posição atual
    position.add(velocity);
  
  }
  
  //Mostra a mosca na tela em sua respectiva posição
  public void show(){
    fill(255,255,0);
    noStroke();
    ellipse(this.position.x , this.position.y , 5,5);
  }
  
  //Checa se encostou em obstaculo
  public void obstacleCheck(){
    float x = this.position.x;
    float y = this.position.y;
    line1 = new Collision(main.p1_init.x,main.p1_init.y, main.p1_end.x,main.p1_end.y,r);
    line2 = new Collision(main.p2_init.x,main.p2_init.y, main.p2_end.x,main.p2_end.y,r);
    line3 = new Collision(main.p3_init.x,main.p3_init.y, main.p3_end.x,main.p3_end.y,r);
    
    // Checa por colisões nas extremidades da janela
    if((x > width - 2 || x < 2 || y > height - 2 || y < 2 ) || (x >= main.Objective_Final.x - 10 && x <= main.Objective_Final.x + 10 && y >= main.Objective_Final.y - 10 && y <= main.Objective_Final.y + 10) || (index == dir.directions.length))
    canNotMove = true;
    
    //Checa por colisões nas linhas de obstáculos e aciona canNotMove caso haja colisão, fazendo a mosca parar
    boolean hit1 = line1.lineCircle(x,y);
    if (hit1) canNotMove = true;
    boolean hit2 = line2.lineCircle(x,y);
    if (hit2) canNotMove = true;
    boolean hit3 = line3.lineCircle(x,y);
    if (hit3) canNotMove = true;
  }
  
  //copia o vetor direção da melhor mosca para si
  public void copy(Fly best){
    for(int i = 0; i < dir.directions.length ; i++){
      dir.directions[i] = best.dir.directions[i];
    }
  }
  
  //Lógica de reprodução entre duas moscas
  public void mate(Fly father, Fly mother){
    
    for(int i = 0; i < dir.directions.length ; i++){
      //Mutação (faz a instancia de direção ser aleatória ao invés de herdada do pai)
      if(random(1) < 0.02f){
        dir.directions[i] = PVector.fromAngle(random(PI*2));
      } 
      //Se não houver mutação, o vetor direção é a media entre os pais
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
