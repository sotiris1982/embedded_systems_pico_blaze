module top(
	output logic [7:0] avg_o,
	input logic [15:0] data_i,
	input logic data_av_ai,
	clk_rstn_if interf
	);
	
// eswterika simata
logic data_av_sync; // eswteriko sima toy sync module

// eswterika simata median
logic [15:0] median_o;
logic control_o_m;

// eswterika simata fsm_wr 
logic [15:0] wr_data;
logic control_o_wr;
logic [2:0] addr_wr;
logic control_rd;
logic control_i;
logic median_i;

// eswterika simata fsm_rd
logic [2:0] addr_rd;
//logic [31:0] avg;
logic [15:0] rd_data;
logic control_i_rd;

//
logic [7:0] addr_from_pico_o;
logic interrupt_req_i;
logic interrupt_ack_o;


//instantiations

sync sync_inst(
.data_av_ai    (data_av_ai),
.data_av_sync  (data_av_sync),
.interf        (interf)
);

median median_inst(
.median_o       (median_o),
.control_o      (control_o_m),
.data_av_sync   (data_av_sync),
.data_i         (data_i),
.interf         (interf)
);



fsm_wr fsm_wr_inst(
.wr_data        (wr_data),
.control_o      (control_o_wr),
.addr	        (addr_wr),
.control_rd     (control_rd),
.median_i       (median_o),
.control_i      (control_o_m),
.interf         (interf)
);



blk_mem_gen_0 blk_mem_inst(
	.addra           (addr_wr), // signal coming from fsm_wr
.clka            (interf.clk_i),
.dina            (wr_data),
.wea             (control_o_wr),
.doutb           (rd_data),
.addrb           (addr_from_pico_o [2:0]),// signal coming from fsm_rd
.clkb            (interf.clk_i)
);

picoblaze_top picoblaze_top_inst(
.cpu_rst_i              (~interf.rstn_i),
.clk_i                  (interf.clk_i),
.interrupt_req_i        (control_rd),
.in_porta_i             (rd_data [7:0]),
.in_portb_i             (),
.in_portc_i             (),
.in_portd_i             (), 
.interrupt_ack_o        (interrupt_ack_o),
.write_strobe_o         (),
.k_write_strobe_o       (),
.read_strobe_o          (),
.out_portw_o            (addr_from_pico_o),
.out_portx_o            (avg_o),
.out_porty_o            (),
.out_portz_o        	(),
.out_portk0_o           (),
.out_portk1_o           (),
.port_id_o              ()
);
/*
fsm_rd fsm_rd_inst(
.avg_o       (avg_o),
.addr	     (addr_rd),
.rd_data     (rd_data),
.control_i   (control_rd),
.interf     (interf)
);

assign interrupt_req_i = control_rd;
property req_check;
      @(negedge interf.clk_i)  disable iff (interf.rstn_i)     
       (interrupt_req_i) |-> ##4 (interrupt_ack_o);   
    endproperty
req_check_Assert: assert property (req_check) $display(" INTERRUPT IS HIGH ");
*/

endmodule : top
