using namespace vex;

extern brain Brain;

// VEXcode devices
extern controller Controller1;
extern motor LeftFront;
extern motor LeftBack;
extern motor RightFront;
extern motor RightBack;
extern motor LeftBackLift;
extern motor RightBackLift;
extern motor Front;

/**
 * Used to initialize code/tasks/devices added using tools in VEXcode Text.
 * 
 * This should be called at the start of your int main function.
 */
void  vexcodeInit( void );