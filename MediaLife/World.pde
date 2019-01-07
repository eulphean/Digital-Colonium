// Maintain the entire world. 
// Insects, Flowers, and the App watcher. 
// World schedules when the app watcher opens. 

class World { 
  ArrayList<Insect> agents;
  AppWatcher appWatcher;
  ArrayList<Flower> flowers; // Apps
  int generation;

  World(int numAgents, int numFood) {
    // App watcher
    appWatcher = new AppWatcher();
     
    // Agents.
    agents = new ArrayList();
    for (int i = 0; i < numAgents; i++) {
       PVector l = new PVector(0, 0);
       agents.add(new Insect(l, new DNA(), agentScale));
    }
    
    // Apps
    flowers = new ArrayList(); 
    createFlowers(numFood);
    
    
    // Keep track of iterations.
    generation = 0; 
  }
  
  void run() {
    // App watcher
    appWatcher.run(); 
    
    // Apps
    for (Flower f : flowers) {
      if (!f.isEaten) {  
        f.run();
      }
    }

    // Agents: Handle agents display, eating, reproduction
    for (int i = agents.size()-1; i >= 0; i--) {
      Insect a = agents.get(i);
      
      // Update sound amplitudes (as a cluster) 
      float amp = (2.0 / agents.size());
      
      // Handle all the agent behavior. 
      // Seperation, seeking food, seeking media, avoiding media
      a.run(flowers, agents, amp);
      a.display();
      
      // Health of the agent.
      if (a.dead()) { // Is it dead? 
        agents.remove(i); 
      }
    }
    
    // Release more agents. TODO: Automate this through reproduction. 
    if (releaseAgents) {
      for (int i = 0; i < 20; i++) {
        PVector l = new PVector(0, 0);
        agents.add(new Insect(l, new DNA(), agentScale));
      }
      releaseAgents = false; 
    }
    
    if (appWatcher.createFood) {
     createNewFood();
     appWatcher.createFood = false;
    }
    
    generation++; 
  }
  
  void createFlowers(int num) {
   // Dummy flower to calculate the height and width. 
   Flower f = new Flower(new PVector(0, 0), flowerScale); 
   
   for (int i = 0; i < num; i++) {
     PVector position = getNewFlower(f.flowerWidth, f.flowerHeight);
     flowers.add(new Flower(position, flowerScale));
   }
  }
  
  void createNewFood() {
   // Calculate food already eaten. 
   int numEaten = 0; 
   for (Flower f : flowers) {
     numEaten = f.isEaten ? numEaten + 1 : numEaten; 
   }
   
   // Reset already eaten food. Don't reset the entire food. 
   int foodsToGenerate = floor(random(1, numEaten)); 
   println("New foods to generate: " + foodsToGenerate);
   for (Flower f : flowers) {
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
    for (int i = 0; i < flowers.size(); i++) {
      // Existing Flower dimensions. 
      Flower f = flowers.get(i); 
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
    
    return false; 
  }
}
