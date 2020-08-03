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
  void update(){
   for(int i = 0; i < this.s ; i++){
     flies[i].update();
    }
  }
  
  //Mostra todas as moscas da população
  void show(){
   for(int i = 0; i < s ; i++){
    
     flies[i].show();
    }
  }
  
  //Calcula quantidade de moscas mortas
  void allDeadCheck(){
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
  void newPopulation(){
    
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
  		Fly bestFlyMate = flies[abs(int(random(s)) -1 )];
  		for(int j = 0; j < 20; j++){
  			Fly newFlyMate = flies[abs(int(random(s)) -1 )];
  			if(newFlyMate.fitness < bestFlyMate.fitness ){
  				bestFlyMate = newFlyMate;
  			}
  		}
      
      //Gera uma seleção aleatória de moscas, e seleciona a melhor delas para ser a mãe
  		Fly bestFlyMateMother = flies[abs(int(random(s)) -1 )];
  		for(int j = 0; j < 20; j++){
  			Fly newFlyMate = flies[abs(int(random(s)) -1 )];
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
  Fly updateFitness(){
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
