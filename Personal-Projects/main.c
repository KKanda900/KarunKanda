#include <gb/gb.h>
#include <stdio.h>
#include "sprite.c"
#include "background_map.c"
#include "background_tiles.c"
#include "winmap.c"
#include <gb/font.h>
#include "GameCharacter.c"
#include "Guub.c"
#include "Bug.c"

/*
INT8 player_location[2]; //Stores position of your character
BYTE jumping;
UINT8 gravity = -2;
UINT8 currentspeedY;
UINT8 floorY = 100;
*/

struct GameHero Guub;
struct GameEnemy Bug;
UBYTE spritesize = 7;

void movegamecharacter(struct GameHero* character, UINT8 x, UINT8 y){
    move_sprite((*character).spriteids[0], x + spritesize, y + spritesize);
    move_sprite((*character).spriteids[1], x, y + spritesize);
    move_sprite((*character).spriteids[2], x + spritesize, y);
    move_sprite((*character).spriteids[3], x + spritesize, y + spritesize);
    move_sprite((*character).spriteids[4], x + spritesize, y + spritesize);
    move_sprite((*character).spriteids[5], x , y);
    move_sprite((*character).spriteids[6], x + spritesize, y + spritesize);
}

void setupGuub(){
    Guub.x = 80;
    Guub.y = 130;
    Guub.width = 32;
    Guub.height = 32;

    set_sprite_tile(0,0);
    Guub.spriteids[0] = 0;
    set_sprite_tile(1,1);
    Guub.spriteids[1] = 1;
    set_sprite_tile(2,2);
    Guub.spriteids[2] = 2;
    set_sprite_tile(3,3);
    Guub.spriteids[3] = 3;
    set_sprite_tile(4,4);
    Guub.spriteids[4] = 4;
    /* set_sprite_tile(5,5);
    Guub.spriteids[5] = 5; */ 
    set_sprite_tile(6,6);
    Guub.spriteids[6] = 6;

    movegamecharacter(&Guub, Guub.x, Guub.y);
}

void setupBug() {
    Bug.x = 90;
    Bug.y = 130;
    Bug.width = 16;
    Bug.height = 16;

    set_sprite_tile(0,0);
    Guub.spriteids[0] = 0;
    set_sprite_tile(1,1);
    Guub.spriteids[1] = 1;
    set_sprite_tile(2,2);
    Guub.spriteids[2] = 2;
    set_sprite_tile(3,3);
    Guub.spriteids[3] = 3;

    movegamecharacter(&Bug, Bug.x, Bug.y);
}


void performanceDelay(UINT8 numLoops){
    UINT8 i;
    for(i = 0; i < numLoops; i++){
        wait_vbl_done();
    }
}

/*
INT8 surface(UINT8 projectedY){
    if(projectedY >= floorY){
        return floorY;
    }
    return -1;
}

void jump(UINT8 sprite_id, UINT8 spritelocation[2]){
    INT8 possibleYsurface;
    if(jumping == 0){
        jumping = 1;
        currentspeedY = 10;
    }
    currentspeedY += gravity;
    spritelocation[1] = spritelocation[1] - currentspeedY;
    possibleYsurface = surface(spritelocation[1]);

    if(possibleYsurface != -1){
        jumping = 0;
        move_sprite(sprite_id, spritelocation[0], possibleYsurface);
    } else {
        move_sprite(sprite_id, spritelocation[0], spritelocation[1]);
    }
    performanceDelay(5);
}
*/

void main(){

    set_sprite_data(0, 8, BugChar);
    setupBug();

    set_sprite_data(0,8,GameSprite);
    setupGuub();

    SHOW_SPRITES;
    DISPLAY_ON;

    while(1){
            
    }

    
    
    
    /*

    set_sprite_data(0,8,Person);
    set_sprite_tile(0,0);

    player_location[0] = 10; // X position
    player_location[1] = floorY; // Y position

    move_sprite(0,player_location[0],player_location[1]);

    DISPLAY_ON;
    SHOW_SPRITES;

    while(1){
        if((joypad() & J_UP) || jumping == 1){
            jump(0,player_location);
        }
        if(joypad() & J_LEFT){
            player_location[0] = player_location[0] - 2;
            move_sprite(0, player_location[0], player_location[1]);
            performanceDelay(5);
        } 
        if(joypad() & J_RIGHT){
            player_location[0] = player_location[0] + 2;
            move_sprite(0, player_location[0], player_location[1]);
            performanceDelay(5);
        }
    }


    // These registers must be in this certain order
    NR52_REG = 0x80; // Register to turn sound on
    NR50_REG = 0x77; // Register to set volume for left and right channel
    NR51_REG = 0xFF; // Register to select which channel we want to use (in this case all of them)

    while(1){
        UBYTE joypad_state = joypad();

        if(joypad_state){
            // chanel 1 register 0, Frequency sweep settings
            // 7	Unused
            // 6-4	Sweep time(update rate) (if 0, sweeping is off)
            // 3	Sweep Direction (1: decrease, 0: increase)
            // 2-0	Sweep RtShift amount (if 0, sweeping is off)
            // 0001 0110 is 0x16, sweet time 1, sweep direction increase, shift ammount per step 110 (6 decimal)
            NR10_REG = 0x16; 

            // chanel 1 register 1: Wave pattern duty and sound length
            // Channels 1 2 and 4
            // 7-6	Wave pattern duty cycle 0-3 (12.5%, 25%, 50%, 75%), duty cycle is how long a quadrangular  wave is "on" vs "of" so 50% (2) is both equal.
            // 5-0 sound length (higher the number shorter the sound)
            // 01000000 is 0x40, duty cycle 1 (25%), wave length 0 (long)
            NR11_REG = 0x40;

            // chanel 1 register 2: Volume Envelope (Makes the volume get louder or quieter each "tick")
            // On Channels 1 2 and 4
            // 7-4	(Initial) Channel Volume
            // 3	Volume sweep direction (0: down; 1: up)
            // 2-0	Length of each step in sweep (if 0, sweeping is off)
            // NOTE: each step is n/64 seconds long, where n is 1-7	
            // 0111 0011 is 0x73, volume 7, sweep down, step length 3
            NR12_REG = 0x73; 

            // chanel 1 register 3: Frequency LSbs (Least Significant bits) and noise options
            // for Channels 1 2 and 3
            // 7-0	8 Least Significant bits of frequency (3 Most Significant Bits are set in register 4)
            NR13_REG = 0x00; 

            // chanel 1 register 4: Playback and frequency MSbs
            // Channels 1 2 3 and 4
            // 7	Initialize (trigger channel start, AKA channel INIT) (Write only)
            // 6	Consecutive select/length counter enable (Read/Write). When "0", regardless of the length of data on the NR11 register, sound can be produced consecutively.  When "1", sound is generated during the time period set by the length data contained in register NR11.  After the sound is ouput, the Sound 1 ON flag, at bit 0 of register NR52 is reset.
            // 5-3	Unused
            // 2-0	3 Most Significant bits of frequency
            // 1100 0011 is 0xC3, initialize, no consecutive, frequency = MSB + LSB = 011 0000 0000 = 0x300
            NR14_REG = 0xC3;

            //These registers make a jumping sound 

            delay(1000);
        }
    }
    
   
    font_t min_font;

    font_init();
    min_font = font_load(font_min);
    font_set(min_font);

    //background 
    set_bkg_data(37,7,bgt);
    set_bkg_tiles(0,0,40,18, bg);

    set_win_tiles(0,0,5,1,winmap);
    move_win(7,120);

    SHOW_BKG;
    SHOW_WIN;
    DISPLAY_ON;


    while(1){
        scroll_bkg(1,0);
        delay(100);
    }


    UINT8 sprite_index = 0;

    set_sprite_data(0,2,Person);
    set_sprite_tile(0,0);
    move_sprite(0,88,78);
    SHOW_SPRITES;

    while(1){

        // Code to switch sprites
       
        if(sprite_index == 0){
            sprite_index = 0;
        } else {
            sprite_index = 0;
        }
  
        //set_sprite_tile(0, sprite_index);

        // Code to move sprite using movement keys
      
        switch(joypad()){
            case J_LEFT:
                scroll_sprite(0,-10,0);
                break;
            case J_RIGHT:
                scroll_sprite(0,10,0);
            case J_UP:
                scroll_sprite(0,0,-10);
                break;
            case J_DOWN:
                scroll_sprite(0,0,10);
                break;
        }
        delay(100); // Delay is for so it doesnt go zooooooooming 
   
    }
    */
} 