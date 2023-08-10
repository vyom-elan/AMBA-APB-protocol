class apb_env  extends uvm_env;
   `uvm_component_utils(apb_env);
   apb_agent  agt;
   apb_scoreboard scb;
   apb_subscriber apb_subscriber_h;
   virtual dut_if  vif;
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     agt = apb_agent::type_id::create("agt", this);
     scb = apb_scoreboard::type_id::create("scb", this);
     apb_subscriber_h=apb_subscriber::type_id::create("apn_subscriber_h",this);
     if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
       `uvm_fatal("build phase", "No virtual interface specified for this env instance")
     end
     uvm_config_db#(virtual dut_if)::set( this, "agt", "vif", vif);
   endfunction
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     agt.mon.ap.connect(scb.mon_export);
     agt.mon.ap.connect(apb_subscriber_h.analysis_export);
   endfunction
endclass
