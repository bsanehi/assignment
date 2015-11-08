ArrayList<Car> car;
ArrayList<ArrayList<PImage>> car_images;
ArrayList<PShape> car_icons_svg;
int num_of_cars;
float ref_point_x;

void setup(){
  
  size(850,400,P3D);
  background(237,237,237);
  
  num_of_cars = 0;
  
  car = new ArrayList<Car>();
  car_images = new ArrayList<ArrayList<PImage>>();
  car_icons_svg = new ArrayList<PShape>();
  
  read_in_car_data();
  load_images();
  
  ref_point_x = 0;
  
  frameRate(2);
}// end setup




void load_image_tiles(){
  
  /*
  PImage img = car_images.get(0).get(0);
  
  float currW = img.width;
  float currH = img.height;
  
  //float ratio = currH / currW; // get aspect ratio  
  
  currW = (width * .20); // set current width to 20 % of width of screen
  currH = (float) (currW * ratio); // get new height
  
  // check if currH * 4 is greater than height
  if((currH * 4) > height){
     currH = (height * .20); // set current height to 20% of height of screen
     currW = currH / ratio; // get new width
  }// end if */
  
  float currW = width*.20;
  float currH = height*.20;
  

  float borderX =  width *.05;
  float borderY =  height *.15;  // 12 if using scaling
  
  float next_x = borderX;
  float next_y = borderY;
  
  float x_gap = (width*.10) / 3;
  float y_gap = height *.05;
  
  for(int i = 0; i<num_of_cars; i++){ 
    
    image( car_images.get(i).get(0) ,  next_x - ref_point_x , next_y , currW, currH);
    
    next_x += x_gap + currW;
    
    if(i==3){
      next_y += y_gap + currH;
      next_x = borderX;
    }// end if
    
    if(i==7){
      next_y += y_gap + currH;
      next_x = borderX;
    }// end if
    
  }// end for
  
}// end load_image_tiles



void draw(){
  
   background(237,237,237);
   
   if(ref_point_x < 800){
     load_image_tiles();
   }

   //ref_point_x+=5;
   
   if(ref_point_x >= 800){
     //ref_point_x = 0;
   }
  
 // background(255);
 // big_box_w = width * 2;
//  big_box_h = height;
 // big_box_y = height/2;
  
 // draw_big_box();
  
 // if(big_box_x > -(big_box_w/2)){
  //  big_box_x-=4;
   // println(big_box_x);
//  }

}// end draw



/*
void draw_big_box(){
  
  fill(246,246,246);
  noStroke();
  rect(big_box_x,0, big_box_w, big_box_h);
  
}// end draw_big_box

*/




void mousePressed(){
  
 // big_box_x -= 50;
 

}// end mousePressed




void read_in_car_data(){
  
  String[] lines = loadStrings("data/gta_data.csv"); // files must be in the data folder
  
  for(int i = 0; i<lines.length; i++){
    
     car.add(new Car(lines[i]));
     
     num_of_cars++;
     
  }// end for loop
  
}// end read_in_car_data








void load_images(){
  
  // there is a total of 11 cars
  for(int i=0; i<num_of_cars; i++){
    
      // 2 images per car   // image names start with 1
      for(int j=1; j<3; j++){
      
         car_images.add(new ArrayList<PImage>()); 
         car_images.get(i).add(loadImage( "data/cars/" + car.get(i).name + "_" + j + ".png"));
         println("cars/" + car.get(i).name + "_" + j + ".png");
       
      }// end inner for
    
    }// end for

  
   // there is a total of 9 icons
   car_icons_svg.add(loadShape("car_data_icons/" + "acceleration.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "brakes.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "car.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "engine.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "speed.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "steering.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "traction.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "weight.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "arrow.svg"));
  
}// end load_images