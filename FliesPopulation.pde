class BallsPop{

 Ball[] balls ;
 int s;
 int allDead;
 
 
 BallsPop(int s){
   this.s = s;
   balls = new Ball[s];
 
 for(int i = 0; i < s ; i++){
    balls[i] = new Ball(width/2  ,20);
   }
 
 }
 
 void update(){
  for(int i = 0; i < this.s ; i++){
    balls[i].update();
   }
 }
 
 void show(){
  for(int i = 0; i < s ; i++){
    
    balls[i].show();
   }
 
 }
 
 void allDeadCheck(){
   allDead = 0;
   for(int i = 0 ; i < s ; i++){
   
     if(balls[i].canNotMove){
     allDead++;
     }
   }
   
   if(allDead == s){
    main.dead = true;
    println('d');
    newPopulation();
   }
 }
 
 
 void newPopulation(){
   
   main.dead = false;
   
   Ball bestBall = getBestBall();
   
   for(int i = 0; i < s ; i++){
     
     balls[i] = new Ball(width/2  ,20);
     
     balls[i].copy(bestBall);
     
   }
   allDead = 0;
 
 
 }
 
 Ball getBestBall(){
   Ball result = balls[0];
   float record = 100000;
   
  for(int i = 1; i < s ; i++){
    
    float dis = dist(balls[i].pos.x , balls[i].pos.y , main.Objective_Final.x , main.Objective_Final.y);
    if(dis < record){
      record = dis;
      result = balls[i];
    }
  
  }
 return result;
 
 }
 



}
