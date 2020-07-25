module accelerator (
    input  rocc_cmd_t  rocc_cmd_i,
    input  logic       rocc_cmd_valid_i,
    output logic       rocc_cmd_ready_o,
    
    output rocc_resp_t rocc_resp_o,
    output logic       rocc_resp_valid_o,
    input  logic       rocc_resp_ready_i
    
);
//Sample accelerator
/*User can either implement their RoCC accelerators here or in a seperate module and replace accelerator module with that module in ariane.sv*/
assign rocc_cmd_ready_o = 1'b1;
assign rocc_resp_o.resp_data = 64'hcccccccccccccccc;
assign rocc_resp_valid_o = 1'b1;
assign rocc_resp_o.resp_rd = 5'd9;
endmodule