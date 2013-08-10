#include <stdio.h>
#include <stdlib.h>
#include "fpga.h"
#include <assert.h>
#include <sys/time.h>
#include <unistd.h>
#include "papi.h"

long_long PAPI_get_real_usec(void);

#define GETTIME(t) gettimeofday(&t, NULL)
#define GETUSEC(e,s) e.tv_usec - s.tv_usec 
#define MemSize (2*1024*1024)


int main(int argc, char* argv[]) 
{

	int rtn,i;
        int arg = 0;
	int error_flag = 0;
        long_long s;
        long_long e;


        printf("Writing incremental data to DDR Memory Space\n");

	s = PAPI_get_real_usec(); 
        //Write 400000 byte incremental pattern to the DDR
        for(i=0;i<4000;i=i+4){                       
            rtn = fpga_ddr_pio_wr(i,arg);
	    arg++;
        }
        e = PAPI_get_real_usec();
        printf("Average DDR PIO write latency : %f us \n",(double)(e-s)/(i/4));

        printf("Reading and comparing from DDR Memory Space\n");

	s = PAPI_get_real_usec();
        for(i=0;i<4000;i=i+4){                       
            rtn = fpga_ddr_pio_rd(i);
        }
        e = PAPI_get_real_usec();
        printf("Average DDR PIO read latency : %f us \n",(double)(e-s)/(i/4));


	arg =0;

        for(i=0;i<4000;i=i+4){                       
            rtn = fpga_ddr_pio_rd(i);
	    if(rtn != arg){
		printf("Error at memory location %d , Expected %d Received %d\n",i,arg,rtn);
		error_flag = 1;
	    }
	    arg++;
        }

	if(!error_flag)
		printf("Congratulations....Data comparison passed!!\n");

	printf("Exiting.\n");
        printf("_____________________________________________________________________________\n");
	return 0;
}                 
