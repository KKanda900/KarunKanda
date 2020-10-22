/*----------------------------------------------------------------------------*/
/*                                                                            */
/*    Module:       main.cpp                                                  */
/*    Author:       C:\Users\kkand                                            */
/*    Created:      Mon Dec 30 2019                                           */
/*    Description:  V5 project                                                */
/*                                                                            */
/*----------------------------------------------------------------------------*/

// ---- START VEXCODE CONFIGURED DEVICES ----
// Robot Configuration:
// [Name]               [Type]        [Port(s)]
// Controller1          controller                    
// LeftIntake           motor         1               
// RightIntake          motor         2               
// Tray                 motor         3               
// FrontLeft            motor         11              
// FrontRight           motor         15              
// BackLeft             motor         13              
// BackRight            motor         14              
// BumperA              bumper        A               
// ---- END VEXCODE CONFIGURED DEVICES ----

#include "vex.h"
#include <algorithm>
#include <cmath>

using namespace vex;

void mechDrive(){
        double front_left  = (double)(Controller1.Axis3.position(pct) + Controller1.Axis4.position(pct));
        double back_left   = (double)(Controller1.Axis3.position(pct) - Controller1.Axis4.position(pct));
        double front_right = (double)(Controller1.Axis3.position(pct) - Controller1.Axis4.position(pct));
        double back_right  = (double)(Controller1.Axis3.position(pct) + Controller1.Axis4.position(pct));
        
        //Find the largest possible sum of X and Y
        double max_raw_sum = (double)(abs(Controller1.Axis3.position(pct)) + abs(Controller1.Axis4.position(pct)));
        
        //Find the largest joystick value
        double max_XYstick_value = (double)(std::max(abs(Controller1.Axis3.position(pct)),abs(Controller1.Axis4.position(pct))));
        
        //The largest sum will be scaled down to the largest joystick value, and the others will be
        //scaled by the same amount to preserve directionality
        if (max_raw_sum != 0) {
            front_left  = front_left / max_raw_sum * max_XYstick_value;
            back_left   = back_left / max_raw_sum * max_XYstick_value;
            front_right = front_right / max_raw_sum * max_XYstick_value;
            back_right  = back_right / max_raw_sum * max_XYstick_value;
        }
        
        //Now to consider rotation
        //Naively add the rotational axis
        front_left  = front_left  + Controller1.Axis1.position(pct);
        back_left   = back_left   + Controller1.Axis1.position(pct);
        front_right = front_right - Controller1.Axis1.position(pct);
        back_right  = back_right  - Controller1.Axis1.position(pct);
        
        //What is the largest sum, or is 100 larger?
        max_raw_sum = std::max(std::abs(front_left),std::max(std::abs(back_left),std::max(std::abs(front_right),std::max(std::abs(back_right),100.0))));
        
        //Scale everything down by the factor that makes the largest only 100, if it was over
        front_left  = front_left  / max_raw_sum * 100.0;
        back_left   = back_left   / max_raw_sum * 100.0;
        front_right = front_right / max_raw_sum * 100.0;
        back_right  = back_right  / max_raw_sum * 100.0;
        
        //Write the manipulated values out to the motors
        FrontLeft.spin(fwd,front_right, velocityUnits::pct);
        BackLeft.spin(fwd,back_right,  velocityUnits::pct);
        FrontRight.spin(fwd,front_left,velocityUnits::pct);
        BackRight.spin(fwd,back_left, velocityUnits::pct);
}
int main() {
  // Initializing Robot Configuration. DO NOT REMOVE!
  vexcodeInit();
  int IntakeVelocity=200;
  int TrayVelocityIn=80;
  int TrayVelocityOut=300;
  LeftIntake.setVelocity(IntakeVelocity, velocityUnits::pct);
  RightIntake.setVelocity(IntakeVelocity, velocityUnits::pct);
  Tray.setVelocity(TrayVelocityIn, velocityUnits::pct);
  Tray.setStopping(hold);
  while(true){
    mechDrive();
    if(Controller1.ButtonR1.pressing())
        {
          LeftIntake.spin(vex::forward, 200, vex::percent);
          RightIntake.spin(vex::forward, 200, vex::percent);
        }
        else if(Controller1.ButtonR2.pressing())
        {
          LeftIntake.spin(reverse);
          RightIntake.spin(reverse);
        } 
        else
        {
          LeftIntake.spinFor(2,degrees);
          RightIntake.spinFor(2,degrees);
        }
        
        if(Controller1.ButtonL1.pressing())
        {
          if(Controller1.ButtonDown.pressing())
          {
            Tray.setVelocity(40, velocityUnits::pct);
          }
          else
          {
           // Tray.setVelocity(80, velocityUnits::pct);
          }
          Tray.spin(vex::forward, 80, vex::percent);
        }
        else if(Controller1.ButtonL2.pressing()&&!BumperA.pressing())
        {
          Tray.setVelocity(TrayVelocityOut, velocityUnits::pct);
          Tray.spin(reverse);
        }
        
        else 
        {
          Tray.setVelocity(TrayVelocityIn, velocityUnits::pct);
          Tray.stop();
        }
    vex::task::sleep(2);
  }
  
}
