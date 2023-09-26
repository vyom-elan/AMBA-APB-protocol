module APB_master(input Transfer,              
                  input Wr_Rd,                 
                  input [4:0] Address,         
                  input [31:0] write_data,     
                  output reg [31:0] read_data,
                  input PCLK,                 
                  input PRESETn,              
                  input PREADY,                
                  input [31:0] PRDATA,         
                  input PSLVERR,               
                  output reg [4:0] PADDR,      
                  output reg PSELx,            
                  output reg PENABLE,          
                  output reg PWRITE,           
                  output reg [31:0] PWDATA);       
    parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;
    reg [1:0] ps,ns;
    always @(posedge PCLK) begin
        if (!PRESETn)
            ps <= IDLE;
        else
            ps <= ns;
    end 
    always @(ps,Transfer,PREADY) begin
        if (!PRESETn  || !Transfer)
            ns <= IDLE;
        else
        begin
            PWRITE = Wr_Rd;    
            case (ps)            
                IDLE:begin
                    PSELx   = 0;
                    PENABLE = 0;
                    ns <= SETUP;
                end               
                SETUP:begin
                    PSELx   = 1;
                    PENABLE = 0;
                    PADDR   = Address;            
                    if (PWRITE)
                        PWDATA   <= write_data;
                    
                    if (!PSLVERR)
                        ns <= ACCESS;
                    else
                        ns <= IDLE;
                end
                ACCESS:begin
                    PSELx   = 1;
                    PENABLE = 1;
                    if (!PSLVERR)
                    begin
                        if (!PREADY) begin
                            if (PWRITE) begin
                                ns <= ACCESS;
                            end
                            else if (!PWRITE) begin
                                read_data = PRDATA;
                                ns <= ACCESS;
                            end
                        end
                        else if (PREADY)
                            ns <= SETUP;
                    end
                    else
                        ns <= IDLE;
                end                      
                default: ns <= IDLE;
            endcase
        end                   
    end            
endmodule
