/*----------------------------------------------------------------------------*/
/*                                                                            */
/*    Module:       main.cpp                                                  */
/*    Author:       C:\Users\kkand                                            */
/*    Created:      Tue Jan 14 2020                                           */
/*    Description:  V5 project                                                */
/*                                                                            */
/*----------------------------------------------------------------------------*/

// ---- START VEXCODE CONFIGURED DEVICES ----
// Robot Configuration:
// [Name]               [Type]        [Port(s)]
// Controller1          controller                    
// FrontRight           motor         2               
// BackRight            motor         3               
// BackLeft             motor         8               
// FrontLeft            motor         9               
// LeftLift             motor         1               
// RightLift            motor         10              
// LeftIntake           motor         20              
// RightIntake          motor         4               
// ---- END VEXCODE CONFIGURED DEVICES ----

#include "vex.h"

using namespace vex;

void RCDrive(){
  double leftStick = Controller1.Axis3.value();
  double rightStick = Controller1.Axis1.value();
  FrontLeft.spin(vex::directionType::fwd, leftStick + rightStick, vex::velocityUnits::pct);
  BackLeft.spin(vex::directionType::fwd, leftStick + rightStick, vex::velocityUnits::pct);
  FrontRight.spin(vex::directionType::rev, leftStick - rightStick, vex::velocityUnits::pct);
  BackRight.spin(vex::directionType::rev, leftStick - rightStick, vex::velocityUnits::pct);
}

void lift(){
  LeftLift.spin(vex::directionType::fwd, 35, vex::velocityUnits::pct);
  RightLift.spin(vex::directionType::fwd, 35, vex::velocityUnits::pct);
}

void goDown(){
  LeftLift.spin(vex::directionType::rev, 35, vex::velocityUnits::pct);
  RightLift.spin(vex::directionType::rev, 35, vex::velocityUnits::pct);
}

void intake(){
  LeftIntake.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);
  RightIntake.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);
}

void outtake(){
  LeftIntake.spin(vex::directionType::rev, 50, vex::velocityUnits::pct);
  RightIntake.spin(vex::directionType::rev, 50, vex::velocityUnits::pct);
}

int main() {
  // Initializing Robot Configuration. DO NOT REMOVE!
  vexcodeInit();
  while(true){
    FrontLeft.setVelocity(15, velocityUnits::pct);
    BackLeft.setVelocity(15, velocityUnits::pct);
    FrontRight.setVelocity(15, velocityUnits::pct);
    BackRight.setVelocity(15, velocityUnits::pct);
    RCDrive();

    //Lift and Go Down
    if(Controller1.ButtonL1.pressing()){
        lift();
    }
    else if(Controller1.ButtonL2.pressing()){
      goDown();
    } 
    else {
        LeftLift.stop(hold);
        RightLift.stop(hold);
    } 

    //intake and outtake
    if(Controller1.ButtonR1.pressing()){
        intake();
    } else if(Controller1.ButtonR2.pressing()){
        outtake();
    } else {
      LeftIntake.stop(hold);
      RightIntake.stop(hold);
    }





  }
  
}
