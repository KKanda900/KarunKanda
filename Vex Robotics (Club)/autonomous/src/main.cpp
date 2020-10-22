/*----------------------------------------------------------------------------*/
/*                                                                            */
/*    Module:       main.cpp                                                  */
/*    Author:       C:\Users\kkanda                                           */
/*    Created:      Mon Dec 30 2019                                           */
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

#include "vex.h"

using namespace vex;

/*
void tankDrive(){
  double leftStick = Controller1.Axis3.value();
  double rightStick = Controller1.Axis2.value();
  LeftFront.spin(vex::directionType::fwd, leftStick, vex::velocityUnits::pct);
  LeftBack.spin(vex::directionType::fwd, leftStick, vex::velocityUnits::pct);
  RightFront.spin(vex::directionType::rev, rightStick, vex::velocityUnits::pct);
  RightBack.spin(vex::directionType::rev, rightStick, vex::velocityUnits::pct);
}


void lift(){
  LeftBackLift.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);
  RightBackLift.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);
}

void grab(){
  Front.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);
}

void release(){
  Front.setStopping(coast);
}

void goDown(){
  LeftBackLift.setStopping(coast);
  RightBackLift.setStopping(coast);
}
*/

int main() {
  // Initializing Robot Configuration. DO NOT REMOVE!
  vexcodeInit();
  while(1){
    LeftFront.setVelocity(20, velocityUnits::pct);
    LeftBack.setVelocity(20, velocityUnits::pct);
    RightFront.setVelocity(20, velocityUnits::pct);
    RightBack.setVelocity(20, velocityUnits::pct);

  
  //Releases
  Front.spin(vex::directionType::fwd, 50, vex::velocityUnits::pct);

  task::sleep(1000);

  //Moves forward
  LeftFront.rotateFor(200, rotationUnits::deg, false);
  LeftBack.rotateFor(200, rotationUnits::deg, false);
  RightFront.rotateFor(-200, rotationUnits::deg, false);
  RightBack.rotateFor(-200, rotationUnits::deg, false);

  task::sleep(2000);

  //Grabs
  Front.spin(vex::directionType::rev, 50, vex::velocityUnits::pct);

  task::sleep(1000);

  //Lifts Up
  LeftBackLift.rotateFor(1000, rotationUnits::deg, false);
  RightBackLift.rotateFor(1000, rotationUnits::deg, false);

  task::sleep(5000);

  //Moves forward
  LeftFront.rotateFor(400, rotationUnits::deg, false);
  LeftBack.rotateFor(400, rotationUnits::deg, false);
  RightFront.rotateFor(-400, rotationUnits::deg, false);
  RightBack.rotateFor(-400, rotationUnits::deg, false);

  task::sleep(2000);
  
  //Turns to the right
  LeftFront.rotateFor(425, rotationUnits::deg, false);
  LeftBack.rotateFor(425, rotationUnits::deg, false);
  RightFront.rotateFor(425, rotationUnits::deg, false);
  RightBack.rotateFor(425, rotationUnits::deg, false);

  task::sleep(3000);

  //Moves forward
  LeftFront.rotateFor(540, rotationUnits::deg, false);
  LeftBack.rotateFor(540, rotationUnits::deg, false);
  RightFront.rotateFor(-540, rotationUnits::deg, false);
  RightBack.rotateFor(-540, rotationUnits::deg, false);

  task::sleep(3000);

  // LeftFront.stop(brake);
  // LeftBack.stop(brake);
  // RightFront.stop(brake);
  // RightBack.stop(brake);

  //Releases
  Front.spin(vex::directionType::fwd, 40, vex::velocityUnits::pct);

  task::sleep(1000);

  //Moves backwards
  LeftFront.rotateFor(-540, rotationUnits::deg, false);
  LeftBack.rotateFor(-540, rotationUnits::deg, false);
  RightFront.rotateFor(540, rotationUnits::deg, false);
  RightBack.rotateFor(540, rotationUnits::deg, false);
  
  task::sleep(2000);

  //Turns to the left
  LeftFront.rotateFor(-425, rotationUnits::deg, false);
  LeftBack.rotateFor(-425, rotationUnits::deg, false);
  RightFront.rotateFor(-425, rotationUnits::deg, false);
  RightBack.rotateFor(-425, rotationUnits::deg, false);

  task::sleep(2000);

  //Goes Down
  LeftBackLift.rotateFor(-650, rotationUnits::deg, false);
  RightBackLift.rotateFor(-650, rotationUnits::deg, false);

  task::sleep(3000);

  //Moves forward
  LeftFront.rotateFor(525, rotationUnits::deg, false);
  LeftBack.rotateFor(525, rotationUnits::deg, false);
  RightFront.rotateFor(-525, rotationUnits::deg, false);
  RightBack.rotateFor(-525, rotationUnits::deg, false);

  task::sleep(2000);

  //Grabs
  Front.spin(vex::directionType::rev, 200, vex::velocityUnits::pct);
    
  task::sleep(1000);

  //Lifts Up
  LeftBackLift.rotateFor(200, rotationUnits::deg, false);
  RightBackLift.rotateFor(200, rotationUnits::deg, false);

  task::sleep(2000);

  //Moves backwards
  LeftFront.rotateFor(-250, rotationUnits::deg, false);
  LeftBack.rotateFor(-250, rotationUnits::deg, false);
  RightFront.rotateFor(250, rotationUnits::deg, false);
  RightBack.rotateFor(250, rotationUnits::deg, false);

  task::sleep(2000);

  //Turns to the left
  LeftFront.rotateFor(-425, rotationUnits::deg, false);
  LeftBack.rotateFor(-425, rotationUnits::deg, false);
  RightFront.rotateFor(-425, rotationUnits::deg, false);
  RightBack.rotateFor(-425, rotationUnits::deg, false);

  task::sleep(2000);

  //Moves forward
  LeftFront.rotateFor(350, rotationUnits::deg, false);
  LeftBack.rotateFor(350, rotationUnits::deg, false);
  RightFront.rotateFor(-350, rotationUnits::deg, false);
  RightBack.rotateFor(-350, rotationUnits::deg, false);

  task::sleep(3000);

  //Turns to the right
  LeftFront.rotateFor(425, rotationUnits::deg, false);
  LeftBack.rotateFor(425, rotationUnits::deg, false);
  RightFront.rotateFor(425, rotationUnits::deg, false);
  RightBack.rotateFor(425, rotationUnits::deg, false);

  task::sleep(2000);

  //Lifts Up
  LeftBackLift.rotateFor(300, rotationUnits::deg, false);
  RightBackLift.rotateFor(300, rotationUnits::deg, false);
  
  task::sleep(2000);

  //Moves forward 
  LeftFront.rotateFor(1150, rotationUnits::deg, false);
  LeftBack.rotateFor(1150, rotationUnits::deg, false);
  RightFront.rotateFor(-1150, rotationUnits::deg, false);
  RightBack.rotateFor(-1150, rotationUnits::deg, false);

  task::sleep(5000);

  Front.spin(vex::directionType::fwd, 100, vex::velocityUnits::pct);


  break;
 }
}
