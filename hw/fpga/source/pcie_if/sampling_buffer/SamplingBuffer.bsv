package SamplingBuffer;

import ClientServer::*;
import GetPut::*;
import FIFO::*;
import Connectable::*;

(* synthesize *)
module mkSamplingBufferTb (Empty);

   Reg#(int) cycle    <- mkReg (0);
   Reg#(int) sample <- mkReg (0);
   
   Reg#(int) temp    <- mkReg (0);
   Reg#(int) v_int <- mkReg (0);
   Reg#(int) v_aux <- mkReg (0);
   Reg#(int) v_shnt <- mkReg (0);
   Reg#(int) v_board <- mkReg (0);
   Reg#(int) i_board <- mkReg (0);

   // create an instance of the rollback fifo
   let dut <- mkSamplingBuffer;
   let fakemon <- mkSysMon;
   mkConnection(dut.sysmon, fakemon.sysmon);

   // rule for reading the results 
   rule read_temp (cycle==0);
	   cycle <= 1;
	   let data <- dut.read_qty(0); 
	   temp <= data;
   endrule
   rule read_v_int (cycle==1);
	   cycle <= 2;
	   let data <- dut.read_qty(1); 
	   v_int <= data; 
   endrule
   rule read_v_aux (cycle==2);
	   cycle <= 3;
	   let data <- dut.read_qty(2); 
	   v_aux <= data; 
   endrule
   rule read_v_shnt (cycle==3);
	   cycle <= 4;
	   let data <- dut.read_qty(3); 
	   v_shnt <= data; 
   endrule
   rule read_v_board (cycle==4);
	   cycle <= 5;
	   let data <- dut.read_qty(4); 
	   v_board <= data;
   endrule
   rule read_i_board (cycle==5);
	   cycle <= 6;
	   let data <- dut.read_qty(5); 
	   i_board <= data; 
   endrule

   rule display (cycle==6);
	   cycle <= 0;
	   sample <= sample + 1;
	   $display ("Sample=%d, temp=%d, v_int=%d, v_aux-%d, v_shnt=%d, v_board=%d, i_board=%d", sample, temp, v_int, v_aux, v_shnt, v_board, i_board);
	   if (sample > 128) $finish(0);
   endrule

endmodule

interface Sysmon_ifc;
   interface Server#(int,int) sysmon;
endinterface

(* synthesize *)
module mkSysMon(Sysmon_ifc);
   
   // inteface to sysmon
   FIFO#(int) measurements_fifo <- mkSizedFIFO(32); 

   // no methods required here as rule have no guards.. i.e. they always fire
   interface Server sysmon;
	   interface Put request;
		   method Action put(a);
			   // simple mirror
			   measurements_fifo.enq(a); 
		   endmethod
	   endinterface
	   interface Get response;
		   method ActionValue#(int) get();
			   measurements_fifo.deq;
			   return measurements_fifo.first;
		   endmethod
	   endinterface
   endinterface	

endmodule


interface Design_ifc;
   interface Client#(int,int) sysmon;
   // read from the sample buffer 
   method ActionValue#(int) read_qty(int qty_id); 
endinterface

(* synthesize *)
module mkSamplingBuffer (Design_ifc);
   
   // inteface to sysmon
   FIFO#(int) addr_fifo <- mkSizedFIFO(32); 
   FIFO#(int) data_fifo <- mkSizedFIFO(32); 

   // 6 quantities being measured
   FIFO#(int) temp_fifo <- mkSizedFIFO(32); 
   FIFO#(int) v_int_fifo <- mkSizedFIFO(32); 
   FIFO#(int) v_aux_fifo <- mkSizedFIFO(32); 
   FIFO#(int) v_shnt_fifo <- mkSizedFIFO(32); 
   FIFO#(int) v_board_fifo <- mkSizedFIFO(32); 
   FIFO#(int) i_board_fifo <- mkSizedFIFO(32); 

   // 250 MHz clock
   // 12.8 microsecond targe rolloever
   // 12.8e-6/(1/250e6) ticks = 12.8*250 ticks = 3200 ticks = 12 bits 
   // Extra 1-bit for sign (Bluespec compiler checked this!)
   Reg#(Int#(13)) microsecond_cntr <- mkReg(0);
   
   // simple state-machine to cycle through 6 quantity measurements
   Reg#(int) state <- mkReg(0);

   // define sampling rate
   rule counter;
	   if(microsecond_cntr <= 3200) begin
		   microsecond_cntr <= microsecond_cntr + 1;
	   end else begin 
		   microsecond_cntr <= 0;
	   end
   endrule

   // define addres sequence to read from sys_mon
   rule state_0 (state==0 && microsecond_cntr==0);
	   state <= 1;
	   addr_fifo.enq(0);
   endrule

   // send next address, read temperature
   rule state_1 (state==1);
	   state <= 2;
	   addr_fifo.enq(1);

	   let data = data_fifo.first; data_fifo.deq;
	   temp_fifo.enq(data);
   endrule

   // send next address, read temperature
   rule state_2 (state==2);
	   state <= 3;
	   addr_fifo.enq(2);

	   let data = data_fifo.first; data_fifo.deq;
	   v_int_fifo.enq(data);
   endrule

   // send next address, read temperature
   rule state_3 (state==3);
	   state <= 4;
	   addr_fifo.enq(3);

	   let data = data_fifo.first; data_fifo.deq;
	   v_aux_fifo.enq(data);
   endrule

   // send next address, read temperature
   rule state_4 (state==4);
	   state <= 5;
	   addr_fifo.enq(4);

	   let data = data_fifo.first; data_fifo.deq;
	   v_shnt_fifo.enq(data);
   endrule

   // send next address, read temperature
   rule state_5 (state==5);
	   state <= 6;
	   addr_fifo.enq(5);

	   let data = data_fifo.first; data_fifo.deq;
	   v_board_fifo.enq(data);
   endrule

   // send next address, read temperature
   rule state_6 (state==6);
	   state <= 0;

	   let data = data_fifo.first; data_fifo.deq;
	   i_board_fifo.enq(data);
   endrule

   // read the physical quantities from the FIFOs
   // keep reading from register-mapped port (need to indicate fifo empty somehow)
   method ActionValue#(int) read_qty(int qty_id);
	   if(qty_id==0) begin
		   temp_fifo.deq;
		   return temp_fifo.first;
	   end else if(qty_id==1) begin
		   v_int_fifo.deq;
		   return v_int_fifo.first;
	   end else if(qty_id==2) begin
		   v_aux_fifo.deq;
		   return v_aux_fifo.first;
	   end else if(qty_id==3) begin
		   v_shnt_fifo.deq;
		   return v_shnt_fifo.first;
	   end else if(qty_id==4) begin
		   v_board_fifo.deq;
		   return v_board_fifo.first;
	   end else if(qty_id==5) begin
		   i_board_fifo.deq;
		   return i_board_fifo.first;
	   end else begin
		   return -1;
	   end
   endmethod

   interface Client sysmon;
	   interface Put response;
		   method Action put(a);
			   data_fifo.enq(a);
		   endmethod
	   endinterface
	   interface Get request;
		   method ActionValue#(int) get();
			   addr_fifo.deq;
			   return addr_fifo.first;
		   endmethod
	   endinterface
   endinterface	
   
endmodule: mkSamplingBuffer

endpackage: SamplingBuffer
