#define GPIO_OUT (*(volatile unsigned int *)0x30000000)
#define PWM_ENABLE (*(volatile unsigned int *)0x30000018)
#define PWM_PERIOD (*(volatile unsigned int *)0x3000001C)
#define PWM_DUTY (*(volatile unsigned int *)0x30000020)

int main() {
    GPIO_OUT = 0x55;

    PWM_PERIOD = 10;
    PWM_DUTY = 4;
    PWM_ENABLE = 1;

    while (1) {
    }

    return 0;
}
