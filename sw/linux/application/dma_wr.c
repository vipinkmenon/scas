#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include "papi.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>

#define DATA_POINTS (1024*1024*1024)  //Size of current DMA write

long_long PAPI_get_real_usec(void);


#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 

unsigned int senddata[DATA_POINTS/4];  //Buffer to hold the send data

int main(int argc, char* argv[]) 
{
	int rtn,i;
    unsigned int arg = 0;
    unsigned int test_size = atoi(argv[1]);
	//unsigned int test_size = 1024;
    long_long s;
    long_long e;
        
	
    printf("# DMA write to FPGA DRAM from Host\n");
    printf("# Transfer Size(Bytes), Transfer Time (s),Throughput: (MB/s)\n"); 

    //Incremental Data for testing
	for(i = 0; i < DATA_POINTS/4; i++){
        senddata[i] = arg;
	    arg++;
	}

	//while(test_size <= DATA_POINTS) {
	s = PAPI_get_real_usec(); 
       	rtn = fpga_transfer_data(HOST,DRAM, (unsigned char *) senddata, test_size, 0, 0);
        e = PAPI_get_real_usec();         
	printf("%d, %f, %f\n", test_size,(e-s)*1e-6,(double)(test_size*1000000.0)/(1024.0*1024.0*(double)(e-s)));
	//test_size *= 2;
	//}
	return 0;
}                 
