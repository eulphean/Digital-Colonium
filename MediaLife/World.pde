// Maintain the entire world. 
// Insects, Flowers, and the App watcher. 
// World schedules when the app watcher opens. 
class World { 
  ArrayList<Figment> agents;
  AppWatcher appWatcher;
  ArrayList<Flower> flowers; // Apps
  int generation;
  int totalSystemFood; 

  World(int numAgents, int numFood) {
    // App watcher
    appWatcher = new AppWatcher();
    totalSystemFood = numFood; 
     
    // Agents.
    agents = new ArrayList();
    for (int i = 0; i < numAgents; i++) {
       PVector l = new PVector(0, 0);
       agents.add(new Figment(l));
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
      Figment a = agents.get(i);
      
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
        agents.add(new Figment(l));
      }
      releaseAgents = false; 
    }
    
    if (appWatcher.createFood) {
     createNewFlowers();
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
  
  void createNewFlowers() {
   // Calculate food already eaten. 
   int numEaten = 0; 
   for (Flower f : flowers) {
     numEaten = f.isEaten ? numEaten + 1 : numEaten; 
   }
   
   // Do I really want to create new apps? 
   int foodsToGenerate = 0; 
   if (numEaten > 0.35 * totalSystemFood) {
     // Minimum food is the minimum for the number of agents. 
     // # agents * 2, numEaten
     foodsToGenerate = floor(random(agents.size() * 2, numEaten)); 
   }
  
   for (Flower f : flowers) {
     if (f.isEaten && foodsToGenerate > 0) {
      // Create a custom flower, which is not ready until it's animated.  
      PVector targetPos = getNewFlower(f.flowerWidth, f.flowerHeight); 
      f.position.x = targetPos.x; f.position.y = targetPos.y; // So, others don't overlap with this. 
      f.aniPosition.x = appWatcher.position.x + appWatcher.wallWidth/2; f.aniPosition.y = appWatcher.position.y + appWatcher.wallHeight/2; // This position is lerped till the animation completes. 
      f.isEaten = false; f.isReady = false; 
      //f.createHead();
      f.assignShader();
      int idx = (int) random(0, easings.length); 
      f.fly(targetPos, easings[idx]);
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
