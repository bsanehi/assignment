ArrayList<Car> car = new ArrayList<Car>(11);
ArrayList<PShape> car_icons_svg = new ArrayList<PShape>(6);
ArrayList<ArrayList<PImage>> car_images = new ArrayList<ArrayList<PImage>>(11);
PImage[] image_viewer = new PImage[2];

int num_of_cars;
float ref_point_x; // used for sliding the screen across
float current_screen_width;
float tiles_aspect_ratio;
float icon_aspect_ratio;
boolean next_page;
boolean page_1, page_2;
int change_pic;
int selected_car; // which car is currently selected


// refactoring code
float hor_bar_width = width*.10;
float hor_bar_height = height *.018;


void setup(){
  
  size(683,384,P3D);
  background(246,246,246);
  
  PFont font;
  font = loadFont("font/Calibri-120.vlw");
  textFont(font, 32);
  
  read_in_car_data();
  load_images();
  
  image_viewer[0] = car_images.get(selected_car).get(0) ;
  image_viewer[1] = car_images.get(selected_car).get(1) ;
  
  // get aspect ratio of car images
  PImage img = new PImage();
  img = car_images.get(0).get(0);
  float currW = img.width;
  float currH = img.height;
  tiles_aspect_ratio = currH / currW; // get tiles aspect ratio
  
  current_screen_width = width;
  
  next_page = false;
  
  frameRate(60);
  
  // 8x anti-aliasing for svg's
  smooth(8);
  
  // start up page
  page_1 = true;

}// end setup



void draw(){
  
  background(246,246,246);
  
  if(ref_point_x <= current_screen_width && next_page == true){
    
    current_screen_width = width;
    ref_point_x += width*.05;
    
    if(ref_point_x > width){
      // turn off the first page
      page_1 = false;
      ref_point_x = width;
    }// end if
    
  }else if((ref_point_x > 0 && next_page == false)){
    
    current_screen_width = width;
    ref_point_x -= width*.05;
    
    if(ref_point_x < 0){
      // turn off the second page
      page_2 = false;
      ref_point_x = 0;
    }// end inner if
    
  }// end else if
  
  
  // render menu front page 
  if(page_1 == true){
    pushMatrix();
      translate(0 - ref_point_x,0);
      load_image_tiles();
    popMatrix();
  }// end if
  
  
  // render stats page
  if(page_2 == true){
    pushMatrix();
      translate(width - ref_point_x,0);
      background_map_image();
      draw_small_icons();
      draw_grid();
      
      hor_bar_width = width*.10;
      hor_bar_height = height *.018;
      
      draw_bar_graphs();
      draw_info_text();
      draw_map_graphs();
    popMatrix();
  }// end if
  
}// end draw


void background_map_image(){
  fill(231,231,231);
  noStroke();
  rect(0, height *.60, width , height); // 5% gap
  rect(0,0, width, height *.55); // bg for car image and trend graphs
  image(image_viewer[change_pic],  width *.0125, height *.05,width *.47125,height *.45);
}// end background_map_image



// the 4 trend graphs
void plot_points_on_map(){
  
  float screen_map_x = width *.5125;
  float screen_map_y = height *.05;
  float screen_height = screen_map_y + height *.45;
  float screen_width = screen_map_x + width *.475;
  
  fill(255);
  stroke(255);
  
  for(int i=0; i<num_of_cars; i++){
    
    // check if car is selected
    if(i == selected_car){
       fill(255,0,0);
    }else {
       fill(255);
    }
    
    float brake_x1 = map(i+1, 0, 12, screen_map_x , screen_map_x + (width *.475/2));
    float brake_y1 = map(car.get(i).brake_force, 0, 1.2,  (screen_height - (height *.45/2)), (screen_map_y *2.5)) ;
    
    float brake_x2 = 0;
    float brake_y2 = 0;
    
    float speed_x1 = map(i+1, 0, 12, screen_width - (width *.475/2) , screen_width );
    float speed_y1 = map(car.get(i).max_speed + car.get(i).engine_power - car.get(i).drag, 100, 160,  (screen_height - (height *.45/2)), (screen_map_y *2.5)) ;
    
    float speed_x2 = 0;
    float speed_y2 = 0;
    
    float acceleration_x1 = map(i+1, 0, 12, screen_map_x , screen_map_x + (width *.475/2));
    float acceleration_y1 = map(car.get(i).upshift_rate, 0, 8, screen_height  ,  ( screen_height - (height *.45/2) ) *1.2 ) ;
    
    float acceleration_x2 = 0;
    float acceleration_y2 = 0;
    
    float traction_x1 = map(i+1, 0, 12, screen_width - (width *.475/2) , screen_width);
    float traction_y1 = map(car.get(i).cornering_grip + car.get(i).striaght_line_grip, 0, 7.35, screen_height  ,  ( screen_height - (height *.45/2)) * 1.2 ) ;
    
    float traction_x2 = 0;
    float traction_y2 = 0;
    
    
    if(i < num_of_cars-1){
      
       brake_x2 = map(i+2, 0, 12, screen_map_x , screen_map_x + (width *.475/2));
       brake_y2 = map(car.get(i + 1).brake_force, 0, 1.2,  (screen_height - (height *.45/2)), (screen_map_y *2.5)) ;
       ellipse(brake_x2, brake_y2,screen_map_y*.30,screen_map_y*.30);
       line(brake_x1,brake_y1, brake_x2, brake_y2);
       
       speed_x2 = map(i+2, 0, 12, screen_width - (width *.475/2) , screen_width);
       speed_y2 = map(car.get(i+1).max_speed + car.get(i+1).engine_power - car.get(i+1).drag, 100, 160,  (screen_height - (height *.45/2)), (screen_map_y *2.5)) ;
       ellipse(speed_x2, speed_y2,screen_map_y*.30,screen_map_y*.30);
       line(speed_x1,speed_y1, speed_x2, speed_y2);
           
       acceleration_x2 = map(i+2, 0, 12, screen_map_x , screen_map_x + (width *.475/2));
       acceleration_y2 =  map(car.get(i+1).upshift_rate, 0, 8, screen_height ,   (screen_height - (height *.45/2)) *1.2 ) ;
       ellipse( acceleration_x2,  acceleration_y2, screen_map_y*.30,screen_map_y*.30);
       line( acceleration_x1, acceleration_y1,  acceleration_x2,  acceleration_y2);
       
       traction_x2 = map(i+2, 0, 12, screen_width - (width *.475/2) , screen_width);
       traction_y2 =  map(car.get(i+1).cornering_grip + car.get(i+1).striaght_line_grip , 0, 7.35, screen_height ,   (screen_height - (height *.45/2)) *1.2 ) ;
       ellipse( traction_x2, traction_y2, screen_map_y*.30, screen_map_y*.30);
       line( traction_x1, traction_y1,  traction_x2, traction_y2);
       
    }// end if
    
    ellipse(brake_x1,brake_y1,screen_map_y*.30,screen_map_y*.30);
    ellipse(speed_x1,speed_y1,screen_map_y*.30,screen_map_y*.30);
    ellipse(acceleration_x1,acceleration_y1,screen_map_y*.30,screen_map_y*.30);
    ellipse(traction_x1, traction_y1, screen_map_y*.30,screen_map_y*.30);
    
  }// end for

}// end plot_points_on_map();



void draw_map_graphs(){
  
  fill(100,100,150);
  rect((width *.5125), height *.05, width *.475, height *.45); // trend graphs
  
  float screen_map_x = width *.5125;
  float screen_map_y = height *.05;
  
  float screen_height = screen_map_y + height *.45;
  float screen_width = screen_map_x + width *.475;

  stroke(246,246,246); 
  
  line(screen_width - (width *.475/2),  screen_map_y , screen_width- (width *.475/2),  screen_height ); // cross y
  line(screen_map_x  , screen_height - (height *.45/2), screen_width  ,  screen_height - (height *.45/2)); // cross x

  plot_points_on_map();
 
  fill(255); // black color fill for text
  textAlign(CENTER);
  textSize((int) width*.015); 
  text( "Brakes" , screen_width - (width *.475/1.30), screen_map_y + height *.04);
  text( "Speed" , screen_width - (width *.475/3.6) , screen_map_y + height *.04);
  text( "Acceleration" , screen_width - (width *.475/1.32), screen_map_y + screen_height - (height *.45/1.9));
  text( "Traction" , screen_width - (width *.475/3.6) ,  screen_map_y + screen_height - (height *.45/1.9));
  
}// end draw_map_graphs



void draw_small_icons(){
 
  PVector icon_size = new PVector();
  
  icon_aspect_ratio = get_aspect_ratio_for_icons(0);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(0) , width*.43 , height *.743,  icon_size.x, icon_size.y); // acceleration
  
  icon_aspect_ratio = get_aspect_ratio_for_icons(1);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(1) , width*.025 ,  height *.87,   icon_size.x, icon_size.y); // brakes
 
  icon_aspect_ratio = get_aspect_ratio_for_icons(2);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(2) , width*.02,  height *.68,    icon_size.x, icon_size.y); // car
  
  icon_aspect_ratio = get_aspect_ratio_for_icons(3);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(3) , width*.21 , height *.75,   icon_size.x, icon_size.y); // speed
  
  icon_aspect_ratio = get_aspect_ratio_for_icons(4);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(4) , width*.81 , height *.75,   icon_size.x, icon_size.y); // traction
  
  icon_aspect_ratio = get_aspect_ratio_for_icons(5);
  icon_size = get_icon_sizes();
  shape( car_icons_svg.get(5) , width*.485 ,  height *.55,   width*.027, height*.050); // go back icon
  
}// end draw_small_icons



void draw_grid(){
  stroke(125);
  strokeWeight(1);
  line( width*.025, height *.80,  width*.20, height*.80); // sep car from brakes
  line( width*.20, height *.625, width*.20, height*.975);
  line( width*.40, height *.625, width*.40, height*.975);
  line( width*.80, height *.625, width*.80, height*.975);
}// end draw_grid



void draw_grey_bar_bg(){
  noStroke();
  fill(217,216,216); // fill grey
  rect( width*.092 ,  height *.66 , width*.092, height *.028); // name
  rect( width*.092 ,  height *.745 , width*.092, height *.028); // price
  rect( width*.084 , height *.84 , hor_bar_width, hor_bar_height); // brake force
  rect( width*.084 , height *.90 , hor_bar_width, hor_bar_height); // Front brakes
  rect( width*.084 , height *.96 , hor_bar_width, hor_bar_height); // back brakes
  rect( width*.27 , height *.74 , hor_bar_width, hor_bar_height); // engine power
  rect( width*.27 , height *.82 , hor_bar_width, hor_bar_height); // drag 
  rect( width*.27 , height *.90 , hor_bar_width, hor_bar_height); // max speed 
  rect( width*.50 , height *.74 , hor_bar_width, hor_bar_height); // weight
  rect( width*.50 , height *.82 , hor_bar_width, hor_bar_height); // PTF 
  rect( width*.50 , height *.90 , hor_bar_width, hor_bar_height); // PTB
  rect( width*.64 , height *.74 , hor_bar_width, hor_bar_height); // gears
  rect( width*.64 , height *.82 , hor_bar_width, hor_bar_height); // upshift rate 
  rect( width*.64 , height *.90 , hor_bar_width, hor_bar_height); // downshift rate
  rect( width*.87 , height *.74 , hor_bar_width, hor_bar_height); // cornering grip
  rect( width*.87 , height *.82 , hor_bar_width, hor_bar_height); // straight line grip
}// end draw_bar_bg()



void draw_bar_graphs(){
  
  draw_grey_bar_bg();
  
  fill(22,90,243); // blue
  rect( width*.084 , height *.84 , map(car.get(selected_car).brake_force , 0, 1.2, 0,  hor_bar_width), hor_bar_height); // brake force
  rect( width*.084 , height *.90 , map(car.get(selected_car).brake_bias , 0, 1 , 0,  hor_bar_width), hor_bar_height); // front brakes
  rect( width*.084 , height *.96 , hor_bar_width - map(car.get(selected_car).brake_bias , 0, 1 , 0,  hor_bar_width), hor_bar_height); // back brakes
  rect( width*.27 , height *.74 , map(car.get(selected_car).engine_power , 0, 0.365 , 0,  hor_bar_width) , hor_bar_height); // engine power
  rect( width*.27 , height *.90 , map(car.get(selected_car).max_speed , 0, 160 , 0,  hor_bar_width) , hor_bar_height); // max speed
  rect( width*.50 , height *.82 , map(car.get(selected_car).power_to_front , 0, 100 , 0,  hor_bar_width) , hor_bar_height); // power to front 
  rect( width*.50 , height *.90 , hor_bar_width - map(car.get(selected_car).power_to_front , 0, 100 , 0,  hor_bar_width) , hor_bar_height); // power to back 
  rect( width*.64 , height *.74 , map(car.get(selected_car).gears , 0, 6 , 0,  hor_bar_width) , hor_bar_height); // gears
  rect( width*.64 , height *.82 , map(car.get(selected_car).upshift_rate , 0, 7 , 0,  hor_bar_width) , hor_bar_height); // upshift rate
  rect( width*.64 , height *.90 , map(car.get(selected_car).downshift_rate , 0, 6 , 0,  hor_bar_width) , hor_bar_height); // downshift rate
  rect( width*.87 , height *.74 , map(car.get(selected_car).cornering_grip , 0, 2.75 , 0,  hor_bar_width) , hor_bar_height); // cornering grip
  rect( width*.87 , height *.82 , map(car.get(selected_car).striaght_line_grip , 0, 2.6 , 0,  hor_bar_width) , hor_bar_height); // straight line grip
  
  fill(255,30,20); // red 
  rect( width*.27 , height *.82 , map(car.get(selected_car).drag , 0, 10.427 , 0,  hor_bar_width) , hor_bar_height); // drag  
  rect( width*.50 , height *.74 , map(car.get(selected_car).weight, 0, 1800 , 0,  hor_bar_width) , hor_bar_height); // weight
  
}// end draw_bar_graphs



void draw_info_text(){
  
  fill(0); // black color fill for text
  textAlign(CENTER);
  textSize((int) width*.015); 
  text( "Car" , (width*.10)/2.3, height *.64);
  text( "Brakes" , (width*.10)/2.3, height *.84);
  text( "Speed" , (width*.30), height *.64);
  text( "Acceleration" , (width*.60), height *.64);
  text( "Traction" , (width*.90), height *.64);
  text( "Name:" , width*.07,  height *.684);
  text( car.get(selected_car).name , width*.14, height *.684); // car name text
  text( "Price:" , width*.07,  height *.769);
  text( "$" + (int) car.get(selected_car).price , width*.14, height *.769); // car price text
  
  textAlign(LEFT);
  textSize((int) width*.013); 
  text( "Brake Force:" , width*.084,  height *.831 ); // brake force text
  text( "Front Brakes:" , width*.084,  height *.891 ); // front brakes text
  text( "Back Brakes:" , width*.084,  height *.95 ); // front brakes text
  text( "Engine Power:" ,  width*.27 ,  height *.73 ); // engine power text
  text( "Drag:" ,  width*.27 ,  height *.81 ); // drag text
  text( "Max Speed: " + (int) (car.get(selected_car).max_speed * 1.60934) + " kph",  width*.27 ,  height *.89 ); // max speed text  also convert from mph to kph
  text( "Weight: " + (int) car.get(selected_car).weight + " kg",  width*.50 ,  height *.73 ); // weight text
  text( "Power to front: " + car.get(selected_car).drivetrain,  width*.50 ,  height *.81 ); // drivetrain PTF text
  text( "Power to back: " + car.get(selected_car).drivetrain,  width*.50 ,  height *.89 ); // drivetrain PTB text
  text( "Gears: " + car.get(selected_car).gears,  width*.64 ,  height *.73 ); // weight text
  text( "Upshift Rate:",  width*.64 ,  height *.81 ); // drivetrain PTF text
  text( "Downshift Rate:",  width*.64 ,  height *.89 ); // drivetrain PTB text
  text( "Cornering Grip:" ,  width*.87 ,  height *.73 ); // cornering grip text
  text( "Straight Line Grip:" ,  width*.87 ,  height *.81 ); // straight line grip text
}// end draw_info_text



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
        // println("cars/" + car.get(i).name + "_" + j + ".png");
       
      }// end inner for
    
    }// end for   

   // there is a total of 6 icons
   car_icons_svg.add(loadShape("car_data_icons/" + "acceleration.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "brakes.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "car.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "speed.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "traction.svg"));
   car_icons_svg.add(loadShape("car_data_icons/" + "arrow.svg"));
   
   println("Loading svg and images done");
  
}// end load_images



void load_image_tiles(){
  
  PVector image_pos = new PVector();
  PVector image_sizes = new PVector();
  
  image_sizes = get_aspect_ratio_for_tiles();
  
  float borderX =  width *.05;
  float borderY =  height *.125; 
  
  image_pos.x = borderX;
  image_pos.y = borderY;
  
  float x_gap = (width*.10) / 3;
  float y_gap = height *.05;

  for(int i = 0; i<num_of_cars; i++){ 
    
    check_mouse_hover_or_pressed(image_pos,  image_sizes.x,  image_sizes.y, i); // check if user clicks or hovers on picture and also display image
    
    image_pos.x += x_gap + image_sizes.x;
    
    if(i==3){
      image_pos.y += y_gap + image_sizes.y;
      image_pos.x = borderX;
    }// end if
    
    if(i==7){
      image_pos.y += y_gap + image_sizes.y;
      image_pos.x = borderX;
    }// end if
    
  }// end for
  
}// end load_image_tiles



void mousePressed(){
  
  // mouse on back button
  if( (sq(mouseX - (width*.485 +  height*.025)) + sq(mouseY - (height *.55 + height*.025) ) ) <  sq(height*.025) ){
    page_1 = true;
    current_screen_width = width;
    if(next_page == true){
      next_page = false;
    }
  }// end if
  
  if( (mouseX <= width *.486) && (mouseX >=  width *.0125) && (mouseY <= height *.50) && (mouseY > height *.05)){
    
    if(change_pic == 1){
      change_pic = 0;
    }else{
      change_pic = 1;
    }
    
  }// end if
  
}// end mousePressed



void check_mouse_hover_or_pressed(PVector image_pos, float currW, float currH, int i){
  
  if(mouseX >= image_pos.x && mouseX <= (image_pos.x + currW) && 
     mouseY >= image_pos.y && mouseY <= (image_pos.y + currH) && mousePressed && next_page == false){
       
      selected_car = i; // changes the selected car
      page_2 = true;
      image_viewer[0] =  car_images.get(i).get(0) ; // change image 1
      image_viewer[1] =  car_images.get(i).get(1) ; // change image 2
      change_pic = 1;
      next_page = true;
      
  }// end if
  
  
  PVector changed_pos = new PVector(5,5);
 
  if(mouseX >= image_pos.x && mouseX <= (image_pos.x + currW) && 
     mouseY >= image_pos.y && mouseY <= (image_pos.y + currH) ){ // check if user hovers over picture
      
        currW -= 10;  
        currH -= 10;    // make changes
        
        image_pos.add(changed_pos);
        
        image( car_images.get(i).get(0) ,  image_pos.x , image_pos.y , currW, currH);  // display
        
        currW += 10;
        currH += 10;    // change back
    
        image_pos.sub(changed_pos);
   }
   else{
        image( car_images.get(i).get(0) ,  image_pos.x, image_pos.y , currW, currH); // display
   }// end else
  
}// end mouse_pressed_on_tile




PVector get_aspect_ratio_for_tiles(){
  
  PVector image_tile_size = new PVector();
  
  image_tile_size.x = (width * .20); // set current width to 20 % of width of screen
  image_tile_size.y = (float) (image_tile_size.x * tiles_aspect_ratio); // get new height
  
  // check if currH * 4 is greater than height
  if((image_tile_size.y * 4) > height){
     image_tile_size.y = (height * .20); // set current height to 20% of height of screen
     image_tile_size.x = image_tile_size.y / tiles_aspect_ratio; // get new width
  }// end if
  
  return image_tile_size;
  
}// end get_aspect_ratio




float get_aspect_ratio_for_icons(int i){
  
  PShape img = new PShape();
  img =   car_icons_svg.get(i);
  float Icon_currW = img.width;
  float Icon_currH = img.height;
  
  float icon_aspect_ratio = Icon_currH / Icon_currW; // get aspect ratio 
  
  return icon_aspect_ratio;
  
}// end get_aspect_ratio_for_icons



PVector get_icon_sizes(){
  
  PVector icon_size = new PVector();
  
  icon_size.x = (width * .04); // set current width to 04 % of width of screen
  icon_size.y = (float) (icon_size.x * icon_aspect_ratio); // get new height
   
  return icon_size;
  
}// 