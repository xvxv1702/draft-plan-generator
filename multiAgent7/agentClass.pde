class Agent{
  PVector loc;
  PVector vel=new PVector(random(-1,1)*5.0,random(-1,1)*3.0);
  PVector acc=new PVector(0,0);
  float r=10;
  float maxspeed=6;
  float maxforce=0.05;
  PVector v0=new PVector(1,1);
  PVector vlast;
  PVector loc0=new PVector(0,0);//临时loc
  PVector loclast=new PVector(0,0);//上一个位置
  ArrayList<PVector> locs=new ArrayList<PVector>();
  boolean dead=false;
  int id;
  int turns=0;//转折次数
  int grid=10;
  int lineWeight=1;
  
  Agent(PVector _loc,int idnumber){
    loc=_loc;
    id=idnumber;
  }
  
  void run(){
    //display();
    move();
    calTurns();//计算调整方向次数
    //checkEdge();
    saveLoc();
  }
  void display(){
    //ellipse(loc0.x,loc0.y,1,1);
    //if(v0.x==0)lineWeight=1;
    //if(v0.y==0)lineWeight=2;
    strokeWeight(lineWeight);
    line(loc0.x,loc0.y,loclast.x,loclast.y);
  }
  void move(){
    vel.add(acc);
    vel.limit(maxspeed);
    vlast=new PVector(v0.x,v0.y);
    if(abs(vel.x)>=abs(vel.y)) v0=new PVector(vel.x,0);
    if(abs(vel.x)<abs(vel.y)) v0=new PVector(0,vel.y);
    loc.add(v0);
    //loc.add(vel);
    loclast.x=loc0.x;
    loclast.y=loc0.y;
    //模数化
    if(v0.x==0){
      if(loc.x%grid<grid/2){
        loc0.x=loc.x-loc.x%grid;
      }else{
        loc0.x=loc.x-loc.x%grid+grid;
      }
      loc0.y=loc.y;
    }
    if(v0.y==0){
      if(loc.y%grid<grid/2){
        loc0.y=loc.y-loc.y%grid;
      }else{
        loc0.y=loc.y-loc.y%grid+grid;
      }
      loc0.x=loc.x;
    }
    acc.set(0,0);
  }
  void saveLoc(){
    locs.add(new PVector(loc.x,loc.y));
  }
  void calTurns(){
    if(v0.dot(vlast)<=0){
      turns++;
      lineWeight=turns%2+1;
      //转角处的点修改位置保证直角
      if(v0.x==0)loc0.y=loclast.y;
      if(v0.y==0)loc0.x=loclast.x;
    }
  }

  void checkEdge(){
    if(loc.x<0)
    {loc.x=0;vel.mult(-1);}
    if(loc.x>width)
    {loc.x=width;vel.mult(-1);}
    if (loc.y<0)
    {loc.y=0;vel.mult(-1);}
    if(loc.y>height) 
    {loc.y=height;vel.mult(-1);}
  }
  
  void flock(){
    separate();
    cohesion();
  }
  void separate(){
    PVector steer=new PVector(0,0);
    int count =0;
    for (Agent another:agents){
      float dis=loc.dist(another.loc);
      if(dis>0&&dis<30){
        PVector diff=PVector.sub(loc,another.loc);
        diff.normalize();
        diff.div(dis);
        steer.add(diff);
        count++;
      }
    }
    if(count>0){
      steer.setMag(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
      steer.mult(1.5);
      acc.add(steer);
    }
  }
  
  void cohesion(){
    PVector steer=new PVector(0,0);
    int count =0;
    for (Agent another:agents){
      float dis=loc.dist(another.loc);
      if(dis>0&&dis>60){
        steer.add(another.loc);
        count++;
      }
    }
    if(count>0){
      steer.div(count);
      steer.sub(loc);
      steer.setMag(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
      //steer.mult(0.2);
      //steer.x=steer.x*2.0;
      acc.add(steer);
    }
    
  }
  
}
