// Factory of icons. 
class Icon {
 PShape ic; 
 Icon(PShape i) {
   ic = i; 
 }
}

class IconFactory {
 ArrayList<Icon> icons; 
 File [] files; 
  
 IconFactory() {
  icons = new ArrayList(); 
  
  // Read all the files. 
  String path = dataPath("SVG"); 
  files = listFiles(path);
  
  // Load icons into the array.  
  for (File f : files) {
    // Only load SVG files. 
    String fileName = f.getAbsolutePath(); 
    PShape shape = loadShape(fileName); 
    Icon i = new Icon(shape);
    icons.add(i); 
  }
 }
 
 ArrayList<Icon> getAllIcons() {
  ArrayList<Icon> newIconList = new ArrayList(); 
  // Clone the list. 
  for (Icon i : icons) {
    PShape icon = i.ic; 
    Icon newIcon = new Icon(icon); 
    newIconList.add(newIcon); 
  }
  
  return newIconList; 
 }
 
 Icon getRandomIcon() {
   // Return a new icon.  
   int randIdx = floor(random(0, files.length)); 
   Icon oldIcon = icons.get(randIdx); 
   Icon newIcon = new Icon(oldIcon.ic); 
   return newIcon;
 }
}
