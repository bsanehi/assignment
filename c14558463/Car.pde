class Car {
  
  String name;
  float engine_power;
  float drag;
  float max_speed;
  float weight;
  String drivetrain;
  int power_to_front;
  int gears;
  float upshift_rate;
  float downshift_rate;
  float brake_force;
  float brake_bias;
  float cornering_grip;
  float striaght_line_grip;
  float price;
  
  
  Car(String line){
    
    String[] parts = line.split(",");
    name = parts[0];
    engine_power = Float.parseFloat(parts[1]);
    drag = Float.parseFloat(parts[2]);
    max_speed = Float.parseFloat(parts[3]);
    weight = parseInt(parts[4]);
    drivetrain = parts[5];
    power_to_front = parseInt(parts[6]);
    gears = parseInt(parts[7]);
    upshift_rate = Float.parseFloat(parts[8]);
    downshift_rate = Float.parseFloat(parts[9]);
    brake_force = Float.parseFloat(parts[10]);
    brake_bias = Float.parseFloat(parts[11]);
    cornering_grip = Float.parseFloat(parts[12]);
    striaght_line_grip = Float.parseFloat(parts[13]);
    price = Float.parseFloat(parts[14]);
    
  }
  
}// end Car class