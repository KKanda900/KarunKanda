/*----------------------------------------------------------------------------*/
/*                                                                            */
/*    Module:       main.cpp                                                  */
/*    Author:       C:\Users\kkand                                            */
/*    Created:      Tue Nov 26 2019                                           */
/*    Description:  V5 project                                                */
/*                                                                            */
/*----------------------------------------------------------------------------*/

// ---- START VEXCODE CONFIGURED DEVICES ----
// Robot Configuration:
// [Name]               [Type]        [Port(s)]
// Controller1          controller                    
// LeftFront            motor         1               
// LeftBack             motor         11              
// RightFront           motor         10              
// RightBack            motor         20              
// LeftBackLift         motor         15              
// RightBackLift        motor         17              
// Front                motor         2               
// ---- END VEXCODE CONFIGURED DEVICES ----
// MOTOR.stop(hold)

#include "vex.h"

using namespace vex;

void tankDrive(){
  double leftStick = Controller1.Axis3.value();
  double rightStick = Controller1.Axis1.value();
  LeftFront.spin(vex::directionType::fwd, leftStick + rightStick, vex::velocityUnits::pct);
  LeftBack.spin(vex::directionType::fwd, leftStick + rightStick, vex::velocityUnits::pct);
  RightFront.spin(vex::directionType::rev, leftStick - rightStick, vex::velocityUnits::pct);
  RightBack.spin(vex::directionType::rev, leftStick - rightStick, vex::velocityUnits::pct);
}

void tankDrive2(){
  double leftStick = Controller1.Axis3.value()-20;
  double rightStick = Controller1.Axis2.value()-20;
  LeftFront.spin(vex::directionType::fwd, leftStick, vex::velocityUnits::pct);
  LeftBack.spin(vex::directionType::fwd, leftStick, vex::velocityUnits::pct);
  RightFront.spin(vex::directionType::rev, rightStick, vex::velocityUnits::pct);
  RightBack.spin(vex::directionType::rev, rightStick, vex::velocityUnits::pct);
}

void lift(){
  LeftBackLift.spin(vex::directionType::fwd, 35, vex::velocityUnits::pct);
  RightBackLift.spin(vex::directionType::fwd, 35, vex::velocityUnits::pct);
}

void grab(){
  Front.spin(vex::directionType::fwd, 100, vex::velocityUnits::pct);
}

void release(){
  Front.spin(vex::directionType::rev, 35, vex::velocityUnits::pct);
}

void goDown(){
  LeftBackLift.spin(vex::directionType::rev, 35, vex::velocityUnits::pct);
  RightBackLift.spin(vex::directionType::rev, 35, vex::velocityUnits::pct);
}

int main() {
  // Initializing Robot Configuration. DO NOT REMOVE!
  vexcodeInit();
  while(1){

  LeftFront.setVelocity(15, velocityUnits::pct);
    LeftBack.setVelocity(15, velocityUnits::pct);
    RightFront.setVelocity(15, velocityUnits::pct);
    RightBack.setVelocity(15, velocityUnits::pct);
  tankDrive();

    if(Controller1.ButtonR1.pressing()){
        grab();
    } else if(Controller1.ButtonR2.pressing()){
        release();
    } else {
      Front.stop(hold);
    }

    if(Controller1.ButtonL1.pressing()){
        lift();
    }
    else if(Controller1.ButtonL2.pressing()){
      goDown();
    } 
    else {
        LeftBackLift.stop(hold);
        RightBackLift.stop(hold);
    } 


  
  }
  
}
