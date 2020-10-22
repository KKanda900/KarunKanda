using namespace vex;

extern brain Brain;

// VEXcode devices
extern controller Controller1;
extern motor FrontRight;
extern motor BackRight;
extern motor BackLeft;
extern motor FrontLeft;
extern motor LeftLift;
extern motor RightLift;
extern motor LeftIntake;
extern motor RightIntake;

/**
 * Used to initialize code/tasks/devices added using tools in VEXcode Text.
 * 
 * This should be called at the start of your int main function.
 */
void  vexcodeInit( void );