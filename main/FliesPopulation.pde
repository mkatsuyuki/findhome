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
	
    Fly bestFly = updateFitness();


	Fly[] newflies = new Fly[s];
	newflies[0] = new Fly(width/2  ,20);
	newflies[1] = new Fly(width/2  ,20);

	newflies[0].copy(bestFly);
	newflies[1].copy(bestFly);

    for(int i = 2; i < s ; i++){

		Fly bestFlyMate = flies[abs(int(random(s)) -1 )];
		//Random pool of individuals, the best ones are mated 
		for(int j = 0; j < 20; j++){
			Fly newFlyMate = flies[abs(int(random(s)) -1 )];
			if(newFlyMate.fitness < bestFlyMate.fitness ){
				bestFlyMate = newFlyMate;
			}
		}

		Fly bestFlyMateMother = flies[abs(int(random(s)) -1 )];

				//Random pool of individuals, the best ones are mated 
		for(int j = 0; j < 20; j++){
			Fly newFlyMate = flies[abs(int(random(s)) -1 )];
			if(newFlyMate.fitness < bestFlyMateMother.fitness ){
				bestFlyMateMother = newFlyMate;
			}
		}

	    newflies[i] = new Fly(width/2  ,20);
      	newflies[i].mate(bestFlyMateMother,bestFlyMate);
    }

	for(int i = 0; i < s; i++){
		flies[i] = new Fly(width/2  ,20);
		flies[i].copy(newflies[i]);
	}
	

    allDead = 0;
}

 
Fly updateFitness(){
   Fly result = flies[0];
   float record = 100000;
   
  for(int i = 0; i < s ; i++){
    
    float dis = dist(flies[i].position.x , flies[i].position.y , main.Objective_Final.x , main.Objective_Final.y);

	flies[i].fitness = dis;

    if(dis < record){
      record = dis;
      result = flies[i];
    }
  
  }
 return result;
 
 }
 



}
