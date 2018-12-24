class World {
    ArrayList<Agent> agents = new ArrayList<Agent>();
    Food food;; 
    int generation; 

    World(int numAgents, int numFood) {
        // Initialize all the sources of energy
        food = new Food(numFood);
         
        // Initialize agents
        for (int i = 0; i < numAgents; i++) {
           PVector l = new PVector(0, 0);
           agents.add(new Agent(l, new DNA()));
        }
        
        // Keep track of iterations.
        generation = 0; 
    }
    
    void run() {
      // Deal with natural food.  
      food.run();

      // Handle agents display, eating, reproduction
      for (int i = agents.size()-1; i >= 0; i--) {
        Agent a = agents.get(i);
        
        // Handle all the agent behavior. 
        // Seperation, seeking food, seeking media, avoiding media
        a.run(food, agents);
        
        // Health of the agent.
        if (a.dead()) { // Is it dead? 
          agents.remove(i); 
        }
        
        // Reproduce the agent. 
        //Agent child = a.reproduce(); 
        //if (child != null) {
        //  agents.add(child);
        //}
      }
      
      generation++; 
    }
}
