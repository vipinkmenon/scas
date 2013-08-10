#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include "papi.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>

#define DATA_POINTS (1024*1024*1024)  //Size of current DMA write

long_long PAPI_get_real_usec(void);

unsigned int gData[DATA_POINTS/4];  //Buffer to hold the received data

int main(int argc, char* argv[]) 
{

	int rtn,i;
    long usecs;
    unsigned int test_size = atoi(argv[1]);
    long_long s;
    long_long e;
        
    printf("# DMA read from FPGA DRAM to Host\n");
    printf("# Transfer Size(Bytes), Transfer Time (s),Throughput: (MB/s)\n"); 

	s = PAPI_get_real_usec(); 
    	rtn = fpga_transfer_data(DRAM,HOST,(unsigned char *)gData, test_size ,0, 0);
	e = PAPI_get_real_usec();         
	printf("%d, %f, %f\n", test_size,(e-s)*1e-6,(double)(test_size*1000000.0)/(1024.0*1024.0*(double)(e-s)));

	return 0;
}                 
