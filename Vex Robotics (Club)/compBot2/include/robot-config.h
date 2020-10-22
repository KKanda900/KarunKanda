using namespace vex;

extern brain Brain;

// VEXcode devices
extern controller Controller1;
extern motor LeftIntake;
extern motor RightIntake;
extern motor Tray;
extern motor FrontLeft;
extern motor FrontRight;
extern motor BackLeft;
extern motor BackRight;
extern bumper BumperA;

/**
 * Used to initialize code/tasks/devices added using tools in VEXcode Text.
 * 
 * This should be called at the start of your int main function.
 */
void  vexcodeInit( void );