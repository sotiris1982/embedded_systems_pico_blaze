module top_tb;

timeunit 1ns;
timeprecision 100ps;

logic [7:0] avg_o;
logic [15:0] data_i;
logic data_av_ai;
logic clk_i=0;
logic rstn_i=0;
//////////////////////////

logic [31:0]        sum=0;

logic [15:0] test_median=0;

//////////////////////////
clk_rstn_if interface_top();  
assign interface_top.clk_i=clk_i;    
assign interface_top.rstn_i=rstn_i;   

top top_inst(
.avg_o 			(avg_o),
.data_i			(data_i),
.data_av_ai		(data_av_ai),
.interf			(interface_top)
);

`define PERIOD 10

always
    #(`PERIOD/2) clk_i= ~clk_i;  
    

////////////Task/////////////////

task median_calculation(input [15:0] test_median) ;

        sum = sum + test_median; 
        $display("median sum is = %d", sum);
      
endtask 


task compare_results(input logic [7:0] avg_temp, input logic [31:0] temp_sum); 
  temp_sum = temp_sum/8;
  $display("avg_temp=%d, temp_sum=%d",avg_temp, temp_sum); 
        if (avg_temp == temp_sum) begin
           $display("average is = %d", temp_sum);
         end else begin
            $display("Average is not Right");
         end
endtask 
////////Assertion/////// 

  property req_check;
      @(posedge clk_i)       
       (top.fsm_wr_inst.control_rd) |-> ##4 (top.picoblaze_top_inst.interrupt_ack_o);   
    endproperty
req_check_Assert: assert property (req_check) $display(" INTERRUPT IS HIGH ");
  
 
 


 initial begin 
 @(negedge clk_i)
  rstn_i=0; #30;
    rstn_i=1; data_av_ai=16'd1; data_i=16'd150; #10; 
    rstn_i=1; data_av_ai=16'd0; data_i=16'd150; #30; @(negedge clk_i)median_calculation(top.median_o);  //@(negedge clk_i) median_calculation(top.median_o);
                                           
    rstn_i=1; data_av_ai=16'd1; data_i=16'd100; #10; 
    rstn_i=1; data_av_ai=16'd0; data_i=16'd100; #30;@(negedge clk_i)median_calculation(top.median_o);  //@(negedge clk_i)median_calculation(top.median_o);
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd10; #10;  
    rstn_i=1; data_av_ai=16'd0; data_i=16'd10; #30;@(negedge clk_i)median_calculation(top.median_o); //@(negedge clk_i)median_calculation(top.median_o);
    
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd40; #10; 
    rstn_i=1; data_av_ai=16'd0; data_i=16'd40; #30;@(negedge clk_i)median_calculation(top.median_o); //@(negedge clk_i)median_calculation(top.median_o);
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd250; #10; 
    rstn_i=1; data_av_ai=16'd0; data_i=16'd250; #30;@(negedge clk_i)median_calculation(top.median_o); //@(negedge clk_i)median_calculation(top.median_o);
     
    rstn_i=1; data_av_ai=16'd1; data_i=16'd110; #10; 
    rstn_i=1; data_av_ai=16'd0; data_i=16'd110; #30;@(negedge clk_i)median_calculation(top.median_o); //@(negedge clk_i)median_calculation(top.median_o);
                                              
    rstn_i=1; data_av_ai=16'd1; data_i=16'd35; #10;  
    rstn_i=1; data_av_ai=16'd0; data_i=16'd35; #30; @(negedge clk_i)median_calculation(top.median_o); //@(negedge clk_i)    median_calculation(top.median_o);                  
                                         
    rstn_i=1; data_av_ai=16'd1; data_i=16'd200; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd200; #30;@(negedge clk_i) median_calculation(top.median_o); 
    
    //compare_results(avg_o, sum); 
                                          
    rstn_i=1; data_av_ai=16'd0; data_i=16'd0; #2000;  @(negedge clk_i) // compare_results(avg_o, sum);
    
    
    compare_results(avg_o, sum);
 
 

//$display ( "TEST PASSED" );
  
$finish;
 end    
	
 
endmodule  
    
   

