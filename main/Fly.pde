class Fly{
PVector position;

PVector velocity;

PVector accelerate;

boolean canNotMove;

int index ;

Direction dir;

Fly(int x , int y){
position = new PVector(x,y);
velocity = new PVector(0,0);
dir = new Direction(2000);
index = 0;
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
  
  if((y >= main.p1_init.y - 5 && y <= main.p1_init.y + 5 && x >= main.p1_init.x - 10 && x <= main.p1_end.x + 10) || (y >= main.p2_init.y - 5 && y <= main.p2_init.y + 5 && x >= main.p2_init.x - 10 && x <= main.p2_end.x + 10) || (y >= main.p3_init.y - 5 && y <= main.p3_init.y + 5 && x >= main.p3_init.x - 10 && x <= main.p3_end.x + 10) || 
  (x > width - 2 || x < 2 || y > height - 2 || y < 2 ) || 
  (x >= main.Objective_Final.x - 10 && x <= main.Objective_Final.x + 10 && y >= main.Objective_Final.y - 10 && y <= main.Objective_Final.y + 10) || (index == dir.directions.length))
  canNotMove = true;
}

void copy(Fly best){
  for(int i = 0; i < dir.directions.length ; i++){
    if(random(1) < 0.01){
      dir.directions[i] = PVector.fromAngle(random(PI*2));
    }  
    else{
    dir.directions[i] = best.dir.directions[i];
    }
  }
}

}
