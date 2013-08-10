#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>
#include "papi.h"

#define DATA_SIZE 1024*1024*1024  //Total number of bytes

struct timeval start, end;

#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 


int main(int argc, char* argv[]) 
{
    int rtn,i;
    long usecs;
    unsigned int test_size = atoi(argv[1]);
    //unsigned int test_size = 256;
    long_long s;
    long_long e;
        

	printf("# Testing data transfer between FPGA DRAM to user logic for different data size\n");
    	printf("# Transfer Size(Bytes), Transfer Time (s),Throughput: (MB/s)\n"); 

	//while(test_size <= DATA_SIZE) {
		s = PAPI_get_real_usec();
   		ddr_user_send_data(USERDRAM1,test_size,0x0,0);
		ddr_user_send_data(USERDRAM2,test_size,0x0,0);
		ddr_user_send_data(USERDRAM3,test_size,0x0,0);
		ddr_user_send_data(USERDRAM4,test_size,0x0,0);
		fpga_wait_interrupt(ddruser1);   
		fpga_wait_interrupt(ddruser2); 
		fpga_wait_interrupt(ddruser3); 
		fpga_wait_interrupt(ddruser4);  
		e = PAPI_get_real_usec();     
		printf("%d, %f\n", test_size,(e-s)*1e-6);
		printf("%d, %f, %f\n", test_size,(e-s)*1e-6,(double)(test_size*1000000.0)/(1024.0*1024.0*(double)(e-s)));
		//test_size *= 2;
	//}

	return 0;
}                 
