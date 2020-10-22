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

int main() {
  // Initializing Robot Configuration. DO NOT REMOVE!
  vexcodeInit();
  while(true){
    FrontLeft.setVelocity(20, velocityUnits::pct);
    FrontRight.setVelocity(20, velocityUnits::pct);
    BackLeft.setVelocity(20, velocityUnits::pct);
    BackRight.setVelocity(20, velocityUnits::pct);

    //Takes in first cube
    LeftIntake.rotateFor(200, rotationUnits::deg, false);
    RightIntake.rotateFor(200, rotationUnits::deg, false);

    task::sleep(1000);

    //Goes forward to the stack (we got to get rid of the orange one)
    FrontLeft.rotateFor(540, rotationUnits::deg, false);
    BackLeft.rotateFor(540, rotationUnits::deg, false);
    FrontRight.rotateFor(-540, rotationUnits::deg, false);
    BackRight.rotateFor(-540, rotationUnits::deg, false);

    task::sleep(1000);

    //Lifts up to orange
    LeftLift.rotateFor(-400, rotationUnits::deg, false);
    RightLift.rotateFor(400, rotationUnits::deg, false);

    task::sleep(1000);

    //Goes forward to knock down orange one
    FrontLeft.rotateFor(40, rotationUnits::deg, false);
    BackLeft.rotateFor(40, rotationUnits::deg, false);
    FrontRight.rotateFor(-40, rotationUnits::deg, false);
    BackRight.rotateFor(-40, rotationUnits::deg, false);

    task::sleep(1000);

    //Goes back slightly
    FrontLeft.rotateFor(-40, rotationUnits::deg, false);
    BackLeft.rotateFor(-40, rotationUnits::deg, false);
    FrontRight.rotateFor(40, rotationUnits::deg, false);
    BackRight.rotateFor(40, rotationUnits::deg, false);

    task::sleep(1000);

    //Goes down to first green on top
    LeftLift.rotateFor(100, rotationUnits::deg, false);
    RightLift.rotateFor(-100, rotationUnits::deg, false);

    task::sleep(1000);

    //Go down to second green on the bottom 
    LeftLift.rotateFor(-400, rotationUnits::deg, false);
    RightLift.rotateFor(400, rotationUnits::deg, false);

    task::sleep(1000);

    /*
      Assuming that was done correctly, now we have to put the green ones in the towers
      So lets go back to the position of the orange cube
    */

    //Go back to the orange position
    FrontLeft.rotateFor(-540, rotationUnits::deg, false);
    BackLeft.rotateFor(-540, rotationUnits::deg, false);
    FrontRight.rotateFor(540, rotationUnits::deg, false);
    BackRight.rotateFor(540, rotationUnits::deg, false);

    task::sleep(1000);

    //Turn the bot towards the first tower so lets turn to the right side
    FrontLeft.rotateFor(420, rotationUnits::deg, false);
    BackLeft.rotateFor(420, rotationUnits::deg, false);
    FrontRight.rotateFor(420, rotationUnits::deg, false);
    BackRight.rotateFor(420, rotationUnits::deg, false);

    task::sleep(1000);

    //Move towards the first tower
    FrontLeft.rotateFor(540, rotationUnits::deg, false);
    BackLeft.rotateFor(540, rotationUnits::deg, false);
    FrontRight.rotateFor(-540, rotationUnits::deg, false);
    BackRight.rotateFor(-540, rotationUnits::deg, false);

    task::sleep(1000);



    




  }
  
}
