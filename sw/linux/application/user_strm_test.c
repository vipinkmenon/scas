#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include "papi.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>

#define DATA_POINTS (4*1024*1024)  //Total number of bytes

struct timeval start, end;


unsigned int senddata[DATA_POINTS/4];  //Buffer to hold the send data

int main(int argc, char* argv[]) 
{
	int rtn,i;
    	unsigned int test_size = atoi(argv[1]);
    	long_long s;
    	long_long e;
        
        //Incremental Data for testing
	for(i = 0; i < DATA_POINTS/4; i++){
            senddata[i] = i;
	}

    	printf("# Host to PCIE\n");
    	printf("# Transfer Size(Bytes), Transfer Time (s),Throughput: (MB/s)\n"); 
	
	s = PAPI_get_real_usec(); 
        rtn = fpga_transfer_data(HOST,USERPCIE1,(unsigned char *) senddata,test_size,0, 1);
        //fpga_wait_interrupt();
	e = PAPI_get_real_usec();         
	printf("%d, %f, %f\n", test_size,(e-s)*1e-6,(double)(test_size*1000000.0)/(1024.0*1024.0*(double)(e-s)));

        /*for(i=0;i<1024;i=i+4){
              rtn = fpga_ddr_pio_rd(i);
              printf("%d\n",rtn);
        }*/   


	return 0;
}                 
