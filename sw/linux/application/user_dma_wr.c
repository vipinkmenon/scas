#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include "papi.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>

#define DATA_POINTS (4*1024*1024)  //Size of current DMA write

long_long PAPI_get_real_usec(void);


#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 

unsigned int senddata[DATA_POINTS/4];  //Buffer to hold the send data

int main(int argc, char* argv[]) 
{
	int rtn,i;
    unsigned int arg = 0;
	//unsigned int test_size = 256;
    unsigned int test_size = atoi(argv[1]);
    long_long s;
    long_long e;
        
	

        //Incremental Data for testing
	for(i = 0; i < DATA_POINTS/4; i++){
            senddata[i] = arg;
	    arg++;
	}

    printf("# Testing dma write to FPGA DRAM for different data size\n");
    printf("# Transfer Size(Bytes), Transfer Time (s),Throughput: (MB/s)\n"); 

	//while(test_size <= DATA_POINTS) {
		s = PAPI_get_real_usec(); 
        rtn = fpga_transfer_data(HOST, USERPCIE1,(unsigned char *) senddata, test_size ,0, 0);
		rtn = fpga_transfer_data(HOST, USERPCIE2,(unsigned char *) senddata, test_size ,0, 0);
		rtn = fpga_transfer_data(HOST, USERPCIE3,(unsigned char *) senddata, test_size ,0, 0);
		rtn = fpga_transfer_data(HOST, USERPCIE4,(unsigned char *) senddata, test_size ,0, 0);

		fpga_wait_interrupt(hostuser1);  
		fpga_wait_interrupt(hostuser2); 
		fpga_wait_interrupt(hostuser3); 
		fpga_wait_interrupt(hostuser4); 
	    e = PAPI_get_real_usec();         
	    //printf("%d,%f\n", 4*test_size,(double)(4*test_size*1000000.0)/(1024.0*1024.0*(double)(e-s))); 
		printf("%d, %f, %f\n", test_size,(e-s)*1e-6,(double)(test_size*1000000.0)/(1024.0*1024.0*(double)(e-s)));
		//test_size *= 2;
	//}
	return 0;
}                 
