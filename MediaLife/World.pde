class World {
  ArrayList<Insect> agents;
  Apps apps;
  Food food;
  int generation; 

  World(int numAgents, int numFood) {
    // App ecosystem.
    apps = new Apps();
    
    // Initialize all the sources of energy. 
    food = new Food(numFood, apps.wallWidth, apps.wallHeight);
     
    // Agents.
    agents = new ArrayList();
    for (int i = 0; i < numAgents; i++) {
       PVector l = new PVector(0, 0);
       agents.add(new Insect(l, new DNA(), agentScale));
    }
    
    // Keep track of iterations.
    generation = 0; 
  }
  
  void run() {
    // Run the apps.
    if (showEye) {
      apps.run(); 
    }
    
    // Deal with natural food.  
    food.run();

    // Handle agents display, eating, reproduction
    for (int i = agents.size()-1; i >= 0; i--) {
      Insect a = agents.get(i);
      
      // Update sound amplitudes (as a cluster) 
      float amp = (2.0 / agents.size());
      
      // Handle all the agent behavior. 
      // Seperation, seeking food, seeking media, avoiding media
      a.run(food, agents, amp);
      a.display();
      
      // Health of the agent.
      if (a.dead()) { // Is it dead? 
        agents.remove(i); 
      }
      
      
      //Insect child = a.reproduce(); 
      //if (child != null) {
      //  agents.add(child);
      //}
    }
    
    if (releaseAgents) {
      for (int i = 0; i < 20; i++) {
        PVector l = new PVector(0, 0);
        agents.add(new Insect(l, new DNA(), agentScale));
      }
      releaseAgents = false; 
    }
    
    if (createFood) {
     // Find how many are already eaten. 
     // Choose a random number between 0, already eaten
     // Now, go back through the food
     // Assign the one that's eaten a new position, update isEaten flag
     int numEaten = 0; 
     for (Flower f : food.flowers) {
       numEaten = f.isEaten ? numEaten + 1 : numEaten; 
     }
     
     int foodsToGenerate = numEaten; 
     print("Foods to Generate: " + foodsToGenerate); 
     for (Flower f : food.flowers) {
       if (f.isEaten) {
        // I can update this. 
        PVector newPos = getNewFlower(f.flowerWidth, f.flowerHeight); 
        f.position.x = newPos.x; f.position.y = newPos.y;
        f.isEaten = false; 
        f.createHead();
        f.assignShader();
        foodsToGenerate--; 
       }
       
       if (foodsToGenerate == 0) {
        break; // Break out of the for loop.  
       }
     }
     createFood = false; 
    }
    
    generation++; 
  }
  
   
  PVector getNewFlower(int flowerWidth, int flowerHeight) {
    PVector position; boolean a; 
    
    do {
      position = new PVector(int(random(width-flowerWidth/2)), int(random(height-flowerHeight/2))); 
      // Intersecting with another flower or another brick? 
      a = isIntersecting(position, flowerWidth, flowerHeight);
    } while (a); 
    
    return position; 
  }
  
  boolean isIntersecting(PVector position, int w, int h) {
    // Calculate current Flower's dimensions. 
    int newTopRight = int(position.x + w); 
    int newBottom = int(position.y + h);
    
    // Check with all the existing flower.
    for (int i = 0; i < food.flowers.size(); i++) {
      // Existing Flower dimensions. 
      Flower f = food.flowers.get(i); 
      int oldTopRight = int(f.position.x + w); 
      int oldBottom = int(f.position.y + h); 
      
      // Compare the two and check if they intensect. 
      boolean a = (oldTopRight > position.x && 
                f.position.x < newTopRight && 
                  oldBottom > position.y && 
                    f.position.y < newBottom); 
     
      // Break and return immediately. 
      if (a) {
        return a;  
      }
    }
    
    // Intersecting with another brick?
    //for (int j = 0; j < bricks.size(); j++) {
    //  PixelBrick brick = bricks.get(j); 
    //  int brickW = brick.pixWidth * brick.cols; int brickH = brick.pixWidth * brick.rows;  
    //  int oldTopRight = int(brick.position.x + brickW); 
    //  int oldBottom = int(brick.position.y + brickH);
      
    //  boolean a = (oldTopRight > position.x && 
    //    brick.position.x < newTopRight && 
    //      oldBottom > position.y && 
    //        brick.position.y < newBottom); 
    //  if (a) {
    //   return a;  
    //  }
    //}
    
    // Intersecting with the app wall? 
    //PVector center = new PVector(width/2, height/2); 
    //PVector dir = PVector.sub(position, center); 
    
    //float heading = dir.heading(); 
    //// Vector on the edge of the ellipse
    //PVector v = new PVector(width/2 + appsWallWidth/2 * cos(heading), height/2 + appsWallHeight/2 * sin(heading)); 
    //float maxD = PVector.dist(v, center);
    
    
    //float d = PVector.dist(center, position); 
    //if (d < maxD + h/2) {
    // return true; 
    //}
    
    return false; 
  }
}
