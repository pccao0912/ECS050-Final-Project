#include <stdint.h>

void OutputString(const char *str);
void MoveCursor(uint32_t x, uint32_t y);
uint32_t ReadController(void);
void InitializeTimer(void);
uint32_t GetTimerTicks(void);
void UINT32ToHEX(char *str, uint32_t val);
void ClearBlock(uint32_t x, uint32_t y);

#define LEFT        0x1
#define UP          0x2
#define DOWN        0x4
#define RIGHT       0x8
#define BUTTON1     0x10
#define BUTTON2     0x20
#define BUTTON3     0x40
#define BUTTON4     0x80

int main(){
    char Buffer[16];
    uint32_t X = 0, Y = 0;
    uint32_t ControllerStat, LastControllerStat = 0;
    uint32_t LastTimerTick = 0, CurrentTimerTick;
    uint32_t StartStopTicks = 0, Started = 0;
    uint32_t HoldTicks = 0, StopTicks = 0;
    InitializeTimer();
    while(1){
        ControllerStat = ReadController();
        if(ControllerStat & LEFT && X){
            ClearBlock(X,Y);
            X--;
        }
        else if(ControllerStat & UP && Y){
            ClearBlock(X,Y);
            Y--;
        }
        else if(ControllerStat & DOWN && Y < 32){
            ClearBlock(X,Y);
            Y++;
        }
        else if(ControllerStat & RIGHT && X < 56){
            ClearBlock(X,Y);
            X++;
        }
        if(ControllerStat & BUTTON1 && !(LastControllerStat & BUTTON1)){
            // New Toggle
            Started = 1 - Started;
        }
        if(ControllerStat & BUTTON2){
            HoldTicks++;
        }
        if(!(ControllerStat & BUTTON3)){
            StopTicks++;
        }
        if(ControllerStat & BUTTON4){
            StartStopTicks = 0;
            Started = 0;
            HoldTicks = 0;
            StopTicks = 0;
        }
        if(Started){
            StartStopTicks++;
        }
        LastControllerStat = ControllerStat;
        MoveCursor(X,Y);
        UINT32ToHEX(Buffer,LastTimerTick);
        OutputString(Buffer);
        MoveCursor(X,Y+1);
        UINT32ToHEX(Buffer,StartStopTicks);
        OutputString(Buffer);
        MoveCursor(X,Y+2);
        UINT32ToHEX(Buffer,HoldTicks);
        OutputString(Buffer);
        MoveCursor(X,Y+3);
        UINT32ToHEX(Buffer,StopTicks);
        OutputString(Buffer);
        do{
            CurrentTimerTick = GetTimerTicks();
        }while(CurrentTimerTick == LastTimerTick);
        LastTimerTick = CurrentTimerTick;
    }
    return 0;
}

void ClearBlock(uint32_t x, uint32_t y){
    MoveCursor(x,y);
    OutputString("        ");
    MoveCursor(x,y+1);
    OutputString("        ");
    MoveCursor(x,y+2);
    OutputString("        ");
    MoveCursor(x,y+3);
    OutputString("        ");
}

void UINT32ToHEX(char *str, uint32_t val){
    for(int i = 0; i < 8; i++){
        str[i] = (val>>((7-i)<<2)) & 0xF;
        if(str[i] < 10){
            str[i] += '0';
        }
        else{
            str[i] += 'A' - 10;
        }
    }
}