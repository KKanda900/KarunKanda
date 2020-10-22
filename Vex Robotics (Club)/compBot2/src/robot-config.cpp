#include "vex.h"

using namespace vex;
using signature = vision::signature;
using code = vision::code;

// A global instance of brain used for printing to the V5 Brain screen
brain  Brain;

// VEXcode device constructors
controller Controller1 = controller(primary);
motor LeftIntake = motor(PORT1, ratio18_1, false);
motor RightIntake = motor(PORT2, ratio18_1, false);
motor Tray = motor(PORT3, ratio18_1, false);
motor FrontLeft = motor(PORT11, ratio18_1, false);
motor FrontRight = motor(PORT15, ratio18_1, true);
motor BackLeft = motor(PORT13, ratio18_1, true);
motor BackRight = motor(PORT14, ratio18_1, false);
bumper BumperA = bumper(Brain.ThreeWirePort.A);

// VEXcode generated functions



/**
 * Used to initialize code/tasks/devices added using tools in VEXcode Text.
 * 
 * This should be called at the start of your int main function.
 */
void vexcodeInit( void ) {
  // nothing to initialize
}