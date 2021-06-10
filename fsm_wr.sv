


module fsm_wr(
    output logic [15:0] wr_data,
    output logic control_o,
    output logic [2:0] addr,
    output logic control_rd,
    input  logic  [15:0] median_i,
    input  logic control_i,
    //input  logic clk_i,
    //input  logic rstn_i
	clk_rstn_if interf 
    );
 
timeunit   1ns  ; timeprecision 100ps ;
typedef enum logic[1:0] {IDLE,MID,  WRITE  } state_t;
state_t  fsm_state;
logic [2:0]  count;

always_ff @(posedge interf.clk_i, negedge interf.rstn_i) begin 
if (!interf.rstn_i) begin    
            fsm_state<=IDLE;
            wr_data<=0;
            control_o<=0;
            addr<=0;
            control_rd<=0;
            count<=0;
end 
else begin 
            case (fsm_state)
               IDLE: begin 
                  //control_o<=0;
                  //control_rd<=0;
                  if (control_i) begin 
                        fsm_state<=MID;
                       // fsm_state<=WRITE;
                        wr_data<=median_i;
                        
                  end else begin 
                         fsm_state<=IDLE;
                         control_o<=0;
                         control_rd<=0;
                  end  
       
               end 
                MID: begin
                    control_o <= 1;
                     addr<=count;
                     fsm_state<=WRITE;
                end
                
               WRITE : begin 
                    // control_o<=1;
                     //addr<=count;
                   //  count<=count+1;
                     if (count==7) begin 
                           count<=0;
                           control_rd<= 1;  
                     end
                    // else begin
                    count<=count+1;
                    control_o <=0;
                     fsm_state<=IDLE;
                    // end
               end
            endcase 
end   

end    
    
    
property dataCheck0;
@(posedge interf.clk_i) disable iff (!interf.rstn_i)
  (control_i) |=> ($past(fsm_state) == IDLE);
endproperty
dataCheck_Assert0: assert property (dataCheck0); 
    
    
    
endmodule
