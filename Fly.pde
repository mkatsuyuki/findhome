class Ball{
PVector pos;

PVector vel;

PVector acc;

boolean canNotMove;

int index ;

Dir dir;

Ball(int x , int y){
pos = new PVector(x,y);
vel = new PVector(0,0);
dir = new Dir(2000);
index = 0;
}

void update(){
  obstecleCheck();
  
  if(canNotMove){
  return;
  }
  
  
acc = dir.dirs[index];

index++;

vel.add(acc);

vel.limit(5);

pos.add(vel);

}

void show(){
  fill(255,0,0);
  noStroke();
  ellipse(this.pos.x , this.pos.y , 5,5);
}

void obstecleCheck(){
  float x = this.pos.x;
  float y = this.pos.y;
  
  if((y >= main.p1.y - 5 && y <= main.p1.y + 5 && x >= main.p1.x - 10 && x <= main.p2.x + 10) || 
  (x > width - 2 || x < 2 || y > height - 2 || y < 2 ) || 
  (x >= main.Objective_Final.x - 10 && x <= main.Objective_Final.x + 10 && y >= main.Objective_Final.y - 10 && y <= main.Objective_Final.y + 10) || (index == dir.dirs.length))
  canNotMove = true;
}

void copy(Ball best){
  
  for(int i = 0; i < dir.dirs.length ; i++){
    if(random(1) < 0.01){
      dir.dirs[i] = PVector.fromAngle(random(PI*2));
    }  
    else{
    dir.dirs[i] = best.dir.dirs[i];
    }
  }
  
  
}

}
