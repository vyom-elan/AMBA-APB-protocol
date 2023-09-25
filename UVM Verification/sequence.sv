class apb_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_sequence)
  function new (string name = "");
    super.new(name);
  endfunction  
  task body();
    apb_transaction rw_trans;
    repeat (70) begin
      rw_trans=new();
      start_item(rw_trans);
      assert(rw_trans.randomize());
      finish_item(rw_trans);
    end
  endtask
endclass
