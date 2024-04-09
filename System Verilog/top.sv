`include "Master.sv"
`include "Slave.sv"
`timescale 1ns/1ns
module APB(input PCLK,PRESETn,transfer,READ_WRITE,
                    input [8:0] apb_write_paddr,
		            input [7:0]apb_write_data,
		            input [8:0] apb_read_paddr,
		            output PSLVERR, 
                    output [7:0] apb_read_data_out);
    wire [7:0]PWDATA,PRDATA,PRDATA1,PRDATA2;
    wire [8:0]PADDR;
    wire PREADY,PREADY1,PREADY2,PENABLE,PSEL1,PSEL2,PWRITE;
    assign PREADY = PADDR[8] ? PREADY2 : PREADY1 ;
    assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx ;
    master_bridge dut_mas(apb_write_paddr,
		                  apb_read_paddr,
		                  apb_write_data,
		                  PRDATA,         
	                      PRESETn,
		                  PCLK,
		                  READ_WRITE,
		                  transfer,
		                  PREADY,
	                      PSEL1,
		                  PSEL2,
		                  PENABLE,
	                      PADDR,
	                      PWRITE,
	                      PWDATA,
		                  apb_read_data_out,
		                  PSLVERR); 
    Slave dut_sl(  PCLK,PRESETn, PSEL1,PENABLE,PWRITE, PADDR[7:0],PWDATA, PRDATA1, PREADY1 );
endmodule
