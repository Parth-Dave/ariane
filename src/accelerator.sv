module accelerator (
    rocc_cmd_t  rocc_cmd_i,
    logic       rocc_cmd_valid_i,
    logic       rocc_cmd_ready_o,
    
    rocc_resp_t rocc_resp_o,
    logic       rocc_resp_valid_o,
    logic       rocc_resp_ready_i
    
);
//Sample accelerator
/*User can either implement their RoCC accelerators here or in a seperate module and replace accelerator module with that module in ariane.sv*/
assign rocc_cmd_ready_o = 1'b1;
assign rocc_resp_o.resp_data = 64'hcccccccccccccccc;
assign rocc_resp_valid_o = 1'b1;
assign rocc_resp_o.resp_rd = 5'd9;
endmodule