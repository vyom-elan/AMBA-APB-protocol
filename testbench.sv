module test;
   logic pclk;
   logic rst_n;
   logic [31:0] paddr;
   logic        psel;
   logic        penable;
   logic        pwrite;
   logic [31:0] prdata;
   logic [31:0] pwdata;
   dut_if apb_if();
   apb_slave dut(.dif(apb_if));
   initial begin
      apb_if.pclk=0;
   end
   always begin
      #10 apb_if.pclk = ~apb_if.pclk;
   end
   initial begin
    apb_if.rst_n=0;
    repeat (1) @(posedge apb_if.pclk);
    apb_if.rst_n=1;
  end
   initial begin
     uvm_config_db#(virtual dut_if)::set( null, "uvm_test_top", "vif", apb_if);
     run_test("apb_base_test");
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
