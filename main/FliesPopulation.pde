class FlyPopulation{

 Fly[] flies ;
 int s;
 int allDead;
 
 
 FlyPopulation(int s){
   this.s = s;
   flies = new Fly[s];
 
 for(int i = 0; i < s ; i++){
    flies[i] = new Fly(width/2  ,20);
   }
 
 }
 
 void update(){
  for(int i = 0; i < this.s ; i++){
    flies[i].update();
   }
 }
 
 void show(){
  for(int i = 0; i < s ; i++){
    
    flies[i].show();
   }
 }
 
 void allDeadCheck(){
   allDead = 0;
   for(int i = 0 ; i < s ; i++){
   
     if(flies[i].canNotMove){
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
   generation++;
   main.dead = false;
  
   Fly bestFly = getBestFly();
   
   for(int i = 0; i < s ; i++){
     
     flies[i] = new Fly(width/2  ,20);
     
     flies[i].copy(bestFly);
     
   }
   allDead = 0;
 }
 
 Fly getBestFly(){
   Fly result = flies[0];
   float record = 100000;
   
  for(int i = 1; i < s ; i++){
    
    float dis = dist(flies[i].position.x , flies[i].position.y , main.Objective_Final.x , main.Objective_Final.y);
    if(dis < record){
      record = dis;
      result = flies[i];
    }
  
  }
 return result;
 
 }
 



}
