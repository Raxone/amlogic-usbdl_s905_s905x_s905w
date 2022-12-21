/*
 * memdump_over_usb.c - S905x memory dump tool over USB
 */
#define P_WATCHDOG_RESET (volatile unsigned int *)0xC11098DC
#define _clear_icache() ((void (*)(void))0xd904045c)()
#define _dwc_pcd_irq() ((void (*)(void))0xd90454a8)()
#define _start_bulk_transfer(pcd) ((void (*)(volatile pcd_struct_t *))0xd9043f54)(pcd)
#define BOOTROM_ADDR 0xD9040000

typedef struct pcd_struct_s
{
    unsigned int d32[2];
    int ep0state;
    char *buf;
    int length;
    char *bulk_buf;
    int bulk_len;
    int bulk_num;
    int bulk_data_len;
    int xfer_len;
    char bulk_out;
    char bulk_lock;
    unsigned request_config : 1;
    unsigned request_enable : 1;
} pcd_struct_t;

static inline void usb_setup_bulk_in(unsigned char *buf, unsigned int len)
{
    volatile pcd_struct_t *pcd = (pcd_struct_t *)0xD90108F0;
    pcd->bulk_out = 0; // BULK IN
    pcd->bulk_buf = buf;
    pcd->bulk_data_len = len;
    pcd->bulk_len = 0x200;

    _start_bulk_transfer(pcd);
}

static inline void watchdog_reset(void)
{
    *P_WATCHDOG_RESET = 0;
}

void _start()
{
    _clear_icache(); //always first instruction
    _dwc_pcd_irq();  //clear USB state
    _dwc_pcd_irq();  //after exploitation

    usb_setup_bulk_in((unsigned char *)BOOTROM_ADDR, 0x10000);
    do
    {
        watchdog_reset();
        _dwc_pcd_irq();
    } while (1);
}
