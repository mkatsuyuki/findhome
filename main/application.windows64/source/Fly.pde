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
  void update(){
    
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
  void show(){
    fill(255,255,0);
    noStroke();
    ellipse(this.position.x , this.position.y , 5,5);
  }
  
  //Checa se encostou em obstaculo
  void obstacleCheck(){
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
  void copy(Fly best){
    for(int i = 0; i < dir.directions.length ; i++){
      dir.directions[i] = best.dir.directions[i];
    }
  }
  
  //Lógica de reprodução entre duas moscas
  void mate(Fly father, Fly mother){
    
    for(int i = 0; i < dir.directions.length ; i++){
      //Mutação (faz a instancia de direção ser aleatória ao invés de herdada do pai)
      if(random(1) < 0.02){
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
