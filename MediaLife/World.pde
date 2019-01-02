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
    //apps.run(); 
    
    // Deal with natural food.  
    food.run(agents);

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
      
      
      Insect child = a.reproduce(); 
      if (child != null) {
        agents.add(child);
      }
    }
    
    if (releaseAgents) {
      for (int i = 0; i < 20; i++) {
        PVector l = new PVector(0, 0);
        agents.add(new Insect(l, new DNA(), agentScale));
      }
      releaseAgents = false; 
    }
    generation++; 
  }
}
