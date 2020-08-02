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

void update(){
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

void show(){
  fill(255,255,0);
  noStroke();
  ellipse(this.position.x , this.position.y , 5,5);
}

void obstecleCheck(){
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

void copy(Fly best){
  for(int i = 0; i < dir.directions.length ; i++){
    dir.directions[i] = best.dir.directions[i];
  }
}

void mate(Fly father, Fly mother){
    for(int i = 0; i < dir.directions.length ; i++){
    if(random(1) < 0.02){
      dir.directions[i] = PVector.fromAngle(random(PI*2));
    }  
    else{
      dir.directions[i].x = (father.dir.directions[i].x + mother.dir.directions[i].x) / 2;
      dir.directions[i].y = (father.dir.directions[i].y + mother.dir.directions[i].y) / 2;

    }
  }
}

}
