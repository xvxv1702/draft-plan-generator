ArrayList<Agent> agents=new ArrayList<Agent>();
int flag=1;
int times=0;//记录循环次数

void setup(){
  size(800,800);
  background(255);
  
  for (int i=0;i<5;i++){
    agents.add(new Agent(new PVector(random(width/60)+width/2,random(height/60)+height/2),i));
    //agents.add(new Agent(new PVector(random(width/8)+width/4,random(height/8)+height/4),i));
  }
  for (int i=0;i<5;i++){
    agents.add(new Agent(new PVector(random(width/60)+width/2+60,random(height/60)+height/2),i+5));
    //agents.add(new Agent(new PVector(random(width/8)+width/4,random(height/8)+height/4),i));
  }
  for (int i=0;i<5;i++){
    agents.add(new Agent(new PVector(random(width/60)+width/2,random(height/60)+height/2+80),i+10));
    //agents.add(new Agent(new PVector(random(width/8)+width/4,random(height/8)+height/4),i));
  }
  for (int i=0;i<5;i++){
    agents.add(new Agent(new PVector(random(width/60)+width/2+60,random(height/60)+height/2+80),i+15));
    //agents.add(new Agent(new PVector(random(width/8)+width/4,random(height/8)+height/4),i));
  }
}
void draw(){
  times++;
  fill(0);
  for(Agent agent:agents){
    if (!agent.dead){
      if(times>10){
        checkDead(agent);
      }
      agent.run();
      if(times>2){
        agent.display();
      }
      agent.flock();
      
    }
  }
}

void checkDead(Agent agent){
  //如果速度小于一定值，就死亡
  //if(agent.v0.mag()<0.5)agent.dead=true;
  //如果碰到别的墙，就死亡
  for(Agent another:agents){
    if (another.id!=agent.id){
      for(PVector loc:another.locs){
        float dist=agent.loc.dist(loc);
        if(dist<6.0){agent.dead=true;}
      }
    }
  }
  //如果转向超过4次，死亡
  if(agent.turns>6)agent.dead=true;
  
}

void mousePressed() {
    //saveFrame("pic_####.jpg");
    if(flag==1){
      flag=0;
      noLoop();
    }else{
      flag=1;
      loop();
    }
    
}
